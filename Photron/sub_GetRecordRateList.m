
[ nRet, nRecordRateSize, nRecordRateList, nErrorCode ] = PDC_GetRecordRateList( nDeviceNo, nChildNo );

if nRet == PDC_FAILED
    disp(['PDC_GetRecordRateList Error : ' num2str(nErrorCode)]);
end

