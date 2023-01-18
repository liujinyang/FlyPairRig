
[ nRet, nErrorCode ] = PDC_SetTransferOption( nDeviceNo, nChildNo, n8BitSel, nBayer, nInterleave );

if nRet == PDC_FAILED
    disp(['PDC_SetTransferOption Error : ' num2str(nErrorCode)]);
end

