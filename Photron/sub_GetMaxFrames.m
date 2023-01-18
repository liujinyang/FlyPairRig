
[ nRet nFrames nBlock nErrorCode ] = PDC_GetMaxFrames( nDeviceNo, nChildNo );

if nRet == PDC_FAILED
    disp(['PDC_GetMaxFrames : ' num2str(nErrorCode)]);
end