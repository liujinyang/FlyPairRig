
[ nRet nDeviceName nErrorCode ] = PDC_GetDeviceName( nDeviceNo, 0 );

if nRet == PDC_FAILED
    disp(['PDC_GetDeviceName Error' num2str(nErrorCode)]);
end


