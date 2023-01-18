[nRet, nNo, nErrorCode] = PDC_GetCurrentPartition(nDeviceNo, nChildNo);

if nRet == PDC_FAILED
    disp(['PDC_SetPartitionList Error : ' num2str(nErrorCode)]);
end