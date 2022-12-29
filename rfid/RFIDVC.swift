//
//  RFIDVC.swift
//  rfid
//
//  Created by MV962 on 29/12/2022.
//

import UIKit

class RFIDVC: UIViewController,srfidISdkApiDelegate {
  
    var apiInstance: srfidISdkApi? = nil
    var connectedRederID = 0

    @IBOutlet var lbButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        registerOfcallbackInterfaceWithSDK()
//        subcribeForEvent()
        startRfid()
        
    }
    @IBAction func clickOnOffEventRfidClick(_ sender: Any) {
        startStopInventory()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    //start and searching device
    func startRfid(){

        // variable to store single shared instance of API object
        
        // receiving single shared instance of API object
        apiInstance = srfidSdkFactory.createRfidSdkApiInstance()
        apiInstance?.srfidSetDelegate(self)
        
        var op_mode =  SRFID_OPMODE_MFI

        let notifications_mask = SRFID_EVENT_READER_APPEARANCE | SRFID_EVENT_READER_DISAPPEARANCE | SRFID_EVENT_SESSION_ESTABLISHMENT | SRFID_EVENT_SESSION_TERMINATION
        apiInstance?.srfidSetOperationalMode(Int32(op_mode))
        apiInstance?.srfidSubsribe(forEvents: Int32(notifications_mask))
        apiInstance?.srfidSubsribe(forEvents: Int32(SRFID_EVENT_MASK_READ | SRFID_EVENT_MASK_STATUS | SRFID_EVENT_MASK_STATUS_OPERENDSUMMARY))
        apiInstance?.srfidSubsribe(forEvents: Int32(SRFID_EVENT_MASK_TEMPERATURE | SRFID_EVENT_MASK_POWER | SRFID_EVENT_MASK_DATABASE))
        //[apiInstance srfidUnsubsribeForEvents:(SRFID_EVENT_MASK_RADIOERROR | SRFID_EVENT_MASK_POWER | SRFID_EVENT_MASK_TEMPERATURE)];
        apiInstance?.srfidSubsribe(forEvents: Int32(SRFID_EVENT_MASK_PROXIMITY))
        apiInstance?.srfidSubsribe(forEvents: Int32(SRFID_EVENT_MASK_TRIGGER))
        apiInstance?.srfidSubsribe(forEvents: Int32(SRFID_EVENT_MASK_BATTERY))
        apiInstance?.srfidSubsribe(forEvents: Int32(SRFID_EVENT_MASK_MULTI_PROXIMITY))
        apiInstance?.srfidEnableAvailableReadersDetection(true)
        apiInstance?.srfidEnableAutomaticSessionReestablishment(false)
        
        // getting SDK version string
        let sdk_version = apiInstance?.srfidGetSdkVersion()
        print("LM: Zebra RFID SDK version: \(sdk_version ?? "")\n")
        
        
    }

    func connectReader(_ reader_id: Int) {
        if let apiInstance {
            let conn_result = apiInstance.srfidEstablishCommunicationSession(Int32(reader_id))
            //Setting batch mode to default after connect and will be set back if and when event is received
//            m_ActiveReader.batchModeStatus = false
//            m_ActiveReader?.setBatchModeStatus(false)
            if SRFID_RESULT_SUCCESS != conn_result {

                DispatchQueue.main.async(execute: { [self] in
//                    showMessageBox("Connection failed")
                    print("LM: Connection failed")
                })
            }else{
                print("LM: Connection success")
            }
        }
    }
    
    func getAvialableReaderList() {
        // allocate an array for storage of list of available RFID readers
        var available_readers: NSMutableArray?
        
        // allocate an array for storage of list of active RFID readers
        var active_readers: NSMutableArray?
        
        // retrieve a list of available readers
        apiInstance?.srfidGetAvailableReadersList(&available_readers)
        // merge active and available readers to a single list
        var readers: [srfidReaderInfo] = []
        if active_readers != nil {
            readers.append(contentsOf:active_readers as! [srfidReaderInfo])
        }
        if available_readers != nil{
            readers.append(contentsOf:available_readers as! [srfidReaderInfo])
        }
        for info in readers {
            
              // print the information about RFID reader represented by srfidReaderInfo object
            print("LM: RFID reader is \(((info).isActive() == true) ? "active" : "available"): ID = \((info).getReaderID()) name = \(String(describing: (info).getReaderName()))\n")
//              lable_reader_list.text = info.getReaderName()
//              readerId = info.getReaderID()
          }
    }
    
    func getReaderInformation() {
        // identifier of one of active RFID readers is supposed to be stored in m_ReaderId variable
        
        // allocate object for storage of version related information
        var version_info:srfidReaderVersionInfo?  = srfidReaderVersionInfo.init()
        var error_response:NSString?
        
        
        // retrieve version related information
        let result = apiInstance?.srfidGetReaderVersionInfo(Int32(connectedRederID), aReaderVersionInfo: &version_info, aStatusMessage: &error_response)

        if (result != SRFID_RESULT_RESPONSE_TIMEOUT) && (result != SRFID_RESULT_FAILURE) {
            if (result != SRFID_RESULT_RESPONSE_TIMEOUT) && (result != SRFID_RESULT_FAILURE) {
                print("LM: Time out or Failure")
            }
            if SRFID_RESULT_SUCCESS == result {
                // print the received version related information
                print("LM: Device version: \(version_info?.getDeviceVersion())\n")
                print("LM: NGE version: \(version_info?.getNGEVersion())\n")
                print("LM: Bluetooth version: \(version_info?.getBluetoothVersion())\n")
//                textView_reader_information.text = "Firmware version: \(version_info.getDeviceVersion())\n NGE version: \(version_info.getNGEVersion())\n Bluetooth version: \(version_info.getBluetoothVersion())\n"
                print("LM: Firmware version: \(version_info?.getDeviceVersion())\n NGE version: \(version_info?.getNGEVersion())\n Bluetooth version: \(version_info?.getBluetoothVersion())\n")
            }
            if SRFID_RESULT_READER_NOT_AVAILABLE == result {

                print("LM: RFID reader is not available\n")
//                textView_reader_information.text = "RFID readernot available"
            }
        }
    }
    
    func getReaderCapabilities() {
        // allocate object for storage of capabilities information
        var capabilities:srfidReaderCapabilitiesInfo? = srfidReaderCapabilitiesInfo.init()
        
        // an object for storage of error response received from RFID reader
        var error_response: NSString? = nil
        
        // retrieve capabilities information
        var srfid_result = apiInstance?.srfidGetReaderCapabilitiesInfo(Int32(connectedRederID), aReaderCapabilitiesInfo: &capabilities, aStatusMessage: &error_response)

        if (srfid_result != SRFID_RESULT_RESPONSE_TIMEOUT) && (srfid_result != SRFID_RESULT_FAILURE) {
            print("LM: Time out or Failure")
        }
        
        if srfid_result == SRFID_RESULT_SUCCESS {
            print("Serial number: \(capabilities?.getSerialNumber())\n")
            print("Model: \(capabilities?.getModel())\n")
            print("Manufacturer: \(capabilities?.getManufacturer())\n")
            print("Manufacturing date: \(capabilities?.getManufacturingDate())\n")
            print("Scanner name: \(capabilities?.getScannerName())\n")
            print("Ascii version: \(capabilities?.getAsciiVersion())\n")
            print("Air version: \(capabilities?.getAirProtocolVersion())\n")
            print("Bluetooth address: \(capabilities?.getBDAddress())\n")
            print("Select filters number: \(capabilities?.getSelectFilterNum())\n")
            print("Max access sequence: \(capabilities?.getMaxAccessSequence())\n")
            print("Power level: min = \(capabilities?.getMinPower()); max = \(capabilities?.getMaxPower()); step = \(capabilities?.getPowerStep())\n")
//            textView_reader_capabilities.text = [NSString stringWithFormat:@"Serial number: %@\n Model: %@\n Bluetooth address: %@\n",[capabilities getSerialNumber],[capabilities getModel],[capabilities getBDAddress]];
            print("LM: Serial number: \(capabilities?.getSerialNumber())\n Model: \(capabilities?.getModel())\n Bluetooth address: \(capabilities?.getBDAddress())\n")
            
        }
    }
    
    func getStartTrigger() {
        // allocate object for storage of start trigger settings
        var start_trigger_cfg:srfidStartTriggerConfig? = srfidStartTriggerConfig.init()
        // an object for storage of error response received from RFID reader
        var error_response: NSString? = nil
        // retrieve start trigger parameters
        let result = apiInstance?.srfidGetStartTriggerConfiguration(Int32(connectedRederID), aStartTriggeConfig: &start_trigger_cfg, aStatusMessage: &error_response)
        
        if SRFID_RESULT_SUCCESS == result {
            // start trigger configuration received
            print("Start trigger: start on physical trigger = \((true == start_trigger_cfg?.getStartOnHandheldTrigger()) ? "YES" : "NO")\n")
            print("Start trigger: physical trigger type = \((SRFID_TRIGGERTYPE_PRESS == start_trigger_cfg?.getTriggerType()) ? "PRESSED" : "RELEASED")\n")
            print("LM: Start trigger: delay = \(start_trigger_cfg?.getStartDelay()) ms\n")
                print("Start trigger: repeat monitoring = \((false == start_trigger_cfg?.getRepeatMonitoring()) ? "NO" : "YES")\n")
            } else {
                print("LM: Failed to receive start trigger parameters\n")
            }
        
    }
    
    func getStoptTrigger() {
        //stop
        var error_response: NSString? = nil
        // allocate object for storage of start trigger settings
        var stop_trigger_cfg: srfidStopTriggerConfig? = srfidStopTriggerConfig.init()
        // retrieve stop trigger parameters
        let result = apiInstance?.srfidGetStopTriggerConfiguration(Int32(connectedRederID), aStopTriggeConfig: &stop_trigger_cfg, aStatusMessage: &error_response)
        if SRFID_RESULT_SUCCESS == result {
            // stop trigger configuration received
            print("Stop trigger: start on physical trigger = \((true == stop_trigger_cfg?.getStopOnHandheldTrigger()) ? "YES" : "NO")\n")
            print("Stop trigger: physical trigger type = \((SRFID_TRIGGERTYPE_PRESS == stop_trigger_cfg?.getTriggerType()) ? "PRESSED" : "RELEASED")\n")
            if true == stop_trigger_cfg?.getStopOnTagCount() {
                  print("LM: Stop trigger: stop on \(stop_trigger_cfg?.getStopTagCount()) number of tags received\n")
              }
            if true == stop_trigger_cfg?.getStopOnTimeout() {
                print("LM: Stop trigger: stop on \(stop_trigger_cfg?.getStopTimeout()) ms timeout\n")
            }
            if true == stop_trigger_cfg?.getStopOnInventoryCount() {
                   print("LM: Stop trigger: stop on \(stop_trigger_cfg?.getStopInventoryCount()) inventory rounds\n")
               }
               if true == stop_trigger_cfg?.getStopOnAccessCount() {
                   print("LM: Stop trigger: stop on \(stop_trigger_cfg?.getStopAccessCount()) access rounds\n")
               }
           } else {
               print("LM: Failed to receive stop trigger parameters\n")
           }
    }
    
    func setStopTrigger() {
        // allocate object for storage of start trigger settings
        let stop_trigger_cfg = srfidStopTriggerConfig.init()
        // an object for storage of error response received from RFID reader
        var error_response: NSString? = nil
        // start on physical trigger
        
//        stop_trigger_cfg?.stopOnHandheldTrigger = true
//        stop_trigger_cfg.triggerType = SRFID_TRIGGERTYPE_RELEASE
//        stop_trigger_cfg.stopOnTimeout = true
//        stop_trigger_cfg.stopTimout = 5 * 1000
//        stop_trigger_cfg.stopOnTagCount = true
//        stop_trigger_cfg.stopTagCount = 10
//        stop_trigger_cfg.stopOnInventoryCount = false
//        stop_trigger_cfg.stopOnAccessCount = false
        
        // configure stop triggers parameters to stop on physical trigger release or on 25 sec timeout
        stop_trigger_cfg.setStopOnHandheldTrigger(true)
        stop_trigger_cfg.setTriggerType(SRFID_TRIGGERTYPE_RELEASE)
        stop_trigger_cfg.setStopOnTimeout(true)
        stop_trigger_cfg.setStopTimout(25 * 1000)
        stop_trigger_cfg.setStopOnTagCount(true)
        stop_trigger_cfg.setStopTagCount(10)
        stop_trigger_cfg.setStopOnInventoryCount(false)
        stop_trigger_cfg.setStopOnAccessCount(false)

        // set stop trigger parameters
        let result = apiInstance?.srfidSetStopTriggerConfiguration(Int32(connectedRederID), aStopTriggeConfig: stop_trigger_cfg, aStatusMessage: &error_response)
        if SRFID_RESULT_SUCCESS == result {
            // stop trigger configuration applied
            print("LM: Stop trigger configuration has been set\n")
        } else {
            print("LM: Failed to set stop trigger parameters\n")
        }
        
    }
    
    func setStartTrigger() {
        
        // allocate object for storage of start trigger settings
        let start_trigger_cfg = srfidStartTriggerConfig.init()
        // an object for storage of error response received from RFID reader
        var error_response: NSString? = nil
        // configure start trigger parameters
//        // start on physical trigger
//        start_trigger_cfg.startOnHandheldTrigger = true
//        // start on physical trigger press
//        start_trigger_cfg.triggerType = SRFID_TRIGGERTYPE_PRESS
//        // repeat monitoring for start trigger conditions after operation stop
//        start_trigger_cfg.repeatMonitoring = true
//        start_trigger_cfg.startDelay = 0
        
        //            start_trigger_cfg.startOnHandheldTrigger = true
                    start_trigger_cfg.setStartOnHandheldTrigger(true)
        //            start_trigger_cfg?.triggerType = SRFID_TRIGGERTYPE_PRESS
                    start_trigger_cfg.setTriggerType(SRFID_TRIGGERTYPE_PRESS)
        //            start_trigger_cfg?.startDelay = 0
                    start_trigger_cfg.setStartDelay(0)
        //            start_trigger_cfg?.repeatMonitoring = true
                    start_trigger_cfg.setRepeatMonitoring(true)
        
        // set start trigger parameters
        let result = apiInstance?.srfidSetStartTriggerConfiguration(Int32(connectedRederID), aStartTriggeConfig: start_trigger_cfg, aStatusMessage: &error_response)
        if SRFID_RESULT_SUCCESS == result {
            // start trigger configuration applied
            print("LM: Start trigger configuration has been set\n")
        } else {
            print("LM: Failed to set start trigger parameters\n")
        }
        
    }
    
    
    func saveReaderCurrentConfigurationPersistent() {
        // an object for storage of error response received from RFID reader
        var error_response: NSString? = nil
        
        // cause the RFID reader to make current configuration persistent
        let result = apiInstance?.srfidSaveReaderConfiguration(Int32(connectedRederID), aSaveCustomDefaults: false, aStatusMessage: &error_response)
        
        if SRFID_RESULT_SUCCESS == result {
            print("LM: Current configuration became persistent\n")
        } else {
            print("LM: Request failed\n")
        }
    }
    
    func saveReaderCurrentConfigurationWithCustomDefaults() {
        // an object for storage of error response received from RFID reader
        var error_response: NSString? = nil
        // cause the RFID reader to save current configuration in custom defaults area
        let result = apiInstance?.srfidSaveReaderConfiguration(Int32(connectedRederID), aSaveCustomDefaults: true, aStatusMessage: &error_response)
        if SRFID_RESULT_SUCCESS == result {
            print("LM: Current configuration stored in custom defaults\n")
        } else {
            print("LM: Request failed\n")
        }
    }
    
    func restoreReaderConfigurationFromCustomDefaults() {

        // an object for storage of error response received from RFID reader
        var error_response: NSString? = nil
        // cause the RFID reader to restore configuration from custom defaults
        let result = apiInstance?.srfidRestoreReaderConfiguration(Int32(connectedRederID), aRestoreFactoryDefaults: false, aStatusMessage: &error_response)
        if SRFID_RESULT_SUCCESS == result {
            print("LM: Request Success\n")
        }
    }
    
    func restoreReaderConfigurationWithFactoryDefinedConfiguration() {

        // an object for storage of error response received from RFID reader
        var error_response: NSString? = nil
        // cause the RFID reader to restore factory defined configuration
        let result = apiInstance?.srfidRestoreReaderConfiguration(Int32(connectedRederID), aRestoreFactoryDefaults: true, aStatusMessage: &error_response)
        if SRFID_RESULT_SUCCESS == result {
            print("LM: Request Success\n")
        }

    }
    
    func startStopInventory() {
        
        // subscribe for tag data related events
        apiInstance?.srfidSubsribe(forEvents: Int32(SRFID_EVENT_MASK_READ))
        // subscribe for operation start/stop related events
        apiInstance?.srfidSubsribe(forEvents: Int32(SRFID_EVENT_MASK_STATUS))
        
        // identifier of one of active RFID readers is supposed to be stored in m_ReaderId variable
        
        // allocate object for start trigger settings
        let start_trigger_cfg = srfidStartTriggerConfig.init()
        
        // allocate object for stop trigger settings
        let stop_trigger_cfg = srfidStopTriggerConfig.init()
        
        // allocate object for report parameters of inventory operation
        let report_cfg = srfidReportConfig.init()
        
        // allocate object for access parameters of inventory operation
        let access_cfg = srfidAccessConfig.init()
        
        // an object for storage of error response received from RFID reader
        var error_response: NSString? = nil
        
        repeat {
            // configure start triggers parameters to start on physical trigger press
//            start_trigger_cfg.startOnHandheldTrigger = true
            start_trigger_cfg.setStartOnHandheldTrigger(true)
//            start_trigger_cfg?.triggerType = SRFID_TRIGGERTYPE_PRESS
            start_trigger_cfg.setTriggerType(SRFID_TRIGGERTYPE_PRESS)
//            start_trigger_cfg?.startDelay = 0
            start_trigger_cfg.setStartDelay(0)
//            start_trigger_cfg?.repeatMonitoring = true
            start_trigger_cfg.setRepeatMonitoring(true)
            
            // configure stop triggers parameters to stop on physical trigger release or on 25 sec timeout
//            stop_trigger_cfg?.stopOnHandheldTrigger = true
            stop_trigger_cfg.setStopOnHandheldTrigger(true)
//            stop_trigger_cfg?.triggerType = SRFID_TRIGGERTYPE_RELEASE
            stop_trigger_cfg.setTriggerType(SRFID_TRIGGERTYPE_RELEASE)
//            stop_trigger_cfg?.stopOnTimeout = true
            stop_trigger_cfg.setStopOnTimeout(true)
//            stop_trigger_cfg?.stopTimout = 25 * 1000
            stop_trigger_cfg.setStopTimout(25 * 1000)
//            stop_trigger_cfg?.stopOnTagCount = false
            stop_trigger_cfg.setStopOnTagCount(false)
//            stop_trigger_cfg?.stopOnInventoryCount = false
            stop_trigger_cfg.setStopOnInventoryCount(false)
//            stop_trigger_cfg?.stopOnAccessCount = false
            stop_trigger_cfg.setStopOnAccessCount(false)

            
            // set start trigger parameters
            var result = apiInstance?.srfidSetStartTriggerConfiguration(Int32(connectedRederID), aStartTriggeConfig: start_trigger_cfg, aStatusMessage: &error_response)
               if SRFID_RESULT_SUCCESS == result {
                   // start trigger configuration applied
                   print("LM: Start trigger configuration has been set\n")
               } else {
                   print("LM: Failed to set start trigger parameters\n")
                   break
               }
               // set stop trigger parameters
            result = apiInstance?.srfidSetStopTriggerConfiguration(Int32(connectedRederID), aStopTriggeConfig: stop_trigger_cfg, aStatusMessage: &error_response)
               if SRFID_RESULT_SUCCESS == result {
                   // stop trigger configuration applied
                   print("LM: Stop trigger configuration has been set\n")
               } else {
                   print("LM: Failed to set stop trigger parameters\n")
                   break
               }

               // start and stop triggers have been configured
               error_response = nil

               // configure report parameters to report RSSI and Channel Index fields
               //report_cfg.incPC = false
            report_cfg.setIncPC(false)
//               report_cfg.incPhase = false
            report_cfg.setIncPhase(false)
//               report_cfg.incChannelIndex = true
            report_cfg.setIncChannelIndex(true)
//               report_cfg.incRSSI = true
            report_cfg.setIncRSSI(true)
//               report_cfg.incTagSeenCount = false
            report_cfg.setIncTagSeenCount(false)
//               report_cfg.incFirstSeenTime = false
            report_cfg.setIncFirstSeenTime(false)
//               report_cfg.incLastSeenTime = false
            report_cfg.setIncLastSeenTime(false)
            
               // configure access parameters to perform the operation with 27.0 dbm antenna power level without application of pre-filters
//               access_cfg.power = 270
            access_cfg.setPower(270)
//               access_cfg.doSelect = false
            access_cfg.setDoSelect(false)
            
               // request performing of inventory operation with reading from EPC memory bank
            result = apiInstance?.srfidStartInventory(Int32(connectedRederID), aMemoryBank: SRFID_MEMORYBANK_EPC, aReportConfig: report_cfg, aAccessConfig: access_cfg, aStatusMessage: &error_response)

            if SRFID_RESULT_SUCCESS == result {
                    print("LM: Request succeed\n")
                    // request abort of an operation after 1 minute
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(60 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: { [self] in
                        apiInstance?.srfidStopInventory(Int32(connectedRederID), aStatusMessage: nil)
                    })
                } else if SRFID_RESULT_RESPONSE_ERROR == result {
                    print("LM: Error response from RFID reader: \(error_response)\n")
                } else {
                    print("LM: Request failed\n")
                }
        } while (0 != 0)
    }
    

    
 
    
    func srfidEventReaderAppeared(_ availableReader: srfidReaderInfo!) {
        print("LM: srfidEventReaderAppeared \(availableReader.getReaderName()) -- \(availableReader.getReaderID()) ")
        connectReader(Int(availableReader.getReaderID()))
        
    }
    
    func srfidEventReaderDisappeared(_ readerID: Int32) {
        print("LM: srfidEventReaderDisappeared \(readerID)")
    }
    
    func srfidEventCommunicationSessionEstablished(_ activeReader: srfidReaderInfo!) {
        print("LM: srfidEventCommunicationSessionEstablished  \(activeReader.getReaderName()) -- \(activeReader.getReaderID())")
        print("LM: Reader Connected ")
        let password = ""
        let result = apiInstance!.srfidEstablishAsciiConnection(
            activeReader.getReaderID(),
            aPassword: password)
        if SRFID_RESULT_SUCCESS == result {
            print("LM: ASCII connection has been established\n")
        } else if SRFID_RESULT_WRONG_ASCII_PASSWORD == result {
            print("LM: Incorrect ASCII connection password\n")
        } else {
            print("LM: Failed to establish ASCII connection\n")
        }
        connectedRederID = Int(activeReader.getReaderID())
       
    }
    
    func srfidEventCommunicationSessionTerminated(_ readerID: Int32) {
        print("LM: srfidEventCommunicationSessionTerminated \(readerID)")
        print("LM: Reader Disconnected ")
    }
    
    func srfidEventReadNotify(_ readerID: Int32, aTagData tagData: srfidTagData!) {
        print("LM: srfidEventReadNotify : tagId = \(tagData.getTagId()), memory_bank = \(tagData.getMemoryBankData() == nil ? "null" : tagData.getMemoryBankData())\n")
        // print the received tag data
//        print("LM: Tag data received from RFID reader with ID = \(readerID)\n")
//        if let getTagId = tagData?.getTagId() {
//            print("LM: Tag id: \(getTagId)\n")
//        }
//        let bank = tagData?.getMemoryBank()
//        if SRFID_MEMORYBANK_NONE != bank {
//            var str_bank = ""
//            switch bank {
//            case SRFID_MEMORYBANK_EPC:
//                str_bank = "EPC"
//            case SRFID_MEMORYBANK_TID:
//                str_bank = "TID"
//            case SRFID_MEMORYBANK_USER:
//                str_bank = "USER"
//            case SRFID_MEMORYBANK_RESV:
//                str_bank = "RESV"
//            case SRFID_MEMORYBANK_NONE:
//                str_bank = "None"
//            case SRFID_MEMORYBANK_ACCESS:
//                str_bank = "Acess"
//            case SRFID_MEMORYBANK_KILL:
//                str_bank = "Kill"
//            case SRFID_MEMORYBANK_ALL:
//                str_bank = "All"
//            default:
//                break
//            }
//            if let getMemoryBankData = tagData?.getMemoryBank() {
//                print("LM: \(str_bank) memory bank data: \(getMemoryBankData)\n")
//            }
//        }
    }

    //Start and stop UI
    func srfidEventStatusNotify(_ readerID: Int32, aEvent event: SRFID_EVENT_STATUS, aNotification notificationData: Any!) {
        print("LM: srfidEventStatusNotify ")
        print("LM: Radio operation has \((SRFID_EVENT_STATUS_OPERATION_START == event) ? "started" : "stopped")\n")
        lbButton.setTitle((SRFID_EVENT_STATUS_OPERATION_START == event) ? "started" : "stopped", for: UIControl.State.normal)
    }
    
    func srfidEventProximityNotify(_ readerID: Int32, aProximityPercent proximityPercent: Int32) {
        print("LM: srfidEventProximityNotify ")
    }
    
    func srfidEventMultiProximityNotify(_ readerID: Int32, aTagData tagData: srfidTagData!) {
        print("LM: srfidEventMultiProximityNotify ")
    }
    //Press and Relase pysical device
    func srfidEventTriggerNotify(_ readerID: Int32, aTriggerEvent triggerEvent: SRFID_TRIGGEREVENT) {
        print("LM: srfidEventTriggerNotify ")
        print("LM: TriggerEvent: \(triggerEvent) (\(triggerEvent == SRFID_TRIGGEREVENT_PRESSED ? "PRESS" : "RELEASE"))\n")
    }
    
    func srfidEventBatteryNotity(_ readerID: Int32, aBatteryEvent batteryEvent: srfidBatteryEvent!) {
        print("LM: srfidEventBatteryNotity ")
    }
    

}
