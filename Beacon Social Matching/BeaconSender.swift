//
//  BeaconSender.swift
//  BeaCON
//
//  Created by Tsole on 26/11/15.
//  Copyright © 2015 Konstantinos Tsoleridis. All rights reserved.
//

import UIKit
import CoreLocation
import CoreBluetooth
import DBAlertController

class BeaconSender: NSObject, CBPeripheralManagerDelegate {
    //static let sharedInstance = BeaconSender()

    var bluetoothPeripheralManager: CBPeripheralManager! //used to monitor bluetooth state changes and act accordingly
    var dataDictionary = NSDictionary()
    var beaconRegion: CLBeaconRegion!

   override init () {
        super.init()
    
        bluetoothPeripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: nil)
    }

    func startBroadcastingInterestSignal(interestSignal: InterestSignal) {

        beaconRegion = CLBeaconRegion(proximityUUID: interestSignal.uuid!, major: UInt16(interestSignal.major), minor: UInt16(interestSignal.minor), identifier: interestSignal.identifier)
        let dataDictionary = beaconRegion.peripheralDataWithMeasuredPower(nil)
        bluetoothPeripheralManager.startAdvertising((dataDictionary as? [String : AnyObject]))
    }


    func stopSendingSignal() {
        bluetoothPeripheralManager.stopAdvertising()
    }


    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager) {
        var statusMessage = ""

        switch peripheral.state {

        case CBPeripheralManagerState.PoweredOn:
            statusMessage = "Bluetooth Status: Turned On"

        case CBPeripheralManagerState.PoweredOff:
            statusMessage = "Bluetooth Status: Turned Off"

            let alertController = DBAlertController(title: "Bluetooth is Off", message: "Please turn it on to use BeaCON appropriately", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            alertController.show()

        case CBPeripheralManagerState.Resetting:
            statusMessage = "Bluetooth Status: Resetting"

        case CBPeripheralManagerState.Unauthorized:
            statusMessage = "Bluetooth Status: Not Authorized"

        case CBPeripheralManagerState.Unsupported:
            statusMessage = "Bluetooth Status: Not Supported"

        default:
            statusMessage = "Bluetooth Status: Unknown"
        }

        //print(statusMessage)
    }
}