%MAIN GUI
%Please run "SDK_Sample_EN_run.m" to launch the interface selection GUI

function SDK_Sample_EN(nInterfaceCode,IPList,nDetectParam)
% clc

%PDC Input settings
PDC_DEV_VALUE

%play stop current frame variable
itemp = 0;
nDetectNo = uint32(IPList);
nDetectNum = 1;

%Initialize detect and open device
run_sub_Init_DetectOpen

if nRet == PDC_FAILED
    msgbox('Device was not opened','No device opened','Warn');
    clear all
    return;
end

%define uicontrol objects
run_uicontrol_EN

%run sub functions
run_sub_functions

%Total frames calculation
total_frame = nFrames;

%Handles settings
run_handles

%Menu initialisation
run_menu_init

%Callback settings
%run_set_callback
set(S.live_radio,'Callback',{@live_radio_Callback});
set(S.livestop_radio,'Callback',{@livestop_radio_Callback});
set(S.memory_radio,'Callback',{@memory_radio_Callback});
set(S.record_button,'Callback',{@record_button_Callback});
set(S.waiting_button,'Callback',{@waiting_button_Callback});
set(S.endless_button,'Callback',{@endless_button_Callback});
set(S.record_stop_button,'Callback',{@record_stop_button_Callback});
set(S.play_toggle_button,'Callback',{@play_toggle_button_Callback});
set(S.path_button,'Callback',{@path_button_Callback});
set(S.stop_button,'Callback',{@stop_button_Callback});
set(S.start_frame_edit,'Callback',{@start_frame_edit_Callback});
set(S.current_frame_edit,'Callback',{@current_frame_edit_Callback});
set(S.end_frame_edit,'Callback',{@end_frame_edit_Callback});
set(S.frame_slider,'Callback',{@frame_slider_Callback});
set(S.camera_toggle_button,'Callback',{@camera_toggle_button_Callback});
set(S.data_toggle_button,'Callback',{@data_toggle_button_Callback});
set(S.save_button,'Callback',{@save_button_Callback});
set(S.close_button,'Callback',{@close_button_Callback});
set(S.fh,'CloseRequestFcn',{@closeGUI});
set(S.recordrate_pop,'Callback',{@recordrate_pop_Callback});
set(S.shutter_pop,'Callback',@shutter_pop_Callback);
set(S.trigger_pop,'Callback',{@trigger_pop_Callback});
set(S.resolution_pop,'Callback',{@resolution_pop_Callback});
set(S.shading_pop,'Callback',{@shading_pop_Callback});
set(S.partition_t1_pop,'Callback',{@partition_t1_pop_Callback});
set(S.partition_t2_pop,'Callback',{@partition_t2_pop_Callback});
set(S.fh,'ResizeFcn',{@resizeGUI});


handles = guidata(S.fh); 
handles.recordTime = recordTime;
liveRate = 15;%times to be executed per second, i.e. live camera monitor
handles.tPlay = timer('ExecutionMode','fixedRate',...
    'Period',round((1/liveRate)*100)/100,'StartDelay',1,'Name','tPlay');
handles.tPlay.TimerFcn = {@OnLive,nDeviceNo,nChildNo,nMode,nBitDepth,nWidthMax,nHeightMax,n8BitSel,nBayer,S.close_button(2),S.livestop_radio,S.memory_radio,...,
     PDC_COLORTYPE_MONO,PDC_COLORTYPE_COLOR,PDC_FAILED,PDC_8BITSEL_10UPPER,PDC_FUNCTION_OFF,PDC_COLORDATA_INTERLEAVE_RGB};
guidata(S.fh, handles);
start(handles.tPlay);
%**************************************************************************
%**************************************************************************
%MAIN
% %Live mode on start
% OnLive(nDeviceNo,nChildNo,nMode,nBitDepth,nWidthMax,nHeightMax,n8BitSel,nBayer,S.close_button(2),S.livestop_radio,S.memory_radio,...,
%     PDC_COLORTYPE_MONO,PDC_COLORTYPE_COLOR,PDC_FAILED,PDC_8BITSEL_10UPPER,PDC_FUNCTION_OFF,PDC_COLORDATA_INTERLEAVE_RGB)
    if ~ishandle(S.close_button(2))
        sub_CloseDevice
        delete(gcf)
        clear all
    end
    
end 
%END MAIN
%**************************************************************************
%**************************************************************************

%Callback functions

%trigger pop
function trigger_pop_Callback(source, eventdata)
    handles = guidata(source);
    PDC_FAILED = handles.failed;
    nDeviceNo = handles.DeviceNo;
    PDC_TRIGGER_START = handles.trigger_start;
    PDC_TRIGGER_END = handles.trigger_end;
    PDC_TRIGGER_CENTER = handles.trigger_center;

    switch get(source,'Value')
        case 1
            sub_SetTriggerMode_Start
        case 2
            sub_SetTriggerMode_End
        case 3
            sub_SetTriggerMode_Center
    end

    if nRet == PDC_FAILED
        sub_GetTriggerMode;
        switch nTrgMode
            case PDC_TRIGGER_START
                set(handles.trigger_pop,'Value', 1);
            case PDC_TRIGGER_END
                set(handles.trigger_pop,'Value', 2);
            case PDC_TRIGGER_CENTER
                set(handles.trigger_pop,'Value', 3);
        end
    end

    handles.TriggerMode = nTrgMode;
    guidata(source,handles);
end

%close function
function closeGUI(source,evnt)
    handles = guidata(source);
    PDC_FAILED = handles.failed;
    nDeviceNo = handles.DeviceNo;    
    close_gcf(source);
end

%close button
function close_button_Callback(source, eventdata)
    handles = guidata(source);
    PDC_FAILED = handles.failed;
    nDeviceNo = handles.DeviceNo;
    close = handles.close_button(2);
    close_gcf(source);
end

%start frame edit box
function start_frame_edit_Callback(source, eventdata)
    handles = guidata(source);
    endframe = handles.endframe;
    slider = handles.slider;
    current_frame_edit = handles.current_frame_edit;
    start_txt = handles.static1_txt;
    partition_t2_pop = handles.partition_t2_pop;
    nDeviceNo = handles.DeviceNo;
    PDC_FAILED = handles.failed;
    PDC_STATUS_PLAYBACK = handles.status_playback;
    List2 = handles.List2;
    nChildNo = handles.ChildNo;
    %nChildNo = List2(get(partition_t2_pop,'Value'));
    %handles.ChildNo = List2(get(partition_t2_pop,'Value'));
    sub_GetColorType
    handles.Mode = nMode;
    sub_GetMemRecordRateResolution
    sub_GetMemFrameInfo
    
    start_frame_value = get(source,'String');
    current_frame_value = get(current_frame_edit,'String');
    end_frame_value = get(endframe,'String');

    start_value = str2num(start_frame_value);
    current_value = str2num(current_frame_value);
    end_value = str2num(end_frame_value);
 
    if ( start_value >= end_value || start_value < iStart )
        start_value = iStart;
        start_frame_value = num2str(start_value);
        set(source,'String',start_frame_value);
    elseif ( start_value >= current_value )
        start_value = current_value;
        start_frame_value = num2str(start_value);
        set(source,'String',start_frame_value);
    end
    
    set(slider,'Min',start_value,'Max',end_value,'SliderStep',[1/double(end_value-start_value) 50/double(end_value-start_value)],'Value',current_value);
    set(start_txt,'String',start_frame_value);
end

%end frame edit box
function end_frame_edit_Callback(source, eventdata)
    handles = guidata(source);
    startframe = handles.startframe;
    slider = handles.slider;
    current_frame_edit = handles.current_frame_edit;
    end_txt = handles.static4091_txt;
    partition_t2_pop = handles.partition_t2_pop;
    nDeviceNo = handles.DeviceNo;
    PDC_FAILED = handles.failed;
    PDC_STATUS_PLAYBACK = handles.status_playback;
    List2 = handles.List2;
    nChildNo = handles.ChildNo;
%     nChildNo = List2(get(partition_t2_pop,'Value'));
%     handles.ChildNo = List2(get(partition_t2_pop,'Value'));
    sub_GetColorType
    handles.Mode = nMode;
    sub_GetMemRecordRateResolution
    sub_GetMemFrameInfo
    
    start_frame_value = get(startframe,'String');
    current_frame_value = get(current_frame_edit,'String');
    end_frame_value = get(source,'String');

    start_value = str2num(start_frame_value);
    current_value = str2num(current_frame_value);
    end_value = str2num(end_frame_value);

    if ( end_value > iEnd || end_value <= start_value )
        end_value = iEnd;
        end_frame_value = num2str(end_value);        
        set(source,'String',num2str(end_frame_value));
    elseif ( end_value <= current_value )
        end_value = current_value;
        end_frame_value = num2str(end_value);        
        set(source,'String',num2str(end_frame_value));
    end

    set(slider,'Min',start_value,'Max',end_value,'SliderStep',[1/double(end_value-start_value) 50/double(end_value-start_value)],'Value',current_value);
    set(end_txt,'String',end_frame_value);    
end

%camera toggle button
function camera_toggle_button_Callback(source, eventdata)
    handles = guidata(source);
    data_toggle_button = handles.data_toggle_button;
    camera_panel = handles.camera_panel;
    data_save_panel = handles.data_save_panel;
    live_radio = handles.live_radio;
    partition_t1_pop = handles.partition_t1_pop;
    nDeviceNo = handles.DeviceNo;
    nChildNo = handles.ChildNo;
    PDC_FAILED = handles.failed;
    List2 = handles.List2;
    current_frame_edit = handles.current_frame_edit;
    frame_slider = handles.slider;
    
    nNo = get(partition_t1_pop,'Value');
    sub_SetCurrentPartition

    set(data_toggle_button,'Value',0);
    set(camera_panel,'Visible','On');
    set(data_save_panel,'Visible','Off');
    set(live_radio,'Value',1);
    set(current_frame_edit,'UserData',1);
    set(frame_slider,'UserData',1);
    handles.slider = frame_slider;
    handles.current_frame_edit = current_frame_edit;
      
    sub_GetColorType
    handles.Mode = nMode;
    guidata(source,handles);

    live_radio_Callback(live_radio);
end

%data toggle button
function data_toggle_button_Callback(source, eventdata)
    handles = guidata(source);
    camera_toggle_button = handles.camera_toggle_button;
    camera_panel = handles.camera_panel;
    data_save_panel = handles.data_save_panel;
    memory_radio = handles.memory_radio;
    live_radio = handles.live_radio;
    livestop_radio = handles.livestop_radio;
    record_button = handles.record_button;
    record_stop_button = handles.record_stop_button;
    waiting_button = handles.waiting_button;
    recording_toggle_button = handles.recording_toggle_button;
    partition_t2_pop = handles.partition_t2_pop;
    nDeviceNo = handles.DeviceNo;
    nChildNo = handles.ChildNo;
    PDC_FAILED = handles.failed;
    PDC_STATUS_PLAYBACK = handles.status_playback;
    start_frame_edit = handles.startframe;
    end_frame_edit = handles.endframe;
    frame_slider = handles.slider;
    static1_txt = handles.static1_txt;
    static4091_txt = handles.static4091_txt;
    nBitDepth = handles.BitDepth;
    PDC_COLORTYPE_MONO = handles.colortype_mono;
    PDC_COLORTYPE_COLOR = handles.colortype_color;
    PDC_8BITSEL_10UPPER = handles.eightbitsel_10upper;
    PDC_FUNCTION_OFF = handles.function_off;
    PDC_COLORDATA_INTERLEAVE_RGB = handles.colordata_interleave_rgb;
    current_frame_edit = handles.current_frame_edit;
    play_toggle_button = handles.play_toggle_button;
    current_frame_edit = handles.current_frame_edit;
    nWidthMax = handles.WidthMax;
    nHeightMax = handles.HeightMax;
    n8BitSel = handles.eightbitsel;
    nBayer = handles.Bayer;
    List2 = handles.List2;
    close = handles.close_button(2);
    current_frame_edit = handles.current_frame_edit;
    frame_slider = handles.slider;
    
    set(current_frame_edit,'UserData',1);
    set(frame_slider,'UserData',1);
    handles.start_frame_edit = start_frame_edit;
    handles.current_frame_edit = current_frame_edit;
    handles.end_frame_edit = end_frame_edit;
    handles.slider = frame_slider;
    set(play_toggle_button,'Enable','on');
    set(play_toggle_button,'Value',0);
    set(play_toggle_button,'UserData',0);
       
    set(source,'UserData',0);
    set(camera_toggle_button,'Value',0);
    set(camera_panel,'Visible','Off');
    set(data_save_panel,'Visible','On');
    set(memory_radio,'Value',1);
    set(live_radio,'Value',0);
    set(livestop_radio,'Value',0);
    set(record_button,'Enable','off');
    set(record_button,'Visible','on');
    set(waiting_button, 'Visible','off');
    set(recording_toggle_button, 'Visible','off');
    %nPartitionNo = List2(get(partition_t2_pop,'Value'));
    %handles.ChildNo = List2(get(partition_t2_pop,'Value'));
    sub_GetColorType
    handles.Mode = nMode;
    sub_GetMemRecordRateResolution
    handles.MemRecordRate = nRate;
    
    nNo = get(partition_t2_pop,'Value');
    sub_SetCurrentPartition
    sub_GetMemFrameInfo
    FrameNum = iCurrent;
    if FrameNum
        sub_GetMemImage
        sub_DispImage
    end
    handles.start = iStart;
    handles.end = iEnd;
        
    if iEnd>1
        set(frame_slider,'Min',iStart,'Max',iEnd,'SliderStep',[1/double(iEnd-iStart) 50/double(iEnd-iStart)],'Value',iCurrent);
    end
    
    set(start_frame_edit,'String',num2str(iStart));
    set(end_frame_edit,'String',num2str(iEnd));
    set(static1_txt,'String',num2str(iStart));
    set(static4091_txt,'String',num2str(iEnd));

    slider_value = get(frame_slider,'Value');
    current_frame_value = num2str(round(slider_value));
    set(current_frame_edit,'String',current_frame_value);
    
    if ishandle(close)
        guidata(source,handles);
    end  
end

%path button
function path_button_Callback(source, eventdata)
    handles = guidata(source);
    path_edit = handles.path_edit;

    folder_name = uigetdir;
    set(path_edit,'String',folder_name);
    set(path_edit,'Enable','on');
end

%record button
function record_button_Callback(source, eventdata)
handles = guidata(source);
waiting_button = handles.waiting_button;
memory_radio = handles.memory_radio;
nDeviceNo = handles.DeviceNo;
PDC_STATUS_RECREADY = handles.status_recready;
PDC_STATUS_REC = handles.status_rec;
PDC_FAILED = handles.failed;

set(memory_radio,'Enable','off');
set(source,'Visible','off');
set(waiting_button, 'Visible','on');
sub_SetRecReady

waiting_button_Callback(waiting_button);
end

%waiting button
function waiting_button_Callback(source, eventdata)
    handles = guidata(source);
    recording_toggle_button = handles.recording_toggle_button;
    record_button = handles.record_button;
    recordrate_pop = handles.recordrate_pop;
    record_stop_button = handles.record_stop_button; 
    nBitDepth = handles.BitDepth;
    nMode = handles.Mode;
    nWidth = handles.Width;
    nHeight = handles.Height;
    nWidthMax = handles.WidthMax;
    nHeightMax = handles.HeightMax;
    PDC_COLORTYPE_MONO = handles.colortype_mono;
    PDC_COLORTYPE_COLOR = handles.colortype_color;
    trigger_pop = handles.trigger_pop;
    slider = handles.slider;
    current_frame_edit = handles.current_frame_edit;
    livestop_radio = handles.livestop_radio;
    memory_radio = handles.memory_radio;
    endless_button = handles.endless_button;
    
    nDeviceNo = handles.DeviceNo;
    nChildNo = handles.ChildNo;
    PDC_FAILED = handles.failed;
    PDC_STATUS_RECREADY = handles.status_recready;
    PDC_STATUS_REC = handles.status_rec;
    PDC_STATUS_LIVE = handles.status_live;
    PDC_8BITSEL_10UPPER = handles.eightbitsel_10upper;
    PDC_FUNCTION_OFF = handles.function_off;
    PDC_COLORDATA_INTERLEAVE_RGB = handles.colordata_interleave_rgb;
    PDC_STATUS_ENDLESS = handles.status_endless;
    close = handles.close_button(2);
%     stop = handles.record_stop_button(2);
    total_frame = handles.total_frame;
    fig = handles.figure;
    play_toggle_button = handles.play_toggle_button;
    data_toggle_button = handles.data_toggle_button;
    n8BitSel = handles.eightbitsel;
    nBayer = handles.Bayer;
    partition_t1_pop = handles.partition_t1_pop;
    List2 = handles.List2;
    trigger_pop_value = get(trigger_pop,'Value');
%     nChildNo = List2(get(partition_t1_pop,'Value'));
%     handles.ChildNo = List2(get(partition_t1_pop,'Value'));
    sub_GetColorType
    handles.Mode = nMode;
    
    set(memory_radio,'Enable','off');
    set(data_toggle_button,'Enable','off');
    set(source,'Visible','off');
    set(play_toggle_button,'UserData',0);
    
    if ( get(trigger_pop,'Value') == 1 )
        %Trigger START
        set(recording_toggle_button ,'Visible','on');
        set(recording_toggle_button ,'Enable','off');
        set(record_stop_button ,'Enable','on');
        set(recording_toggle_button ,'Value',1);
        set(source,'UserData',1);
        sub_TriggerIn
    else
        %Trigger END & CENTER
        set(endless_button ,'Visible','on');
        sub_SetEndless
    end
    
    guidata(source,handles);
end

%endless button
% function endless_button_Callback(source,eventdata)
%     handles = guidata(source);
%     memory_radio = handles.memory_radio;
%     waiting_button = handles.waiting_button;
%     trigger_pop = handles.trigger_pop;
%     endless_button = handles.endless_button;
%     PDC_FAILED = handles.failed;
%     PDC_STATUS_ENDLESS = handles.status_endless;
%     PDC_STATUS_REC = handles.status_rec;
%     PDC_STATUS_RECREADY = handles.status_recready;
%     PDC_COLORTYPE_MONO = handles.colortype_mono;
%     PDC_COLORTYPE_COLOR = handles.colortype_color;
%     PDC_STATUS_PLAYBACK  = handles.status_playback;
%     PDC_STATUS_LIVE = handles.status_live; 
%     PDC_COLORDATA_INTERLEAVE_RGB = handles.colordata_interleave_rgb;
%     
%     nMode = handles.Mode;
%     nDeviceNo = handles.DeviceNo;
%     nChildNo = handles.ChildNo;
%     endless_button = handles.endless_button;
%     livestop_radio = handles.livestop_radio;
%     nWidthMax = handles.WidthMax;
%     nHeightMax = handles.HeightMax;
%     nBitDepth = handles.BitDepth;
%     slider = handles.slider;
%     current_frame_edit = handles.current_frame_edit;
%     close = handles.close_button(2);
% %     stop = handles.record_stop_button(2);
%     total_frame = handles.total_frame;
%     fig = handles.figure;
%     play_toggle_button = handles.play_toggle_button;
%     data_toggle_button = handles.data_toggle_button;
%     recording_toggle_button = handles.recording_toggle_button;
%     record_button = handles.record_button;
%     record_stop_button = handles.record_stop_button;
%     n8BitSel = handles.eightbitsel;
%     nBayer = handles.Bayer;
%     set(data_toggle_button,'Enable','on');
%     
%     sub_GetTriggerMode
%     if ( nTriggerMode == bitshift(hex2dec('02'),24) )
%         %Trigger END
%         set(source,'Visible','off');
%     else
%         %Trigger CENTER
%         set(recording_toggle_button,'Visible','On');
%         set(recording_toggle_button,'Value',1);
%         set(recording_toggle_button,'Enable','Off');
%         set(data_toggle_button,'Enable','off');
%     end
%     sub_TriggerIn
%     guidata(source,handles);
% end

%record stop button
function record_stop_button_Callback(source, eventdata)
    handles = guidata(source);
    nDeviceNo = handles.DeviceNo;
    PDC_STATUS_LIVE = handles.status_live; 
    PDC_FAILED = handles.failed;    
    record_button = handles.record_button;
    memory_radio = handles.memory_radio;
    recording_toggle_button = handles.recording_toggle_button;
    waiting_button = handles.waiting_button;
    data_toggle_button = handles.data_toggle_button;
    endless_button = handles.endless_button;
        
    set(data_toggle_button ,'Enable','on');
    set(memory_radio,'Enable','on');
    set(record_button,'Visible','on');
    set(waiting_button, 'Visible','off');
    set(endless_button, 'Visible','off');
    set(recording_toggle_button, 'Visible','off');
    
    set(waiting_button,'UserData',0);
    sub_SetStatusLive
    guidata(source,handles);
end

%partition tab1 pop menu
function partition_t1_pop_Callback(source, eventdata, handles)
   handles = guidata(source);
   nDeviceNo = handles.DeviceNo;
   nChildNo = handles.ChildNo;
   List2 = handles.List2;
   PDC_FAILED = handles.failed;

%    close = handles.close_button(2);
%    live_radio = handles.live_radio;
%    memory_radio = handles.memory_radio;
%    livestop_radio = handles.livestop_radio;
%    nBitDepth = handles.BitDepth;
%    nWidthMax = handles.WidthMax;
%    nHeightMax = handles.HeightMax;

%    PDC_COLORTYPE_MONO = handles.colortype_mono;
%    PDC_COLORTYPE_COLOR = handles.colortype_color;
%    PDC_8BITSEL_10UPPER = handles.eightbitsel_10upper;
%    PDC_FUNCTION_OFF = handles.function_off;
%    PDC_COLORDATA_INTERLEAVE_RGB = handles.colordata_interleave_rgb;
%    PDC_STATUS_PLAYBACK = handles.status_playback;
%    n8BitSel = handles.eightbitsel;
%    nBayer = handles.Bayer;
%    data_toggle_button = handles.data_toggle_button;
   
   nPartition = get(source,'Value');

   if strcmp(handles.tPlay.Running,'on'),stop(handles.tPlay),end

   [nRet,nErrorCode] = PDC_SetCurrentPartition(nDeviceNo,nChildNo,nPartition);
   if nRet == PDC_FAILED
       disp(['PDC_SetPartitionList Error : ' num2str(nErrorCode)]);
   end

   if strcmp(handles.tPlay.Running,'off'),start(handles.tPlay),end
   
%    if ishandle(close)
%         guidata(source,handles);
%    end
end

%partition tab2 pop menu
function partition_t2_pop_Callback(source, eventdata)
   handles = guidata(source);
   nDeviceNo = handles.DeviceNo;
   nChildNo = handles.ChildNo;
   PDC_FAILED = handles.failed;
    partition_t2_pop = handles.partition_t2_pop;
    start_frame_edit = handles.startframe;
    end_frame_edit = handles.endframe;
    frame_slider = handles.slider;
    static1_txt = handles.static1_txt;
    static4091_txt = handles.static4091_txt;
    current_frame_edit = handles.current_frame_edit;
    List2 = handles.List2;
    close = handles.close_button(2);

%    PDC_STATUS_PLAYBACK = handles.status_playback;
%    List2 = handles.List2;
%    nBitDepth = handles.BitDepth ;
%    PDC_COLORTYPE_MONO = handles.colortype_mono;
%    PDC_COLORTYPE_COLOR = handles.colortype_color;
%    PDC_8BITSEL_10UPPER = handles.eightbitsel_10upper;
%    PDC_FUNCTION_OFF = handles.function_off;
%    PDC_COLORDATA_INTERLEAVE_RGB = handles.colordata_interleave_rgb;
%    slider = handles.slider;
%    close = handles.close_button(2);
%    nWidthMax = handles.WidthMax;
%    nHeightMax = handles.HeightMax;
%    n8BitSel = handles.eightbitsel;
%    nBayer = handles.Bayer;
   


   if strcmp(handles.tPlay.Running,'on'),stop(handles.tPlay),end

    nNo = get(source,'Value');
    sub_SetCurrentPartition
    sub_GetMemFrameInfo
    FrameNum = iCurrent;
    handles.start = iStart;
    handles.end = iEnd;
        
    if iEnd>1
        set(frame_slider,'Min',iStart,'Max',iEnd,'SliderStep',[1/double(iEnd-iStart) 50/double(iEnd-iStart)],'Value',iCurrent);
    end
    
    set(start_frame_edit,'String',num2str(iStart));
    set(end_frame_edit,'String',num2str(iEnd));
    set(static1_txt,'String',num2str(iStart));
    set(static4091_txt,'String',num2str(iEnd));

    slider_value = get(frame_slider,'Value');
    current_frame_value = num2str(round(slider_value));
    set(current_frame_edit,'String',current_frame_value);


   if strcmp(handles.tPlay.Running,'off'),start(handles.tPlay),end

end

%live radio button
function live_radio_Callback(source,eventdata,handles)
    handles = guidata(source);
    livestop_radio = handles.livestop_radio;
    memory_radio = handles.memory_radio;
    record_button = handles.record_button;
    record_stop_button = handles.record_stop_button;
    nDeviceNo = handles.DeviceNo;
    nChildNo = handles.ChildNo;
    nBitDepth = handles.BitDepth;
    nWidth = handles.Width;
    nHeight = handles.Height;
    nWidthMax = handles.WidthMax;
    nHeightMax = handles.HeightMax;
    nMode = handles.Mode;
    PDC_FAILED = handles.failed;
    PDC_COLORTYPE_MONO  = handles.colortype_mono;
    PDC_COLORTYPE_COLOR = handles.colortype_color;
    PDC_STATUS_PLAYBACK = handles.status_playback;
    PDC_STATUS_LIVE = handles.status_live;
    PDC_8BITSEL_10UPPER = handles.eightbitsel_10upper;
    PDC_FUNCTION_OFF = handles.function_off;
    PDC_COLORDATA_INTERLEAVE_RGB = handles.colordata_interleave_rgb;
    n8BitSel = handles.eightbitsel;
    nBayer = handles.Bayer;
    close = handles.close_button(2);
    close_button = handles.close_button;
    partition_t1_pop = handles.partition_t1_pop;
    List2 = handles.List2;
    
%     partition_t1_pop_value = get(partition_t1_pop,'Value');
%     nChildNo = List2(partition_t1_pop_value);
    
    sub_GetColorType
    sub_SetStatusLive
    
    set(livestop_radio,'Value',0);
    set(memory_radio,'Value',0);
    set(record_button,'Enable','on');
    set(record_stop_button,'Enable','on');
    live_value = get(source,'Value');
    if ( live_value == 0 )
        set(source,'Value',1);
    end    

    if strcmp(handles.tPlay.Running,'off'),start(handles.tPlay),end
%     OnLive(nDeviceNo,nChildNo,nMode,nBitDepth,nWidthMax,nHeightMax,n8BitSel,nBayer,close,livestop_radio,memory_radio,...,
%     PDC_COLORTYPE_MONO,PDC_COLORTYPE_COLOR,PDC_FAILED,PDC_8BITSEL_10UPPER,...,
%     PDC_FUNCTION_OFF,PDC_COLORDATA_INTERLEAVE_RGB)

if ~ishandle(close)
    if strcmp(handles.tPlay.Running,'on'),stop(handles.tPlay),end
    sub_CloseDevice
    delete(gcf)
    clear all
else
    guidata(source,handles);
end
end

%close_gcf
function close_gcf(source)
handles = guidata(source);
close = handles.close_button(2);
live_radio = handles.live_radio;
nDeviceNo = handles.DeviceNo;
PDC_FAILED = handles.failed;

%save current camera settings
camera.RecordingSpeed = handles.RecordingSpeed;
camera.nWidth = handles.Width;   
camera.nHeight = handles.Height;
camera.nFps = handles.nFps;
camera.nTrgMode = handles.TriggerMode;
camera.recordTime = handles.recordTime;
[fpath ~] = fileparts(mfilename('fullpath'));
cameraFile = [fpath,'\Photron_cameraSettings.mat'];
save(cameraFile,"camera");

live_status = get(live_radio,'Value');
if live_status
    if strcmp(handles.tPlay.Running,'on'),stop(handles.tPlay),end
end

if ishandle(close)
    delete(close)
end

%if( live_status == 0 )
sub_CloseDevice
delete(handles.figure)

end

%livestop radio button 
function livestop_radio_Callback(source, eventdata)
    handles = guidata(source);
    live_radio = handles.live_radio;
    memory_radio = handles.memory_radio;
    record_button = handles.record_button;
    recording_toggle_button = handles.recording_toggle_button;
    waiting_button = handles.waiting_button;
    record_stop_button = handles.record_stop_button;
    
    set(live_radio,'Value',0);
    set(memory_radio,'Value',0);
%     set(record_button,'Enable','off');
%     set(recording_toggle_button,'Visible','off');
%     set(waiting_button,'Visible','off');
%     set(record_button,'Visible','on');
%     set(record_stop_button,'Enable','off');
    set(memory_radio,'Enable','on');
    livestop_value = get(source,'Value');
    if ( livestop_value == 0 )
        set(source,'Value',1);
    end
end

%memory radio button 
function memory_radio_Callback(source, eventdata)
    handles = guidata(source);
    livestop_radio = handles.livestop_radio;
    live_radio = handles.live_radio;
    record_button = handles.record_button;
    record_stop_button = handles.record_stop_button;
    nDeviceNo = handles.DeviceNo;
    nChildNo = handles.ChildNo;
    nBitDepth = handles.BitDepth;
    nMode = handles.Mode;
    PDC_FAILED = handles.failed;
    PDC_STATUS_PLAYBACK = handles.status_playback;
    PDC_COLORTYPE_MONO = handles.colortype_mono;
    PDC_COLORTYPE_COLOR = handles.colortype_color;    
    PDC_COLORDATA_INTERLEAVE_RGB = handles.colordata_interleave_rgb;
    PDC_8BITSEL_10UPPER = handles.eightbitsel_10upper;
    PDC_FUNCTION_OFF = handles.function_off;
    nWidthMax = handles.WidthMax;
    nHeightMax = handles.HeightMax;
    n8BitSel = handles.eightbitsel;
    nBayer = handles.Bayer;
    partition_t1_pop = handles.partition_t1_pop;
    List2 = handles.List2;
    
%     partition_t1_pop_value = get(partition_t1_pop,'Value');
%     nChildNo = List2(partition_t1_pop_value);
    
    sub_GetColorType
    
    set(livestop_radio,'Value',0);
    set(live_radio,'Value',0);
    set(record_button,'Enable','off');
    set(record_stop_button,'Enable','off');
    memory_value = get(source,'Value');
    if ( memory_value == 0 )
        set(source,'Value',1);
    end
    
    sub_GetMemRecordRateResolution
    handles.MemRecordRate = nRate;
    guidata(source,handles);
    sub_GetMemFrameInfo
    FrameNum = get(source,'Value');
    sub_GetMemImage
    sub_DispImage
end

%current frame edit box 
function current_frame_edit_Callback(source, eventdata)
    handles = guidata(source); 
    frame_slider = handles.slider;
    start_frame_edit = handles.startframe;
    end_frame_edit = handles.endframe;
    
    current_frame_value = get(source,'String');
    start_frame_value = get(start_frame_edit,'String');
    end_frame_value = get(end_frame_edit,'String');    
    
    current_value = str2num(current_frame_value);
    start_value = str2num(start_frame_value);
    end_value = str2num(end_frame_value);
    
    if ( current_value <= start_value )
       set(source,'String',start_frame_value); 
       current_value = start_value;
    elseif ( current_value >= end_value )
       set(source,'String',end_frame_value); 
       current_value = end_value;       
    end
    
    slider_value = current_value;
    set(frame_slider,'Value',slider_value);
    
    nDeviceNo = handles.DeviceNo;
    nChildNo = handles.ChildNo;
    nBitDepth = handles.BitDepth;
    nMode = handles.Mode;
    PDC_FAILED = handles.failed;
    PDC_STATUS_PLAYBACK = handles.status_playback;
    PDC_COLORTYPE_MONO = handles.colortype_mono;
    PDC_COLORTYPE_COLOR = handles.colortype_color;    
    PDC_COLORDATA_INTERLEAVE_RGB = handles.colordata_interleave_rgb;
    PDC_8BITSEL_10UPPER = handles.eightbitsel_10upper;
    PDC_FUNCTION_OFF = handles.function_off;
    nWidthMax = handles.WidthMax;
    nHeightMax = handles.HeightMax;
    n8BitSel = handles.eightbitsel;
    nBayer = handles.Bayer;
    partition_t1_pop = handles.partition_t1_pop;
    List2 = handles.List2;
    
%     partition_t1_pop_value = get(partition_t1_pop,'Value');
%     nChildNo = List2(partition_t1_pop_value);
    
    sub_GetColorType
    
    sub_GetMemRecordRateResolution
    handles.MemRecordRate = nRate;
    guidata(source,handles);
    sub_GetMemFrameInfo
    FrameNum = slider_value;
    sub_GetMemImage
    sub_DispImage
end

%frame slider
function frame_slider_Callback(source, eventdata)
    handles = guidata(source); 
    nDeviceNo = handles.DeviceNo;
    nChildNo = handles.ChildNo;
    PDC_FAILED = handles.failed;
    nBitDepth = handles.BitDepth;
    nMode = handles.Mode;
    PDC_COLORTYPE_MONO = handles.colortype_mono;
    PDC_COLORTYPE_COLOR = handles.colortype_color;
    current_frame_edit = handles.current_frame_edit;
    play_toggle_button = handles.play_toggle_button;
    current_frame_edit = handles.current_frame_edit;
    PDC_STATUS_PLAYBACK = handles.status_playback;
    PDC_8BITSEL_10UPPER = handles.eightbitsel_10upper;
    PDC_FUNCTION_OFF = handles.function_off;
    PDC_COLORDATA_INTERLEAVE_RGB = handles.colordata_interleave_rgb;
    nWidthMax = handles.WidthMax;
    nHeightMax = handles.HeightMax;
    n8BitSel = handles.eightbitsel;
    nBayer = handles.Bayer;
    partition_t2_pop = handles.partition_t2_pop;
    List2 = handles.List2;
    
    sub_GetColorType
    
    set(play_toggle_button,'Enable','on');
    set(play_toggle_button,'Value',0);
    set(play_toggle_button,'UserData',0);
    
    slider_value = get(source,'Value');
    current_frame_value = num2str(round(slider_value));
    set(current_frame_edit,'String',current_frame_value);
    set(source,'UserData',0);
    
    sub_GetMemFrameInfo
    
    FrameNum = slider_value;
    
    sub_GetMemRecordRateResolution
    sub_GetMemImage
    sub_DispImage
end

%play toggle button
function play_toggle_button_Callback(source, eventdata)
    handles = guidata(source);
    nDeviceNo = handles.DeviceNo;
    nChildNo = handles.ChildNo;
    PDC_FAILED = handles.failed;
    nBitDepth = handles.BitDepth;
    nMode = handles.Mode;
    PDC_COLORTYPE_MONO = handles.colortype_mono;
    PDC_COLORTYPE_COLOR = handles.colortype_color;
    frame_slider = handles.slider;
    current_frame_edit = handles.current_frame_edit;
    PDC_STATUS_PLAYBACK = handles.status_playback;
    PDC_8BITSEL_10UPPER = handles.eightbitsel_10upper;
    PDC_FUNCTION_OFF = handles.function_off;
    PDC_COLORDATA_INTERLEAVE_RGB = handles.colordata_interleave_rgb;
    itemp = handles.itemp;

    close = handles.close_button(2);

    frame_value = get(frame_slider,'Value');
    nWidthMax = handles.WidthMax;
    nHeightMax = handles.HeightMax;
    n8BitSel = handles.eightbitsel;
    nBayer = handles.Bayer;
    nTriggerMode = handles.TriggerMode;
    List2 = handles.List2;
    partition_t2_pop = handles.partition_t2_pop;
    startframe = handles.startframe;
    endframe = handles.endframe;
    
    start_value_str = get(startframe,'String');
    end_value_str = get(endframe,'String');
    
    start_value = str2num(start_value_str);
    end_value = str2num(end_value_str);

    sub_GetColorType
    
    set(source,'UserData',1);
    set(source,'Enable','off');
    sub_GetMemRecordRateResolution
    
    set(frame_slider,'UserData',0);

    sub_GetMemFrameInfo
    sub_GetMemImage_Trigger
end

%stop button
function stop_button_Callback(source, eventdata)
    handles = guidata(source); 
    play_toggle_button = handles.play_toggle_button;
    set(play_toggle_button,'Enable','on');
    set(play_toggle_button,'Value',0);
    set(play_toggle_button,'UserData',0);
end

%save button
function save_button_Callback(source, eventdata)
    handles = guidata(source); 
    filename_edit = handles.filename_edit;
    path_edit = handles.path_edit;
    nDeviceNo = handles.DeviceNo;
    nChildNo = handles.ChildNo;
    PDC_FAILED = handles.failed;
    format_pop = handles.format_pop;
    fh = handles.axes;
    PDC_COLORTYPE_MONO = handles.colortype_mono;
    PDC_STATUS_PLAYBACK = handles.status_playback;
    nMode = handles.Mode;
    nBitDepth = handles.BitDepth;
    current_frame_edit = handles.current_frame_edit;
    PDC_COLORDATA_INTERLEAVE_BGR = handles.colordata_interleave_bgr;
    PDC_COLORDATA_INTERLEAVE_RGB = handles.colordata_interleave_rgb;
    current_frame = get(current_frame_edit,'String');
    nFrameNo = str2num(current_frame);
    FrameNum =  nFrameNo;
    List2 = handles.List2;
    partition_t2_pop = handles.partition_t2_pop;
    nWidthMax = handles.WidthMax;
    nHeightMax = handles.HeightMax;
    startframe = handles.startframe;
    endframe = handles.endframe;
    sub_GetColorType
    
    format = get(format_pop,'Value');
    path = get(path_edit,'Enable');
    n8BitSel                = handles.eightbitsel;
    nBayer                  = handles.Bayer;
    nInterleave             = PDC_COLORDATA_INTERLEAVE_BGR;
    
    sub_SetTransferOption
    sub_GetMemResolution
    
    nStartFrame = get(startframe,'String');
    nEndFrame = get(endframe,'String');
    
    sub_SetBurstTransfer
    sub_SetReadAheadTransfer
    
    switch (path)
        
        case 'off'
        msgbox('Please select a folder','No folder chosen','help');
        
        otherwise
                
        lpszFileName = strcat(get(path_edit,'String'),'\',get(filename_edit,'String'));
        if ( format == 1 ) %AVI
            lpszFileName = strcat(lpszFileName,'.avi');

            %nPlayRate = handles.MemRecordRate;
            sub_GetMemRecordRateResolution
            nPlayRate = nRate;

            nShowCompressDlg = 1;
            sub_GetMemFrameInfo
            start_value = get(startframe,'String');
            end_value = get(endframe,'String');
            
            iStart = str2num(start_value);
            iEnd = str2num(end_value);

            %sub_AviFileSave
            sub_AviFileSave_JRC
            
            if nRet ~= PDC_FAILED && (stopBar == 0)
                disp(strcat(get(filename_edit,'String'),'.avi',' has been saved'));
            end

        elseif ( format == 2 ) %JPEG
            lpszFileName = strcat(lpszFileName,'.jpg');

            if ( nMode == PDC_COLORTYPE_MONO )
                sub_GetMemImage
                colormap( gray(256) );
                imwrite(nBuf',lpszFileName);
            else
                nInterleave             = PDC_COLORDATA_INTERLEAVE_RGB;
                sub_SetTransferOption
                sub_GetMemImage
                imwrite(permute( nBuf, [3 2 1] ),lpszFileName);
            end
            
            if nRet ~= PDC_FAILED
                msgbox(strcat(strcat(get(filename_edit,'String'),'.jpg'),' has been saved'),'Save','help');
            end
           
        elseif ( format == 3 ) %BMP
            lpszFileName = strcat(lpszFileName,'.bmp');
            sub_BMPFileSave
            
            if nRet ~= PDC_FAILED            
                msgbox(strcat(strcat(get(filename_edit,'String'),'.bmp'),' has been saved'),'Save','help');
            end
        end
    end
end

%record rate pop button
function recordrate_pop_Callback(source, eventdata)
   handles = guidata(source);
   shutter_pop = handles.shutter_pop;
   resolution_pop = handles.resolution_pop;
   record_time_txt = handles.record_time_txt;
   nDeviceNo = handles.DeviceNo;
   nChildNo = handles.ChildNo;
   PDC_FAILED = handles.failed;
   FALSE = handles.false;
   TRUE = handles.true;
   %JL comment out the following two statements because it seems
   %unnecessary
%    set(resolution_pop,'Value',1); 
%    resolution_pop_Callback(resolution_pop);
   record_value = get(source,'Value');
   nRecordRateSize = handles.RecordRateSize;
   nRecordRateList = handles.RecordRateList;
   nShutterList = handles.ShutterList;
   nShutterSize = handles.ShutterSize;
   nResolutionList = handles.ResolutionList;
   nResolutionSize = handles.ResolutionSize;
   
   %Set record rate
   for x=1:nRecordRateSize
      if ( x == record_value )
          RecordingSpeed = nRecordRateList(x);
          sub_SetRecordRate
          nFps = RecordingSpeed;
          sub_SetShutterSpeedFps
      end      
   end
   
   sub_GetShutterSpeedFpsList
   for x=1:nShutterSize
        MyShutter{x} = [ '1/' num2str(nShutterList(x)) ' sec']; 
   end
   
   set(shutter_pop,'String',MyShutter);
   
   for x=1:nShutterSize
      if ( RecordingSpeed == nShutterList(x) )
          set(shutter_pop,'Value',x)
      end      
   end
   
   sub_GetResolution
   nResolutionList_t = bitshift(nWidth,16);
   nResolutionList_t = nResolutionList_t + nHeight;
   
    for x=1:nResolutionSize
      if ( nResolutionList(x) == nResolutionList_t )
          set(resolution_pop,'Value',x);
      end
    end

    memSize = 4.5553e+10/2;
    frameNum = memSize/(nWidth*nHeight);
    recordTime = floor(frameNum/RecordingSpeed);
    recordTimeTxt = ['Record Time: ', num2str(recordTime), ' Sec'];
    set(record_time_txt, 'String', recordTimeTxt);

   handles.RecordingSpeed = RecordingSpeed;
   handles.Width = nWidth;
   handles.Height = nHeight;
   handles.nFps = RecordingSpeed;
   handles.recordTime = recordTime;
   handles.ShutterList = nShutterList;
   handles.ShutterSize = nShutterSize;
   guidata(source,handles);
end

%shutter rate pop button
function shutter_pop_Callback(source, eventdata)
   handles = guidata(source);
   shutter_pop = handles.shutter_pop;
   nDeviceNo = handles.DeviceNo;
   nChildNo = handles.ChildNo;
   PDC_FAILED = handles.failed;
   FALSE = handles.false;
   TRUE = handles.true;
   nShutterList = handles.ShutterList;
   nShutterSize = handles.ShutterSize;
   shutter_value = get(source,'Value');
   
   %Set shutter rate
    for x=1:nShutterSize
      if ( x == shutter_value )
          nFps = nShutterList(x);
          sub_SetShutterSpeedFps
      end      
    end

    %shutter value
    handles.nFps = nFps;  
    guidata(source,handles);
end

%resolution pop button
function resolution_pop_Callback(source,eventdata)
   handles = guidata(source);
   nWidthMax = handles.WidthMax;
   nHeightMax = handles.HeightMax;
   resolution_pop_value = get(source,'Value');
   record_time_txt = handles.record_time_txt;
   nDeviceNo = handles.DeviceNo;
   nChildNo = handles.ChildNo;
   PDC_FAILED = handles.failed;
   nResolutionList = handles.ResolutionList;
   nResolutionSize = handles.ResolutionSize;
   resolution_value = get(source,'Value');
   
   %Set resolution
    for x=1:nResolutionSize
      if ( x == resolution_value )
          nWidth = bitshift(nResolutionList(x),-16);
          nHeight = bitand(hex2dec('FFFF'),nResolutionList(x));
          sub_SetResolution
      end      
    end

   memSize = 4.5553e+10/2; %two partitions 
   frameNum = memSize/(nWidth*nHeight);
   recordTime = floor(frameNum/handles.RecordingSpeed);
   recordTimeTxt = ['Record Time: ', num2str(recordTime), ' Sec'];
   set(record_time_txt, 'String', recordTimeTxt);

   handles.Width = nWidth;
   handles.Height = nHeight;
   handles.recordTime = recordTime;
   guidata(source,handles);
end

%Shading pop menu
function shading_pop_Callback(source, eventdata)
   handles = guidata(source);
   nDeviceNo = handles.DeviceNo;
   nChildNo = handles.ChildNo;
   PDC_SHADING_ON = handles.shading_on;
   PDC_FAILED = handles.failed;
   nMode = PDC_SHADING_ON;
   
   selection = questdlg('A black level correction is required (shading calibration). Please cover the sensor before proceeding. Press "OK" when ready',...
                     'Shading confirmation',...
                     'Yes','No','Yes');
   switch selection,
       case 'Yes',
        sub_SetShadingMode
        return
       case 'No'
         return
   end
end

%Live mode
function OnLive(obj,event, nDeviceNo,nChildNo,nMode,nBitDepth,nWidthMax,nHeightMax,n8BitSel,nBayer,close,livestop,memory,...,
    PDC_COLORTYPE_MONO,PDC_COLORTYPE_COLOR,PDC_FAILED,PDC_8BITSEL_10UPPER,PDC_FUNCTION_OFF,PDC_COLORDATA_INTERLEAVE_RGB)
    handles = guidata(close);
    ax = handles.axes;
switch nMode
    case PDC_COLORTYPE_MONO
       
     if ishandle(close)

        livestop_value = get(livestop,'Value');
        memory_value = get(memory,'Value');

        if ( livestop_value == 1 || memory_value == 1 )
            if strcmp(handles.tPlay.Running,'on'),stop(handles.tPlay),end
            return;
        end

        sub_GetResolution
        sub_GetLiveImage
        colormap( gray(256) );
        image(ax,nBuf');
        drawnow
        %pause(0.01);
    end
        
    case PDC_COLORTYPE_COLOR
        
    nInterleave = PDC_COLORDATA_INTERLEAVE_RGB;
    sub_SetTransferOption
    
    if ishandle(close)
        livestop_value = get(livestop,'Value');
        memory_value = get(memory,'Value');

        if ( livestop_value == 1 || memory_value == 1 )
            return;
        end
        sub_GetResolution
        sub_GetLiveImage

        if ( nWidth ~= nWidthMax )
            A = ones(nWidthMax - nWidth,nHeight,3);
            nBuf = permute(nBuf,[2 3 1]);
            B = [ nBuf ; A ];
            C = ones(nWidthMax, nHeightMax - nHeight);
            D1 = [B(:,:,1)  C];
            D2 = [B(:,:,2) C];
            D3 = [B(:,:,3) C];
            clear nBuf
            nBuf(:,:,1) = D1;
            nBuf(:,:,2) = D2;
            nBuf(:,:,3) = D3;
            image(permute(nBuf,[ 2 1 3 ]));
            %truesize(permute(nBuf,[ 2 1 3 ]));
        else
            image( permute( nBuf, [3 2 1] ));
            %truesize(permute(nBuf,[ 2 1 3 ]));
        end
        drawnow
    end
end

end

%figure resize
function resizeGUI(source,eventdata)
    handles = guidata(source);
    camera_display_panel = handles.camera_display_panel;
    ax = handles.axes;
    ax_oldunits = get(ax,'Units');
    set(ax,'Parent',camera_display_panel,'Units','normalized', 'Position', [.07 .1 .85 .85]);
    set(ax,'Units','pix');
    ax_pos = get(ax,'Position');

    if ( ax_pos(3)/ax_pos(4) > 1 )
       ax_pos(3) = ax_pos(4);
    else
        ax_pos(4) = ax_pos(3);
    end
    set(ax,'Position',ax_pos);
    
    set(ax,'Units',ax_oldunits);
    guidata(source,handles);
end

% use an unused button, endless_button, to save background image 
function endless_button_Callback(source,eventdata,BGIName)
handles = guidata(source);
nDeviceNo = handles.DeviceNo;
nChildNo = handles.ChildNo;
nBitDepth = handles.BitDepth;
nWidth = handles.Width;
nHeight = handles.Height;
nWidthMax = handles.WidthMax;
nHeightMax = handles.HeightMax;
nMode = handles.Mode;
nBayer = handles.Bayer;
PDC_FAILED = handles.failed;

backAvgCt = 15;
backgrArray = uint8(zeros(double([nHeight,nWidth,backAvgCt])));
for iterBack = 1:backAvgCt
    sub_GetLiveImage
    backgrArray(:,:,iterBack) = nBuf';
end
backgrFrm = mean(backgrArray,3);
imwrite(uint8(backgrFrm),BGIName);
end