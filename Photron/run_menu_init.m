%メインGUIのメニュのオブジェクトの初期化
load('Photron_cameraSettings.mat');

nRate = camera.RecordingSpeed;
nWidth = camera.nWidth;
nHeight = camera.nHeight;
nFps = camera.nFps;
nTrgMode = camera.nTrgMode;
nRecordTime = camera.recordTime;

%ヘッドポップメニュ
set(S.partition_t1_pop,'String',MyPartitionCell);
set(S.partition_t2_pop,'String',MyPartitionCell);
set(S.partition_t1_pop,'UserData',1);

%シェーディングモード
if (nErrorCodeShading == 21)
  set(S.shading_pop,'Enable','off') 
end

%デバイス名
set(S.camera_t1_txt_box,'String',nDeviceName);
set(S.camera_t2_txt_box,'String',nDeviceName);

%撮影速度
set(S.recordrate_pop,'String',MyRecord);

for x=1:nRecordRateSize
    if( nRecordRateList(x) == nRate )
        set(S.recordrate_pop,'Value',x);
    end
end

%解像度
set(S.resolution_pop,'String',MyResolution);

for x=1:nResolutionSize
    if( nWidth == bitshift(nResolutionList(x),-16) && nHeight == bitand(hex2dec('FFFF'),nResolutionList(x)) )
        set(S.resolution_pop,'Value',x);
    end
end

%シャッター速度
set(S.shutter_pop,'String',MyShutter);

for x=1:nShutterSize
    if( nShutterList(x) == nFps )
        set(S.shutter_pop,'Value',x);
    end
end

%trigger
set(S.trigger_pop,'String', MyTriggers);
if nTrgMode == PDC_TRIGGER_START
    set(S.trigger_pop,'Value', 1);
elseif nTrgMode == PDC_TRIGGER_CENTER
    set(S.trigger_pop,'Value', 3);
else
    set(S.trigger_pop,'Value', 2);
end


%record time 
recordTime = nRecordTime;
recordTimeTxt = ['Record Time: ', num2str(recordTime), ' Sec'];
set(S.record_time_txt, 'String', recordTimeTxt);