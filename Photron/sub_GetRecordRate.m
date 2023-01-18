
[ nRet, nRate, nErrorCode] = PDC_GetRecordRate( nDeviceNo, nChildNo );

if nRet == PDC_FAILED
    disp(['PDC_GetRecordRate Error : ' num2str(nErrorCode)]);
end