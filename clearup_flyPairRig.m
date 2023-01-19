function clearup_flyPairRig(hComm)

%clearup LED controller
hComm.LEDCtrl.setVisibleBacklightsOff();
hComm.LEDCtrl.setIrBacklightsOff();
hComm.LEDCtrl.delete();

if ~(hComm.THSensor == 0)
    hComm.THSensor.close();
end

