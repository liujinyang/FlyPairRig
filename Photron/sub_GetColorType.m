
[ nRet, nMode, nErrorCode] = PDC_GetColorType( nDeviceNo, nChildNo );

if ( nRet == PDC_FAILED )
    disp(['PDC_GetColorType Error : ' num2str(nErrorCode)]);
end