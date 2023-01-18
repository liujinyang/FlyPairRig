
[nRet nErrorCode] = PDC_Init;

if nRet == PDC_FAILED
    disp(['PDC_Init Error : ' num2str(nErrorCode)]);
end