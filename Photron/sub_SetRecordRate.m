
[ nRet, nCount, RateList, nErrorCode] = PDC_GetRecordRateList( nDeviceNo, nChildNo );

if nRet == PDC_FAILED
    disp(['PDC_GetRecordRateList Error : ' num2str(nErrorCode)]);
end

nFlag = FALSE;
for i = 1 : nCount
    if RateList(i) == RecordingSpeed
        nFlag = TRUE;
        break;
     end
end

if nFlag == FALSE
    disp(['PDC_GetRecordRateList Error']);
end

[ nRet, nErrorCode ] = PDC_SetRecordRate( nDeviceNo, nChildNo, RecordingSpeed);

if nRet == PDC_FAILED
    disp(['PDC_SetRecordRate Error : ' num2str(nErrorCode)]);
end
