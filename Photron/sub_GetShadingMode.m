
[ nRet, nShadingMode, nErrorCodeShading] = PDC_GetShadingMode( nDeviceNo, nChildNo );

if nRet == PDC_FAILED
   disp(['PDC_GetShadingMode Error : ' num2str(nErrorCodeShading)]);
end