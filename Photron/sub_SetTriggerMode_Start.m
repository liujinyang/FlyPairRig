
[ nRet, nTrgMode, nAFrames, nRFrames, nRCount, nErrorCode ] = PDC_GetTriggerMode( nDeviceNo );

if nRet == PDC_FAILED
    disp(['PDC_GetTriggerMode Error : ' num2str(nErrorCode)]);
else
    if nTrgMode ~= PDC_TRIGGER_START
        [ nRet, nErrorCode ] = PDC_SetTriggerMode( nDeviceNo, PDC_TRIGGER_START, nAFrames, nRFrames, nRCount );

        if nRet == PDC_FAILED
            disp(['PDC_SetTriggerMode Error : ' num2str(nErrorCode)]);
        else    
            while 1
                [ nRet, nTrgMode, nAFrames, nRFrames, nRCount, nErrorCode ] = PDC_GetTriggerMode( nDeviceNo );

                if nRet == PDC_FAILED
                    disp(['PDC_GetTriggerMode Error : ' num2str(nErrorCode)]);
                    break;
                end

                if nTrgMode == PDC_TRIGGER_START
                    break;
                end      
            end
        end
    end
end
