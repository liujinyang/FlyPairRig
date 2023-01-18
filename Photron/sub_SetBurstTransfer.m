
[nRet, nErrorCode] = PDC_SetBurstTransfer(nDeviceNo, nMode);

if nRet == PDC_FAILED
    disp(['PDC_SetBurstTransfer Error : ' num2str(nErrorCode)]);
end

