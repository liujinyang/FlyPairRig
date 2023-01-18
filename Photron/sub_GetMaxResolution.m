
[ nRet, nWidthMax, nHeightMax, nErrorCode ] = PDC_GetMaxResolution( nDeviceNo, nChildNo );

if nRet == PDC_FAILED
    disp(['PDC_GetMaxResolution Error : ' num2str(nErrorCode)]);
end

