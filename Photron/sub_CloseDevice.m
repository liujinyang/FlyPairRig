
[nRet nErrorCode] = PDC_CloseDevice(nDeviceNo);

if nRet == PDC_FAILED
    disp(['PDC_CloseDevice Error : ' num2str(nErrorCode)]);
end