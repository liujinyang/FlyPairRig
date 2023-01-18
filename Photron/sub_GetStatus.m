
[ nRet, nStatus, nErrorCode ] = PDC_GetStatus( nDeviceNo );

if nRet == PDC_FAILED
    disp(['PDC_GetStatus Error : ' num2str(nErrorCode)]);
end


