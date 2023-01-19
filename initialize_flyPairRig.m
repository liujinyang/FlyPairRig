function hComm = initialize_flyPairRig()

flyPairRig_user_setting;

% %initialize LED controller
fprintf('Opening LED controller...\n');
LEDCtrl = LEDController(serial_port_for_LED_Controller);
hComm.LEDCtrl = LEDCtrl;
hComm.LEDCtrl.reset();
%hComm.LEDCtrl.synCamera(frameRate);

% hFlyBowlCtrl = ModularClient(serial_port_for_flyBowl_controller);
% hComm.LEDCtrl = hFlyBowlCtrl;
% hComm.LEDCtrl.open();
% hComm.LEDCtrl.getDeviceId();
% 
% %add calibration parameters to the controller
% hComm.LEDCtrl.setPropertiesToDefaults({'ALL'});
% hComm.LEDCtrl.irBacklightPowerToIntensityRatio('setValue',irBacklightPowerToIntensityRatio);
% hComm.LEDCtrl.visibleBacklightPowerToIntensityRatio('setValue',visibleBacklightPowerToIntensityRatio);
  
% % %initialize precon sensor
THSensor = PreconSensor(serial_port_for_precon_sensor);
[success, errMsg] = THSensor.open();
if success
    hComm.THSensor = THSensor;
else
    hComm.THSensor = 0;    
    display(errMsg);
end

%Run the camera
if runWithPhotron
    
    run_photron;
    hComm.photron = 1;
else
    hComm.photron = 0;
end