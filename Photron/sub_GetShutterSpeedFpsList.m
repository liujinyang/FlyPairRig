
[ nRet, nShutterSize, nShutterList, nErrorCode ] = PDC_GetShutterSpeedFpsList( nDeviceNo, nChildNo );

if nRet == PDC_FAILED
    disp(['PDC_GetShutterSpeedFpsList Error : ' num2str(nErrorCode)]);
end

