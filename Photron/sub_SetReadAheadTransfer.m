
[ nRet, nErrorCode ] = PDC_SetReadAheadTransfer( nDeviceNo, nChildNo, nMode, nStartFrame, nEndFrame);

if nRet == PDC_FAILED
    disp(['PDC_SetReadAheadTransfer Error : ' num2str(nErrorCode)]);
end

