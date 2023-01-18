
[ nRet, n8BitSel, nBayer, nInterleave, nErrorCode ] = PDC_GetTransferOption( nDeviceNo, nChildNo );

if nRet == PDC_FAILED
    disp(['PDC_SetTransferOption Error : ' num2str(nErrorCode)]);
end

