
[ nRet, nTriggerMode, nAFrames, nRFrames, nRCount, nErrorCode ] = PDC_GetTriggerMode( nDeviceNo );

if nRet == PDC_FAILED
    disp(['PDC_GetTriggerMode Error : ' num2str(nErrorCode)]);
end

