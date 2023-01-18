vidObj = VideoWriter(lpszFileName);
open(vidObj)

for nFrameNo = iStart : iEnd
    [nRet,nData,nErrorCode] = PDC_GetMemImageData(nDeviceNo,...
        nChildNo,nFrameNo,nBitDepth,nMode,nBayer,nWidth,nHeight);
    if nRet == PDC_FAILED
        disp(['PDC_AVIFileSave Error : ' num2str(nErrorCode)]);
        break;
    end
    frmWrite = nData';
    writeVideo(vidObj,frmWrite);

    stopBar= progressbar((nFrameNo - iStart)/(iEnd - iStart), 0);
    if(stopBar) break; end
    %just for debugging
    %disp(nFrameNo);
end
close(vidObj);