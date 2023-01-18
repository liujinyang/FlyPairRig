
[ nRet, nDetectNumInfo, nErrorCode] = PDC_DetectDevice( nInterfaceCode, nDetectNo, nDetectNum, nDetectParam );

if nRet == PDC_FAILED
    disp(['PDC_DetectDevice Error : ' num2str(nErrorCode)]);
    return
end
 
if nDetectNumInfo.m_nDeviceNum == 0
    disp(['nDetectNumInfo.m_nDeviceNum Error : nDetectNumInfo.m_nDeviceNum = 0']);
    nRet = PDC_FAILED;
    return
end

[ nRet, nDeviceNo, nErrorCode ] = PDC_OpenDevice( nDetectNumInfo.m_DetectInfo );

if nRet == PDC_FAILED
    disp(['PDC_OpenDevice Error : ' num2str(nErrorCode)]);
end