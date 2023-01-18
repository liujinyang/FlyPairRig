
[ nRet, nMaxChildCount, nErrorCode ] = PDC_GetMaxChildDeviceCount(nDeviceNo);

if nRet == PDC_FAILED
    disp(['PDC_GetMaxChildDeviceCount : ' num2str(nErrorCode)]);
end

[ nRet, nChildSize, nList, nErrorCode ] = PDC_GetExistChildDeviceList( nDeviceNo );

nChildNo = nList(1);

if nRet == PDC_FAILED
    disp(['PDC_GetExistChildDeviceList : ' num2str(nErrorCode)]);
end