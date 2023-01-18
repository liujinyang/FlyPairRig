%メインGUIのリスト取得

%ヘッドリスト
Maxpartition = 2;
for i=1:Maxpartition
        List2(i) = i;
end       

for x=1:Maxpartition
    MyPartitionCell{x} = ['partition' num2str(List2(x))];
end

%撮影速度リスト
for x=1:nRecordRateSize
   MyRecord{x} = [ num2str(nRecordRateList(x)) ' fps']; 
end

%解像度リスト
for x=1:nResolutionSize
   MyResolution{x} = [ num2str(bitshift(nResolutionList(x),-16)) ' x ' num2str(bitand(hex2dec('FFFF'),nResolutionList(x)))]; 
end

%シャッター速度リスト
for x=1:nShutterSize
   MyShutter{x} = [ '1/' num2str(nShutterList(x)) ' sec']; 
end

%handles 構造体
handles = guihandles(S.fh); 

%テキスト
handles.static1_txt = S.static1_txt;
handles.static4091_txt = S.static4091_txt;

%PDCの常数
handles.failed = PDC_FAILED;
handles.trigger_start = PDC_TRIGGER_START;
handles.trigger_end = PDC_TRIGGER_END;
handles.trigger_center = PDC_TRIGGER_CENTER;
handles.status_playback = PDC_STATUS_PLAYBACK;
handles.status_recready = PDC_STATUS_RECREADY;
handles.status_endless = PDC_STATUS_ENDLESS;
handles.status_rec = PDC_STATUS_REC;
handles.status_live = PDC_STATUS_LIVE;
handles.colortype_mono = PDC_COLORTYPE_MONO;
handles.colortype_color = PDC_COLORTYPE_COLOR;
handles.shading_on = PDC_SHADING_ON;
handles.eightbitsel_10upper = PDC_8BITSEL_10UPPER;
handles.function_off = PDC_FUNCTION_OFF;
handles.colordata_interleave_bgr = PDC_COLORDATA_INTERLEAVE_BGR;
handles.colordata_interleave_rgb = PDC_COLORDATA_INTERLEAVE_RGB;
handles.true = TRUE;
handles.false = FALSE;

%定数
handles.DeviceNo = nDeviceNo;
handles.ChildNo = nChildNo;
handles.BitDepth = nBitDepth;
handles.Width = nWidth;
handles.Height = nHeight;
handles.WidthMax = nWidthMax;
handles.HeightMax = nHeightMax;
handles.Mode = nMode;
handles.RecordingSpeed = nRate;
handles.total_frame = total_frame;
handles.nFps = nFps;
handles.itemp = itemp;
handles.MaxChildCount = nMaxChildCount;
handles.List2 = List2;
handles.RecordRateList = nRecordRateList;
handles.ResolutionList = nResolutionList;
handles.ShutterList = nShutterList;
handles.RecordRateSize = nRecordRateSize;
handles.ResolutionSize = nResolutionSize;
handles.ShutterSize = nShutterSize;
handles.eightbitsel = n8BitSel;
handles.Bayer = nBayer;
handles.TriggerMode = 0;
handles.recordTime = 0;

%ボタン
handles.close_button = S.close_button;
handles.record_stop_button = S.record_stop_button;
handles.record_button = S.record_button;
handles.record_stop_button = S.record_stop_button;
handles.waiting_button = S.waiting_button;
handles.endless_button = S.endless_button;
handles.record_time_txt = S.record_time_txt;

%エディット
handles.startframe = S.start_frame_edit;
handles.endframe = S.end_frame_edit;
handles.path_edit = S.path_edit;
handles.current_frame_edit = S.current_frame_edit;
handles.filename_edit = S.filename_edit;

%ラジオ
handles.live_radio = S.live_radio;
handles.memory_radio = S.memory_radio;
handles.livestop_radio = S.livestop_radio;

%トグルボタン
handles.recording_toggle_button = S.recording_toggle_button;
handles.camera_toggle_button = S.camera_toggle_button;
handles.data_toggle_button = S.data_toggle_button;
handles.play_toggle_button = S.play_toggle_button;
handles.save_button = S.save_button;

%パネル
handles.camera_panel = S.camera_panel;
handles.data_save_panel = S.data_save_panel;
handles.camera_display_panel = S.camera_display_panel;

%スライダー
handles.slider = S.frame_slider;

%ポップメニュ
handles.shutter_pop = S.shutter_pop;
handles.format_pop = S.format_pop;
handles.recordrate_pop = S.recordrate_pop;
handles.resolution_pop = S.resolution_pop;
handles.partition_t1_pop = S.partition_t1_pop;
handles.partition_t2_pop = S.partition_t2_pop;
handles.trigger_pop = S.trigger_pop;

%figure
handles.figure = S.fh;
handles.axes = S.ax;

guidata(S.fh,handles);
