//
//  BarcodeVC.swift
//  rfid
//
//  Created by MV962 on 29/12/2022.
//

import UIKit

class BarcodeVC: UIViewController,ISbtSdkApiDelegate {
    
    var sdkApi: ISbtSdkApi?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initilizeBarcodeSDK()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    /// Initilize barcode sdk
    func initilizeBarcodeSDK() {

        sdkApi = SbtSdkFactory.createSbtSdkApiInstance()
        sdkApi?.sbtSetDelegate(self)
        sdkApi?.sbtSetOperationalMode(Int32(SBT_OPMODE_ALL))
        sdkApi?.sbtSubsribe(
            forEvents: Int32(SBT_EVENT_SCANNER_APPEARANCE | SBT_EVENT_SCANNER_DISAPPEARANCE | SBT_EVENT_SESSION_ESTABLISHMENT | SBT_EVENT_SESSION_TERMINATION | SBT_EVENT_BARCODE | SBT_EVENT_IMAGE | SBT_EVENT_VIDEO))
        sdkApi?.sbtEnableAvailableScannersDetection(true)
        
        // getting SDK version string
        let sdk_version = sdkApi?.sbtGetVersion()
        print("LM: Zebra Scan Barcode SDK version: \(String(describing: getSDKVersion()))\n")
    }
    
    /*
    This method will provide the scanner SDK version
    - Returns : SDK version
    */
    func getSDKVersion() -> String? {
        let version = sdkApi?.sbtGetVersion()
        return version
    }
    
    /// This method will initiate the connection with particuler scanner
    /// @param scanner_id Scanner id of the connecting scanner
    func connectScanner(_ scanner_id: Int) {
        if let sdkApi {
            if scanner_id != -1 {
                let conn_result = sdkApi.sbtEstablishCommunicationSession(Int32(scanner_id))
                
                if SBT_RESULT_SUCCESS != conn_result {
                    DispatchQueue.main.async(execute: { [self] in
                        //showMessageBox("SCANNER_CONNECTION_FAILED")
                        print("LM: SCANNER_CONNECTION_FAILED")
                    })
                }
            }
        }
    }
    
    /// This method will initiate the disconnection with particuler scanner
    /// @param scannerId Scanner id of the disconnecting the scanner
    func disconnect(_ scannerId: Int) {

        if let sdkApi {
            let res = sdkApi.sbtTerminateCommunicationSession(Int32(scannerId))
            if res == SBT_RESULT_FAILURE {
//                showMessageBox("DISCONNECT_FAILED_MESSAGE")
                print("LM: DISCONNECT_FAILED_MESSAGE")
            }
        }
    }
    
    func sbtEventScannerAppeared(_ availableScanner: SbtScannerInfo!) {
        print("LM: Device has appeared, Device name \(availableScanner.getScannerName()) -- \(availableScanner.getScannerID())")
        connectScanner(Int(availableScanner.getScannerID()))
    }
    
    func sbtEventScannerDisappeared(_ scannerID: Int32) {
        print("LM: Device disappeared \(scannerID)")
     
    }
    
    func sbtEventCommunicationSessionEstablished(_ activeScanner: SbtScannerInfo!) {
        print("LM: Device has connected, Device name  :\(activeScanner.getScannerName()) -- \(activeScanner.getScannerID())")
    }
    
    func sbtEventCommunicationSessionTerminated(_ scannerID: Int32) {
        print("LM: Device has Diconnected, Device ID \(scannerID)")
    }
    
    func sbtEventBarcode(_ barcodeData: String!, barcodeType: Int32, fromScanner scannerID: Int32) {
        print("LM: Barcode Event: data event, \(barcodeData!)")
    }
    
    func sbtEventBarcodeData(_ barcodeData: Data!, barcodeType: Int32, fromScanner scannerID: Int32) {
//        let decodeData = Data(base64Encoded: barcodeData)
////        let decodeDataString = String(bytes: UInt8(decodeData), encoding: .utf8)
//        var decodeDataString = ""
//        if let string = String(data: decodeData, encoding: .utf8) {
//            decodeDataString = string
//        } else {
//            print("LM: not a valid UTF-8 sequence")
//        }
//
//        print("LM: Barcode Event Data:  \(decodeDataString ?? "")")
//        DispatchQueue.main.async(execute: { [self] in
////            textView_barcode_data.text = decodeDataString
//        })
    }
    
    func sbtEventFirmwareUpdate(_ fwUpdateEventObj: FirmwareUpdateEvent!) {
        print("LM: Firmware updat event - Max record : \(fwUpdateEventObj.maxRecords)")
        print("LM: Firmware updat event - Current record : \(fwUpdateEventObj.currentRecord)")
        print("LM: Firmware updat event - Current Status : \(fwUpdateEventObj.status)")
    }
    
    func sbtEventImage(_ imageData: Data!, fromScanner scannerID: Int32) {
       
        print("LM: Image event")
    }
    
    func sbtEventVideo(_ videoFrame: Data!, fromScanner scannerID: Int32) {
        print("LM: The video event")
    }
    

}
