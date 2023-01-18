
[ nRet, nResolutionSize, nResolutionList, nErrorCode ] = PDC_GetResolutionList( nDeviceNo, nChildNo );

if nRet == PDC_FAILED
    disp(['PDC_GetResolutionList Error : ' num2str(nErrorCode)]);
end

