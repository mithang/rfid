//
//  ViewController.swift
//  rfid
//
//  Created by MV962 on 26/12/2022.
//

import UIKit

class ViewController: UIViewController,srfidISdkApiDelegate,ISbtSdkApiDelegate {
    
    let ZT_BATCHMODE_NEGATIVE_VALUE = -1
    
    var sdkApi: ISbtSdkApi?
 
    var scannerList = [SbtScannerInfo]()
    var scannerInfoListGuard = NSLock()
    var scannerBarcodeList = [BarcodeList]()
    var conectedScannerInfoObject = ScannerObject.sharedInstance()
    var deviceConnectionsDelegates = [AnyHashable]()
    var firmwareUpdateProgressDelegateList = [AnyHashable]()
//    var zebraScannerId = ZT_BATCHMODE_NEGATIVE_VALUE
    
    
//
//    let m_SledConfiguration: zt_SledConfiguration? = nil
//    let m_AppConfiguration: zt_AppConfiguration? = nil
    var m_ActiveReader: zt_ActiveReader? = nil
//    let m_TemporarySledConfigurationCopy: zt_SledConfiguration? = nil
//    let m_InventoryData: zt_InventoryData? = nil

    var m_RfidSdkApi: srfidISdkApi? = nil
    var m_DeviceInfoList: [srfidReaderInfo]?
    var m_DeviceInfoListGuard: NSLock? = nil

    var m_DevListDelegates: [AnyHashable]?
    var m_ReadEventListDelegates: [AnyHashable]?
    var m_TriggerEventDelegates: [AnyHashable]?
    var m_BatteryEventDelegates: [AnyHashable]?

    var multiTagEventDelegates: [AnyHashable]?

    // nrv364: stores last battery event info
    let m_BatteryInfo: srfidBatteryEvent? = nil
    var m_BatteryStatusStr: String?
    let m_BatteryInfoGuard: NSLock? = nil

//    let m_RadioOperationEngine: zt_RadioOperationEngine? = nil
    var zebraScannerId: Int = 0
//    let previousScanner: Int
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Begin Init rfid
//        m_SledConfiguration = zt_SledConfiguration.init()
        /*
                 TBD: sled configuration shall be downloaded from active
                 sled on connection establishment
                 */
//        m_SledConfiguration.setupInitialConfiguration()
//
//        m_TemporarySledConfigurationCopy = zt_SledConfiguration.init()
//        m_TemporarySledConfigurationCopy.setupInitialConfiguration()
//
//        m_AppConfiguration = zt_AppConfiguration.init()
//        m_AppConfiguration.loadAppConfiguration()

        m_DeviceInfoList = [srfidReaderInfo]()
        m_DeviceInfoListGuard = NSLock()
        m_DevListDelegates = [AnyHashable]()

        m_ReadEventListDelegates = [AnyHashable]()
//
        m_ActiveReader = zt_ActiveReader.init()
        m_ActiveReader?.setIsActive(false, withID: nil)
        m_ActiveReader?.setBatchModeRepeat(false)
//
//        m_InventoryData = zt_InventoryData.init()

        m_TriggerEventDelegates = [AnyHashable]()
        m_BatteryEventDelegates = [AnyHashable]()
        multiTagEventDelegates = [AnyHashable]()
//
//        m_BatteryInfo = srfidBatteryEvent.init()
//        m_BatteryStatusStr = ""
//        m_BatteryInfoGuard = NSLock()
//
//        m_RadioOperationEngine = zt_RadioOperationEngine.init()
//
//        initializeRfidSdkWithAppSettings()
        
        zebraScannerId = ZT_BATCHMODE_NEGATIVE_VALUE
        //End Init rfid
        startRfid()
        startBarcode()
    }
    
    //start and searching device
    func startRfid(){
           // variable to store single shared instance of API object
           
           // receiving single shared instance of API object
           m_RfidSdkApi = srfidSdkFactory.createRfidSdkApiInstance()
           m_RfidSdkApi?.srfidSetDelegate(self)
           
           var op_mode =  SRFID_OPMODE_MFI

           let notifications_mask = SRFID_EVENT_READER_APPEARANCE | SRFID_EVENT_READER_DISAPPEARANCE | SRFID_EVENT_SESSION_ESTABLISHMENT | SRFID_EVENT_SESSION_TERMINATION
           m_RfidSdkApi?.srfidSetOperationalMode(Int32(op_mode))
           m_RfidSdkApi?.srfidSubsribe(forEvents: Int32(notifications_mask))
           m_RfidSdkApi?.srfidSubsribe(forEvents: Int32(SRFID_EVENT_MASK_READ | SRFID_EVENT_MASK_STATUS | SRFID_EVENT_MASK_STATUS_OPERENDSUMMARY))
           m_RfidSdkApi?.srfidSubsribe(forEvents: Int32(SRFID_EVENT_MASK_TEMPERATURE | SRFID_EVENT_MASK_POWER | SRFID_EVENT_MASK_DATABASE))
           //[apiInstance srfidUnsubsribeForEvents:(SRFID_EVENT_MASK_RADIOERROR | SRFID_EVENT_MASK_POWER | SRFID_EVENT_MASK_TEMPERATURE)];
           m_RfidSdkApi?.srfidSubsribe(forEvents: Int32(SRFID_EVENT_MASK_PROXIMITY))
           m_RfidSdkApi?.srfidSubsribe(forEvents: Int32(SRFID_EVENT_MASK_TRIGGER))
           m_RfidSdkApi?.srfidSubsribe(forEvents: Int32(SRFID_EVENT_MASK_BATTERY))
           m_RfidSdkApi?.srfidSubsribe(forEvents: Int32(SRFID_EVENT_MASK_MULTI_PROXIMITY))
           m_RfidSdkApi?.srfidEnableAvailableReadersDetection(true)
           m_RfidSdkApi?.srfidEnableAutomaticSessionReestablishment(false)
           
           // getting SDK version string
           let sdk_version = m_RfidSdkApi?.srfidGetSdkVersion()
           print("LM: Zebra RFID SDK version: \(sdk_version ?? "")\n")
           
           
       }
    
    //start and searching device
    func startBarcode(){
        // variable to store single shared instance of API object
        
        // receiving single shared instance of API object
        sdkApi = SbtSdkFactory.createSbtSdkApiInstance()
        sdkApi?.sbtSetDelegate(self)
        
        sdkApi?.sbtSetOperationalMode(Int32(SBT_OPMODE_ALL))

        sdkApi?.sbtSubsribe(
            forEvents: Int32(SBT_EVENT_SCANNER_APPEARANCE | SBT_EVENT_SCANNER_DISAPPEARANCE | SBT_EVENT_SESSION_ESTABLISHMENT | SBT_EVENT_SESSION_TERMINATION | SBT_EVENT_BARCODE | SBT_EVENT_IMAGE | SBT_EVENT_VIDEO))

        sdkApi?.sbtEnableAvailableScannersDetection(true)
        
        // getting SDK version string
        let sdk_version = sdkApi?.sbtGetVersion()
        print("LM: Zebra Scan Barcode SDK version: \(sdk_version ?? "")\n")
        
 
    }
    
    //Search and return RFID Device
    func srfidEventReaderAppeared(_ availableReader: srfidReaderInfo!) {
        print("LM: srfidEventReaderAppeared \(availableReader.getReaderName()) -- \(availableReader.getReaderID()) ")
        
        let notificaton_processed = false
        var result = false

        // update dev list
        var found = false

        if true == m_DeviceInfoListGuard?.lock(before: .distantFuture) {
            for ex_info in m_DeviceInfoList! {
                print("LM: \(ex_info.getReaderName()) -- \(ex_info.getReaderID()) ")
                if ex_info.getReaderID() == availableReader.getReaderID() {
                    
                    // find scanner with ID in dev list
                    ex_info.setActive(false)
                    //ex_info.active = false
                    ex_info.setConnectionType(availableReader.getConnectionType())
                    //ex_info.connectionType = availableReader.getConnectionType()
                    found = true
                    break
                }
            }

            if !found {
                let reader_info = srfidReaderInfo.init()
//                reader_info?.active = false
                reader_info?.setActive(false)
//                reader_info?.readerID = availableReader.getReaderID()
                reader_info?.setReaderID(availableReader.getReaderID())
//                reader_info?.connectionType = availableReader.getConnectionType()
                reader_info?.setConnectionType(availableReader.getConnectionType())
//                reader_info?.readerName = availableReader.getReaderName()
                reader_info?.setReaderName(availableReader.getReaderName())
//                reader_info?.readerModel = availableReader.getReaderModel()
                reader_info?.setReaderModel(availableReader.getReaderModel())
                if let reader_info {
                    m_DeviceInfoList!.append(reader_info)
                    
                }
                DispatchQueue.global(qos: .default).async(execute: { [self] in
                    startAutoReconnect(reader_info)
                })
            }

            m_DeviceInfoListGuard?.unlock()
        }

        //NSString *notif_str = [NSString stringWithFormat:@"New RFID reader (ID [%d]) has appeared", [availableReader getReaderID]];
        let notif_str = "\(availableReader.getReaderName()) is available"

//        if isInBackgroundMode() == true {
//            // check whether available notifications are enabled
//            if true == appConfiguration().getConfigNotificationAvailable() {
//
//                let notif_dict = [ZT_NOTIFICATION_KEY_READER_ID : NSNumber(value: availableReader.getReaderID())]
//                showBackgroundNotification(notif_str, aDictionary: notif_dict)
//            }
//        }

//        // notify dev list delegates
//        for delegate in m_DevListDelegates {
//            if let delegate {
//                result = delegate.deviceListHasBeenUpdated()
//            }
//        }

        
//        if isInBackgroundMode() == false {
//            if false == notificaton_processed {
//                if true == appConfiguration().getConfigNotificationAvailable() {
//                    zt_AlertView.showInfoMessage(UIApplication.shared.keyWindow?.rootViewController?.view, withHeader: ZT_RFID_APP_NAME, withDetails: notif_str, withDuration: 1)
//                }
//            }
//        }
    }
    
    func srfidEventReaderDisappeared(_ readerID: Int32) {
        print("LM: srfidEventReaderDisappeared")
        
        let notificaton_processed = false
        var result = false

        // update dev list
        var found = false
        var was_active = false

        var notification: String? = nil
        
        /*
         if (NO == was_active)
         {
         notification = [NSString stringWithFormat:@"Available RFID reader (ID [%d]) has disappeared", readerID];
         }
         else
         {
         notification = [NSString stringWithFormat:@"Active RFID reader (ID [%d]) has disappeared", readerID];
         }
         */
        
        if true == m_DeviceInfoListGuard?.lock(before: .distantFuture) {
            for ex_info in m_DeviceInfoList! {
                if ex_info.getReaderID() == readerID {
                    // find scanner with ID in dev list
                    notification = "\(ex_info.getReaderName()) is unavailable"
                    was_active = ex_info.isActive()
                    m_DeviceInfoList!.removeAll { $0 as AnyObject === ex_info as AnyObject }
                    found = true
                    break
                }
                if found == false {
                    // TBD
                    print("RfidAppEngine:srfidEventReaderDisappeared: device is not in list")
                }
                
                m_DeviceInfoListGuard!.unlock()
            }
        }
        
        if false == found {
            notification = "RFID reader (ID [\(readerID)]) has disappeared"
        }
        
//        if isInBackgroundMode() == true {
//            // check whether available notifications are enabled
//            if true == appConfiguration().getConfigNotificationAvailable() {
//                let notif_dict = [ZT_NOTIFICATION_KEY_READER_ID : NSNumber(value: readerID)]
//                showBackgroundNotification(notification, aDictionary: notif_dict)
//            }
//        }
        
//        for delegate in m_DevListDelegates {
//            if let delegate {
//                result = delegate.deviceListHasBeenUpdated()
//            }
//        }

//
//
//        if ([self isInBackgroundMode] == NO)
//        {
//            if (notificaton_processed == NO)
//            {
//                if (YES == [[self appConfiguration] getConfigNotificationAvailable])
//                {
//                    [zt_AlertView showInfoMessage:[[UIApplication sharedApplication] keyWindow].rootViewController.view withHeader:ZT_RFID_APP_NAME withDetails:notification withDuration:1];
//                }
//    //            dispatch_async(dispatch_get_main_queue(), ^{
//    //                [self showMessageBox:notification];
//    //            });
//            }
//        }

    }
    
    func srfidEventCommunicationSessionEstablished(_ activeReader: srfidReaderInfo!) {
        print("LM: srfidEventCommunicationSessionEstablished")
        
        let notificaton_processed = false

        // update dev list
        var found = false


        var notification: String? = nil
        notification = "\(activeReader.getReaderName()) has connected"
        
        /*
         if (NO == found)
         {
         notification = [NSString stringWithFormat:@"Communication session with appeared RFID reader (ID [%d]) has been established", [activeReader getReaderID]];
         }
         else
         {
         notification = [NSString stringWithFormat:@"Communication session with RFID reader (ID [%d]) has been established", [activeReader getReaderID]];
         }
         */
        
        if true == m_DeviceInfoListGuard?.lock(before: .distantFuture) {
            for ex_info in m_DeviceInfoList! {
                if ex_info.getReaderID() == activeReader.getReaderID() {
                    // find scanner with ID in the device list
                    //ex_info.active = activeReader.isActive
                    ex_info.setActive(activeReader.isActive())
//                    ex_info.connectionType = activeReader.getConnectionType()
                    ex_info.setConnectionType(activeReader.getConnectionType())
//                    ScannerEngine.shared().connectScanner(activeReader.getReaderID())
                    connectScanner(Int(activeReader.getReaderID()))
                   self.setAutoConnectDeviceDetails(ex_info)
                   found = true
                   break
                }
            }
            if found == false {
                // TBD
                print("LM: RfidAppEngine:srfidEventSessionEstablished: device is not in list")

                if found == false {
                    m_DeviceInfoList!.append(activeReader)
                }
            }

            m_DeviceInfoListGuard?.unlock()

        }
        
        // set as the primary reader
        m_ActiveReader?.setIsActive(true, withID: NSNumber(value: activeReader.getReaderID()))

//        // check transition from background mode to front
//        if isInBackgroundMode() == true {
//            // check whether active notifications are enabled
//            if true == appConfiguration().getConfigNotificationConnection() {
//                let notif_dict = [ZT_NOTIFICATION_KEY_READER_ID : NSNumber(value: activeReader.getReaderID())]
//                showBackgroundNotification(notification, aDictionary: notif_dict)
//            }
//        }
        
//
//        if ([self isInBackgroundMode] == NO)
//        {
//            if (NO == notificaton_processed)
//            {
//                /* nrv364: show "connected" notifification together with "getting config" alert */
//                /*
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [self showMessageBox:notification];
//                });
//                 */
//            }
//        }
        
        // nrv364: reset stored critical/low battery status
        resetBatteryStatusString()

        /* nrv364:
             ASCII connection is required for complete work */
        establishAsciiConnection()
    }
    
    func srfidEventCommunicationSessionTerminated(_ readerID: Int32) {
        print("LM: srfidEventCommunicationSessionTerminated")
        
        //Import to check again
//        m_RadioOperationEngine.eventSessionTerminated()

        let notificaton_processed = false
        var result = false

        // update dev list
        var found = false

        var notification: String? = nil
        if true == m_DeviceInfoListGuard?.lock(before: .distantFuture) {
            for ex_info in m_DeviceInfoList! {
                if ex_info.getReaderID() == readerID {
                    // find scanner with ID in dev list
//                    ex_info.active = false
                    ex_info.setActive(false)
                    found = true
                    notification = "\(ex_info.getReaderName()) has disconnected"
                    break
                }
            }
            
            if found == false {
                // TBD
                print("RfidAppEngine:srfidEventSessionTerminated: device is not in list")
            }

            m_DeviceInfoListGuard!.unlock()
        }
        
        if true == found {
            if (m_ActiveReader?.isActive())! && m_ActiveReader?.getID() == readerID {
                m_ActiveReader?.setIsActive(false, withID: nil)
            }
        }
        
//        if (NO == found)
//            {
//                notification = [NSString stringWithFormat:@"RFID reader (ID [%d]) has disconnected", readerID];
//            }
//
//            if ([self isInBackgroundMode] == YES)
//            {
//                /* check whether active notifications are enabled */
//                if (YES == [[self appConfiguration] getConfigNotificationConnection])
//                {
//                    NSDictionary *notif_dict = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:readerID] forKey:ZT_NOTIFICATION_KEY_READER_ID];
//                    [self showBackgroundNotification:notification aDictionary:notif_dict];
//                }
//            }
        
//
//        /* notify dev list delegates */
//        for (id<zt_IRfidAppEngineDevListDelegate> delegate in m_DevListDelegates)
//        {
//            if (delegate != nil)
//            {
//                result = [delegate deviceListHasBeenUpdated];
//            }
//        }
//
//        if ([self isInBackgroundMode] == NO)
//        {
//            if (notificaton_processed == NO)
//            {
//                if (YES == [[self appConfiguration] getConfigNotificationConnection])
//                {
//                    [zt_AlertView showInfoMessage:[[UIApplication sharedApplication] keyWindow].rootViewController.view withHeader:ZT_RFID_APP_NAME withDetails:notification withDuration:3];
//                }
//    //            dispatch_async(dispatch_get_main_queue(), ^{
//    //                [self showMessageBox:[NSString stringWithFormat:@"Communication session with RFID reader (ID [%d]) has been terminated", readerID]];
//    //            });
//            }
//        }

    }
    
    func srfidEventReadNotify(_ readerID: Int32, aTagData tagData: srfidTagData!) {
        print("LM: srfidEventReadNotify")
        
        // nrv364: thread is unknown
        //NSLog(@"eventReadNotify: tagId = %@, memory_bank = %@\n", [tagData getTagId], ([tagData getMemoryBankData] == nil ? @"null" : [tagData getMemoryBankData]));

//        m_RadioOperationEngine.eventTagData(tagData)
    }
    
    func srfidEventStatusNotify(_ readerID: Int32, aEvent event: SRFID_EVENT_STATUS, aNotification notificationData: Any!) {
        print("LM: srfidEventStatusNotify")
        
        // nrv364: thread is unknown
//        print("eventStatusNotify: \(stringOfRfidStatusEvent(event))\n")

        if event == SRFID_EVENT_STATUS_OPERATION_BATCHMODE {
//            m_ActiveReader.batchModeStatus = true
            m_ActiveReader?.setBatchModeStatus(true)
//            m_ActiveReader.batchModeRepeat = notificationData.boolValue
            m_ActiveReader?.setBatchModeRepeat((notificationData as AnyObject).boolValue)
        }
        
        if event == SRFID_EVENT_STATUS_OPERATION_BATCHMODE || event == SRFID_EVENT_STATUS_OPERATION_START {
//            m_RadioOperationEngine.eventRadioOperation(true)
        } else if event == SRFID_EVENT_STATUS_OPERATION_STOP {
//            m_RadioOperationEngine.eventRadioOperation(false)
        } else if event == SRFID_EVENT_STATUS_OPERATION_END_SUMMARY {
//            if let get = (notificationData as? srfidOperEndSummaryEvent)?.getTotalRounds(), let aGet = (notificationData as? srfidOperEndSummaryEvent)?.getTotalTags(), let aAGet = (notificationData as? srfidOperEndSummaryEvent)?.getTotalTimeUs() {
//                    print(String(format: "notification:::%@,,totalrounds:::%d,totaltags:%d,,,totalTimeUS::%ld", notificationData, get, aGet, aAGet))
        }else if event == SRFID_EVENT_STATUS_DATABASE {
//            if let getCause = (notificationData as? srfidDatabaseEvent)?.getCause(), let getEntriesUsed = (notificationData as? srfidDatabaseEvent)?.getEntriesUsed(), let getEntriesRemaining = (notificationData as? srfidDatabaseEvent)?.getEntriesRemaining() {
//                print("notification:\(notificationData) Cause:\(getCause) EntriesUsed:\(getEntriesUsed) EntriesRemaining::\(getEntriesRemaining)")
        }else if event == SRFID_EVENT_STATUS_TEMPERATURE {
//            if let getEventCause = (notificationData as? srfidTemperatureEvent)?.getCause(), let getSTM32Temp = (notificationData as? srfidTemperatureEvent)?.getSTM32Temp(), let getRadioPATemp = (notificationData as? srfidTemperatureEvent)?.getRadioPATemp() {
//                print("notification:\(notificationData) Cause:\(getEventCause) Ambient Temperature:\(getSTM32Temp) Radio Temperature::\(getRadioPATemp)")
                
        } else if event == SRFID_EVENT_STATUS_POWER {
//            if let getCause = (notificationData as? srfidPowerEvent)?.getCause(), let getVoltage = (notificationData as? srfidPowerEvent)?.getVoltage(), let getCurrent = (notificationData as? srfidPowerEvent)?.getCurrent() {
//                print("notification:\(notificationData) Cause:\(getCause) Voltage:\(getVoltage) Current:\(getCurrent)")
//            }
        }
//        m_RadioOperationEngine.currentBatchModeStatus = event
    }
    
    func srfidEventProximityNotify(_ readerID: Int32, aProximityPercent proximityPercent: Int32) {
        print("LM: srfidEventProximityNotify")
        
//        m_RadioOperationEngine.eventProximityData(proximityPercent)
    }
    
    func srfidEventMultiProximityNotify(_ readerID: Int32, aTagData tagData: srfidTagData!) {
        print("LM: srfidEventMultiProximityNotify")
        
        for delegate in multiTagEventDelegates! {
//            if delegate != nil && (zt_RfidAppEngine.sharedAppEngine().activeReader().getBatchModeRepeat() == false) {
//                m_RadioOperationEngine.getQueue().async(execute: {
//                    DispatchQueue.main.async(execute: {
//                        delegate.onNewMultiTagEvent(tagData)
//                    })
//                })
//            }
        }
    }
    
    func srfidEventTriggerNotify(_ readerID: Int32, aTriggerEvent triggerEvent: SRFID_TRIGGEREVENT) {
        print("LM: srfidEventTriggerNotify")
        
        print("\nTriggerEvent: \(triggerEvent) (\(triggerEvent == SRFID_TRIGGEREVENT_PRESSED ? "PRESS" : "RELEASE"))\n")
//        for (id<zt_IRfidAppEngineTriggerEventDelegate> delegate in m_TriggerEventDelegates )
//            {
//                if (delegate != nil && ([[[zt_RfidAppEngine sharedAppEngine] activeReader] getBatchModeRepeat] == NO))
//                {
//                    dispatch_async([m_RadioOperationEngine getQueue], ^{
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                            if (SRFID_TRIGGEREVENT_SCAN_RELEASED == triggerEvent || SRFID_TRIGGEREVENT_SCAN_PRESSED == triggerEvent){
//                                NSLog(@"Scan_Notification_Event: (%@)\n", (triggerEvent == SRFID_TRIGGEREVENT_SCAN_PRESSED ? @"PRESS" : @"RELEASE"));
//                                [delegate onNewTriggerEvent:SRFID_TRIGGEREVENT_PRESSED == triggerEvent typeRFID:NO];
//                            }else{
//                                [delegate onNewTriggerEvent:SRFID_TRIGGEREVENT_PRESSED == triggerEvent typeRFID:YES];
//                            }
//                        });
//                    });
//                }
//            }
    }
    
    func srfidEventBatteryNotity(_ readerID: Int32, aBatteryEvent batteryEvent: srfidBatteryEvent!) {
        print("LM: srfidEventBatteryNotity")
        
//        /* nrv364: thread is unknown */
//        NSLog(@"\nbatteryEvent: level = [%d] charging = [%d] cause = (%@)\n", [batteryEvent getPowerLevel], [batteryEvent getIsCharging], [batteryEvent getEventCause]);
//
//        BOOL _is_low = NO;
//        BOOL _is_critical = NO;
//
//        _is_low = (NSOrderedSame == [[batteryEvent getEventCause] caseInsensitiveCompare:ZT_BATTERY_EVENT_CAUSE_LOW]);
//        _is_critical = (NSOrderedSame == [[batteryEvent getEventCause] caseInsensitiveCompare:ZT_BATTERY_EVENT_CAUSE_CRITICAL]);
//
//
//        if (YES == [m_BatteryInfoGuard lockBeforeDate:[NSDate distantFuture]])
//        {
//            [m_BatteryInfo setPowerLevel:[batteryEvent getPowerLevel]];
//            [m_BatteryInfo setIsCharging:[batteryEvent getIsCharging]];
//            [m_BatteryInfo setEventCause:[batteryEvent getEventCause]];
//
//            /* nrv364:
//                - store low/critical battery status if reported
//                - reset low/critical battery status if charging is on
//             */
//            if ((YES == _is_low) || (YES == _is_critical))
//            {
//                if (YES == [m_AppConfiguration getConfigNotificationBattery])
//                {
//                    [m_BatteryStatusStr setString:[batteryEvent getEventCause]];
//                }
//            }
//            if (YES == [batteryEvent getIsCharging])
//            {
//                [m_BatteryStatusStr setString:@""];
//            }
//
//            [m_BatteryInfoGuard unlock];
//        }
//
//        /* inform battery status screen */
//        for (id<zt_IRfidAppEngineBatteryEventDelegate> delegate in m_BatteryEventDelegates )
//        {
//            if (delegate != nil)
//            {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [delegate onNewBatteryEvent];
//                });
//            }
//        }
//
//        /* proceed with notifications for low/critical causes */
//        if (YES == [m_AppConfiguration getConfigNotificationBattery])
//        {
//            /* proceed with notifications for low/critical causes */
//            NSString *battery_notification = @"";
//            if (YES == _is_critical)
//            {
//                battery_notification = @"Battery is critical! Please charge the Sled";
//            }
//            else if (YES == _is_low)
//            {
//                battery_notification = @"Battery is low! Please charge the Sled";
//
//
//            }
//
//            if (0 < [battery_notification length])
//            {
//                if (YES == [self isInBackgroundMode])
//                {
//                    [self showBackgroundNotification:battery_notification aDictionary:nil];
//                }
//                else
//                {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [zt_AlertView showInfoMessage:[[UIApplication sharedApplication] keyWindow].rootViewController.view withHeader:ZT_RFID_APP_NAME withDetails:battery_notification withDuration:3];
//                    });
//                }
//            }
//        }
    }
    
    
    //Search and return Scan Device
    func sbtEventScannerAppeared(_ availableScanner: SbtScannerInfo!) {
        print("LM: sbtEventScannerAppeared \(availableScanner.getScannerID()) -- \(availableScanner.getScannerName())")
        
        // update dev list
        var found = false
        
        if true == scannerInfoListGuard.lock(before: .distantFuture) {
            for scannerInfo in scannerList {
                print("LM: \(scannerInfo.getScannerID()) -- \(scannerInfo.getScannerName())")
                if scannerInfo.getScannerID() == availableScanner.getScannerID() {
                    // find scanner with ID in dev list
//                    scannerInfo.active = false
                    scannerInfo.setActive(false)
//                    scannerInfo.available = true
                    scannerInfo.setAvailable(true)
//                    scannerInfo.autoCommunicationSessionReestablishment = availableScanner.getAutoCommunicationSessionReestablishment()
                    scannerInfo.setAutoCommunicationSessionReestablishment(availableScanner.getAutoCommunicationSessionReestablishment())
//                    scannerInfo.connectionType = availableScanner.getConnectionType()
                    scannerInfo.setConnectionType(availableScanner.getConnectionType())
                    found = true
                    break
                }
            }
            
            if found == false {
                let scanner_info = SbtScannerInfo()
//                scanner_info.active = false
                scanner_info?.setActive(false)
//                scanner_info.available = true
                scanner_info?.setAvailable(true)
//                scanner_info.scannerID = availableScanner.getScannerID()
                scanner_info?.setScannerID(availableScanner.getScannerID())
//                scanner_info.autoCommunicationSessionReestablishment = availableScanner.getAutoCommunicationSessionReestablishment()
                scanner_info?.setAutoCommunicationSessionReestablishment(availableScanner.getAutoCommunicationSessionReestablishment())
//                scanner_info.connectionType = availableScanner.getConnectionType()
                scanner_info?.setConnectionType(availableScanner.getConnectionType())
//                scanner_info.scannerName = availableScanner.getScannerName()
                scanner_info?.setScannerName(availableScanner.getScannerName())
//                scanner_info.scannerModel = availableScanner.getScannerModel()
                scanner_info?.setScannerModel(availableScanner.getScannerModel())
                scannerList.append(scanner_info!)
            }
            scannerInfoListGuard.unlock()
        }
//        // notify connections delegates
//        for delegate in deviceConnectionsDelegates {
//            if let delegate {
//                delegate.scannerHasAppeared(availableScanner.getScannerID())
//            }
//        }
    }
    
    func sbtEventScannerDisappeared(_ scannerID: Int32) {
        print("LM: sbtEventScannerDisappeared")
        
        var scannerName = ""

        // update dev list
        var found = false
        var was_active = false
        
        if true == scannerInfoListGuard.lock(before: .distantFuture) {
            for scannerInfo in scannerList {
                if scannerInfo.getScannerID() == scannerID {
                    // find scanner with ID in dev list
                    was_active = scannerInfo.isActive()
                    scannerName = scannerInfo.getScannerName()
//                    scannerInfo.available = false
                    scannerInfo.setAvailable(false)
                    found = true
                   break
               }
           }

           scannerInfoListGuard.unlock()
       }
//        // notify connections delegates
//        for delegate in deviceConnectionsDelegates.copy() {
//            if let delegate {
//                delegate.scannerHasDisappeared(scannerID)
//            }
//        }

        removeBarcodeData()
    }
    
    func sbtEventCommunicationSessionEstablished(_ activeScanner: SbtScannerInfo!) {
        print("LM: sbtEventCommunicationSessionEstablished")
        
        print("sbtEventCommunicationSessionEstablished")
        conectedScannerInfoObject.scannerInfo = activeScanner
        let barcodeList = BarcodeList(motoID: conectedScannerInfoObject.scannerInfo.getScannerID(), andName: conectedScannerInfoObject.scannerInfo.getScannerName())
        scannerBarcodeList.append(barcodeList)
        zebraScannerId = Int(conectedScannerInfoObject.scannerInfo.getScannerID())
        
//        // notify connections delegates
//        for delegate in deviceConnectionsDelegates {
//            if let delegate {
//                delegate.scannerHasConnected(activeScanner.getScannerID())
//            }
//        }
        
    }
    
    func sbtEventCommunicationSessionTerminated(_ scannerID: Int32) {
        print("LM: sbtEventCommunicationSessionTerminated")
        
        print("sbtEventCommunicationSessionTerminated")
        zebraScannerId = ZT_BATCHMODE_NEGATIVE_VALUE
        // notify connections delegates
//        for delegate in deviceConnectionsDelegates {
//            if let delegate {
//                delegate.scannerHasDisconnected(scannerID)
//            }
//        }
        removeBarcodeData()
    }
    
    func sbtEventBarcode(_ barcodeData: String!, barcodeType: Int32, fromScanner scannerID: Int32) {
        print("LM: sbtEventBarcode")
    }
    
    func sbtEventBarcodeData(_ barcodeData: Data!, barcodeType: Int32, fromScanner scannerID: Int32) {
        print("LM: sbtEventBarcodeData")
        
        print("sbtEventBarcodeData")
        addBarcodeDataToList(toList: barcodeData, barcodeType: Int(barcodeType), scannerId: Int(scannerID))
//
//        if delegate() != nil && barcodeData != nil && barcodeType != ST_NOT_APP && getBarcodePageIsAppear() {
//
//            delegate.barcodeDataList(barcodeData, barcodeType: barcodeType)
//        }
    }
    
    func sbtEventFirmwareUpdate(_ fwUpdateEventObj: FirmwareUpdateEvent!) {
        print("LM: sbtEventFirmwareUpdate")
        
//        print("sbtEventFirmwareUpdate")
//        for delegate in firmwareUpdateProgressDelegateList.copy() {
//            if let delegate {
//                if delegate != nil && fwUpdateEventObj != nil && delegate is ScannerAppEngineFirmwareUpdateEventsDelegate {
//                    delegate.updateUI(fwUpdateEventObj)
//                }
//            }
//        }
    }
    
    func sbtEventImage(_ imageData: Data!, fromScanner scannerID: Int32) {
        print("LM: sbtEventImage")
    }
    
    func sbtEventVideo(_ videoFrame: Data!, fromScanner scannerID: Int32) {
        print("LM: sbtEventVideo")
    }
    
    //Begin: My Method
    func startAutoReconnect(_ ex_info: srfidReaderInfo?) {
//        let isAutoReconnectSessionEnabled = UserDefaults.standard.bool(forKey: ZT_AUTO_CONNECT_CONFIG_IS_ENABLED)
//        if !isAutoReconnectSessionEnabled {
//            return
//        }
        if !(ex_info?.isActive())! == true {
            if isShouldAutoConnect(ex_info) {
                connect(Int((ex_info?.getReaderID())!))
            }
        }
    }
    
    func setAutoConnectDeviceDetails(_ connectedReader: srfidReaderInfo?) {
//        UserDefaults.standard.set(connectedReader?.getReaderID() ?? 0, forKey: ZT_AUTO_CONNECT_READER_ID)
//        UserDefaults.standard.set(false, forKey: ZT_AUTO_CONNECT_TERMINATE_STATE)
//        UserDefaults.standard.synchronize()
    }
    
    func getBatteryStatusString() -> String? {
        var res = ""
        if true == m_BatteryInfoGuard?.lock(before: .distantFuture) {
            res = m_BatteryStatusStr ?? ""
            m_BatteryInfoGuard?.unlock()
        }
        return res
    }

    func resetBatteryStatusString() {
//        if true == m_BatteryInfoGuard!.lock(before: .distantFuture) {
//            m_BatteryStatusStr = ""
//            m_BatteryInfoGuard?.unlock()
//        }
    }
    
    func connectScanner(_ scanner_id: Int) {
        if let sdkApi {
            if getZebraConnectedScannerID() == -1 || (getZebraConnectedScannerID() == 0) {
                let conn_result = sdkApi.sbtEstablishCommunicationSession(Int32(scanner_id))
                if SBT_RESULT_SUCCESS != conn_result {
                    DispatchQueue.main.async(execute: { [self] in
//                        showMessageBox(SCANNER_CONNECTION_FAILED)
                    })
                } else {
//                    if scanner_id == previousScanner {
//                        ///Display firmware update success on auto-reconnect
//                        DispatchQueue.main.async(execute: { [self] in
////                            firmwareUpdateSuccessDisplay()
//                        })
//                    }
                }
            }
        }
    }
    
    func establishAsciiConnection(){
//        int reader_id = [m_ActiveReader getReaderID];
//        NSString *ascii_pwd = [m_AppConfiguration getConfigAsciiPassword:reader_id];
//
//        SRFID_RESULT _conn_res = [m_RfidSdkApi srfidEstablishAsciiConnection:reader_id aPassword:ascii_pwd];
//
//        if (_conn_res == SRFID_RESULT_SUCCESS)
//        {
//            /* success -> we may continue */
//            [self postAsciiConnectionActions];
//        }
//        else if (_conn_res == SRFID_RESULT_WRONG_ASCII_PASSWORD)
//        {
//            /* wrong password -> display password dialog */
//
//
//            UIAlertController * alert = [UIAlertController
//                                         alertControllerWithTitle:ZT_RFID_APP_NAME
//                                         message:@"Connection password required!"
//                                         preferredStyle:UIAlertControllerStyleAlert];
//
//
//            UIAlertAction* connectButton = [UIAlertAction
//                                           actionWithTitle:@"Connect"
//                                           style:UIAlertActionStyleDefault
//                                           handler:^(UIAlertAction * action) {
//                                               //Handle connect button here
//                                               /* save entered ascii connection password */
//                                               NSString * password = alert.textFields[0].text;
//                                               [m_AppConfiguration setConfigAsciiPassword:password forReader:[m_ActiveReader getReaderID]];
//                                               [self establishAsciiConnection];
//                                           }];
//
//            UIAlertAction* cancelButton = [UIAlertAction
//                                           actionWithTitle:@"Cancel"
//                                           style:UIAlertActionStyleCancel
//                                           handler:^(UIAlertAction * action) {
//                                               //Handle cancel button here
//                                               [self disconnect:[m_ActiveReader getReaderID]];
//                                           }];
//
//            [alert addAction:cancelButton];
//            [alert addAction:connectButton];
//
//            [alert addTextFieldWithConfigurationHandler:^(UITextField * textField) {
//                textField.placeholder = @"Enter password";
//            }];
//
//            UIViewController * topVC = [[[UIApplication sharedApplication] keyWindow] rootViewController];
//            [topVC presentViewController:alert animated:YES completion:nil];
//        }
//        else
//        {
//            /* unknown error -> show message box */
//            UIAlertController * alert = [UIAlertController
//                                         alertControllerWithTitle:ZT_RFID_APP_NAME
//                                         message:@"Failed to establish connection with RFID reader"
//                                         preferredStyle:UIAlertControllerStyleAlert];
//
//            UIAlertAction* cancelButton = [UIAlertAction
//                                           actionWithTitle:@"OK"
//                                           style:UIAlertActionStyleCancel
//                                           handler:^(UIAlertAction * action) {
//                                               //Handle cancel button here
//                                           }];
//
//            [alert addAction:cancelButton];
//
//            UIViewController * topVC = [[[UIApplication sharedApplication] keyWindow] rootViewController];
//            [topVC presentViewController:alert animated:YES completion:nil];
//        }
    }
    
    func getZebraConnectedScannerID() -> Int {
        return zebraScannerId
    }
    
    func removeBarcodeData() {

//        for i in 0..<scannerBarcodeList.count {
//            if conectedScannerInfoObject.scannerInfo.getScannerID() == (scannerBarcodeList[i] as? BarcodeList)?.getScannerID() {
//                scannerBarcodeList.remove(at: i)
//                break
//            }
//        }
    }
    
    func addBarcodeDataToList(toList barcodeData: Data?, barcodeType: Int, scannerId: Int) {
        
        var scannerName = ""
        // add new barcode to barcode list of specified scanner
        
        // add new barcode to barcode list of specified scanner
        for barcodeList in scannerBarcodeList {
            if scannerId == barcodeList.getScannerID() {
                let decodeData = BarcodeData(data: barcodeData!, ofType: Int32(barcodeType))
                barcodeList.add(decodeData)
                scannerName = barcodeList.getScannerName()
                print("LM: \( decodeData.getDecodeAsString(usingEncoding: String.Encoding.utf8.rawValue)) -- \(barcodeList.getScannerName())")
            }
        }
    }
    
    func isShouldAutoConnect(_ readerInfo: srfidReaderInfo?) -> Bool {
//           let readerId = (UserDefaults.standard.object(forKey: ZT_AUTO_CONNECT_READER_ID) as? NSNumber)?.intValue ?? 0
//           let isTerminate = UserDefaults.standard.bool(forKey: ZT_AUTO_CONNECT_TERMINATE_STATE)
//           if readerId == (readerInfo?.getReaderID())! && isTerminate {
//               return true
//           } else {
//               return false
//           }
        return true
       }
       func connect(_ reader_id: Int) {
           if let m_RfidSdkApi {
               let conn_result = m_RfidSdkApi.srfidEstablishCommunicationSession(Int32(reader_id))
               //Setting batch mode to default after connect and will be set back if and when event is received
   //            m_ActiveReader.batchModeStatus = false
               m_ActiveReader?.setBatchModeStatus(false)
               if SRFID_RESULT_SUCCESS != conn_result {

                   DispatchQueue.main.async(execute: { [self] in
   //                    showMessageBox("Connection failed")
                       print("LM: Connection failed")
                   })
               }
           }
       }
    //End: My Method
    
}

