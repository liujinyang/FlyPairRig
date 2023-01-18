[nRet, nErrorCode] = PDC_SetCurrentPartition(nDeviceNo, nChildNo, nNo);

if nRet == PDC_FAILED
    disp(['PDC_SetPartitionList Error : ' num2str(nErrorCode)]);
end