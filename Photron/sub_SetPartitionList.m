nCount = 2; %hardcoded to 2 partitions
[nRet, nErrorCode] = PDC_SetPartitionList(nDeviceNo, nChildNo, nCount, []);

if nRet == PDC_FAILED
    disp(['PDC_SetPartitionList Error : ' num2str(nErrorCode)]);
end


