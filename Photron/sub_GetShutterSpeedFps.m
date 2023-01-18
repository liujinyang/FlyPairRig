
[ nRet, nFps, nErrorCode ] = PDC_GetShutterSpeedFps( nDeviceNo, nChildNo );

if nRet == PDC_FAILED
    disp(['PDC_GetShutterSpeedFps Error : ' num2str(nErrorCode)]);
end

