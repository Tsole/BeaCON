//
//  BeaconSpotterAbstract.swift
//  BeaconMatchMaker
//
//  Created by Tsole on 11/8/15.
//  Copyright (c) 2015 Konstantinos Tsoleridis. All rights reserved.
//

import UIKit
import CoreBluetooth
import CoreLocation
import DBAlertController


@objc protocol ReceiverDelegate {

    func beaconSpotted(major:NSString, minor:NSString, uuid:NSString, identifier:NSString, proximity: NSString)

}


class BeaconSpotter: NSObject, CLLocationManagerDelegate {
    static let sharedInstance = BeaconSpotter()

    var delegate:ReceiverDelegate?
    var locationManager: CLLocationManager!
    var beaconRegion: CLBeaconRegion!

    var lastFoundBeacon: CLBeacon! = CLBeacon()
    var lastProximity: CLProximity! = CLProximity.Unknown

    override init () {
        super.init()

        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.allowsBackgroundLocationUpdates = true
    }

    func startMonitoringInterest(interestSignal: InterestSignal) {

        //self.beaconRegion = CLBeaconRegion(proximityUUID: interestSignal.uuid!, major: UInt16(interestSignal.major), identifier: interestSignal.identifier)
        self.beaconRegion = CLBeaconRegion(proximityUUID: interestSignal.uuid!, identifier: interestSignal.identifier)

        //let beaconRegion = CLBeaconRegion(proximityUUID: interestSignal.uuid!, major: UInt16(interestSignal.major), identifier: interestSignal.identifier)

        self.beaconRegion.notifyOnEntry = true
        self.beaconRegion.notifyOnExit = true
        self.beaconRegion.notifyEntryStateOnDisplay = true
        locationManager.startMonitoringForRegion(self.beaconRegion)
        locationManager.startRangingBeaconsInRegion(self.beaconRegion)

        //beaconRegion.notifyOnEntry = true
        //beaconRegion.notifyOnExit = true
        //beaconRegion.notifyEntryStateOnDisplay = true
        //locationManager.startMonitoringForRegion(beaconRegion)

        locationManager.startUpdatingLocation()


        //print("Started Monitoring Beacon: " + beaconRegion.identifier)
    }


    func stopMonitoringInterest(interest: InterestSignal) {

        self.beaconRegion = CLBeaconRegion(proximityUUID: interest.uuid!, major: UInt16(interest.major), identifier: interest.identifier)
        self.beaconRegion.notifyOnEntry = true
        self.beaconRegion.notifyOnExit = true
        locationManager.stopMonitoringForRegion(self.beaconRegion)
        locationManager.stopRangingBeaconsInRegion(self.beaconRegion)


        //var beaconRegion = CLBeaconRegion(proximityUUID: interest.uuid!, major: UInt16(interest.major), identifier: interest.identifier)
        //beaconRegion.notifyOnEntry = true
        //beaconRegion.notifyOnExit = true
        //locationManager.stopMonitoringForRegion(beaconRegion)
        //locationManager.stopRangingBeaconsInRegion(beaconRegion)

        //locationManager.stopUpdatingLocation()

        //print("Stopped Monitoring Beacon: " + beaconRegion.identifier)
    }



    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        //print("Entered region: " + region.identifier)
        let notification = UILocalNotification()
        notification.alertBody = "BeaconSpotter: UILocalNotification Did enter region: " + region.identifier
        notification.alertTitle = "UILocalNotification"
        notification.soundName = "Default";
        //UIApplication.sharedApplication().presentLocalNotificationNow(notification)

        locationManager.startRangingBeaconsInRegion((region as? CLBeaconRegion)!)
        //locationManager.startRangingBeaconsInRegion(self.beaconRegion)
        //locationManager.startMonitoringForRegion(self.beaconRegion)

        locationManager.startUpdatingLocation()
    }


    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        //locationManager.stopRangingBeaconsInRegion((region as? CLBeaconRegion)!)
        //locationManager.stopUpdatingLocation()

        let notification = UILocalNotification()
        notification.alertBody = "BeaconSpotter: UILocalNotification Did exit region" + String(region.identifier)
        //notification.alertBody = "BeaconSpotter: UILocalNotification Did exit region" + String(self.beaconRegion.identifier)
        notification.alertTitle = "UILocalNotification"
        notification.soundName = "Default";
        //UIApplication.sharedApplication().presentLocalNotificationNow(notification)
    }


    // I need to implement these delegate methods, otherwise the App does not know that I am already inside the region
    func locationManager(manager: CLLocationManager, didStartMonitoringForRegion region: CLRegion) {
        locationManager.requestStateForRegion(region)
        let notification = UILocalNotification()
        notification.alertBody = "BeaconSpotter: UILocalNotification Did start monitoring: " + String(region.identifier)
        notification.alertTitle = "UILocalNotification"
        notification.soundName = "Default";
        //UIApplication.sharedApplication().presentLocalNotificationNow(notification)
    }


    //I do this for the case I already was in a region when I started monitoring
    func locationManager(manager: CLLocationManager, didDetermineState state: CLRegionState, forRegion region: CLRegion) {
        if state == CLRegionState.Inside {

            let notification = UILocalNotification()
            notification.alertBody = "BeaconSpotter: UILocalNotification DidDetermineState"
            notification.alertTitle = "UILocalNotification"
            notification.soundName = "Default";

            var beacon = region as! CLBeaconRegion
            var major = beacon.major
            print(major)

            locationManager.startRangingBeaconsInRegion(region as! CLBeaconRegion)
        }
        else {

        }
    }


    func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: [CLBeacon]!, inRegion region: CLBeaconRegion!) {

        if let foundBeacons = beacons {
            if foundBeacons.count > 0 {
                if let closestBeacon = foundBeacons[0] as? CLBeacon {
                    if closestBeacon != lastFoundBeacon || lastProximity != closestBeacon.proximity {

                        lastFoundBeacon = closestBeacon
                        lastProximity = closestBeacon.proximity

                        var proximityMessage: String!
                        switch lastFoundBeacon.proximity {
                        case CLProximity.Immediate:
                            proximityMessage = "Very close " + region.identifier

                        case CLProximity.Near:
                            proximityMessage = "Near " + region.identifier

                        case CLProximity.Far:
                            proximityMessage = "Far " + region.identifier

                        default:
                            proximityMessage = "Where's the beacon? " + region.identifier

                        }

                        //println(proximityMessage)
                        let majorString = String(closestBeacon.major.intValue)
                        let minorString = String(closestBeacon.minor.intValue)
                        let uuidString = closestBeacon.proximityUUID.UUIDString

                        delegate!.beaconSpotted(majorString, minor: minorString, uuid: uuidString, identifier: region.identifier, proximity: proximityMessage)
                    }
                }
            }
        }
    }


    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        if !CLLocationManager.locationServicesEnabled() {
            let alertController = DBAlertController(title: "Location services are not enabled", message: "Please turn them on to use BeaCON appropriately", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            alertController.show()
        }
    }
    
    
    func locationManager(manager: CLLocationManager, monitoringDidFailForRegion region: CLRegion?, withError error: NSError) {
        print(error)
    }
    
    
    func locationManager(manager: CLLocationManager, rangingBeaconsDidFailForRegion region: CLBeaconRegion, withError error: NSError) {
        print(error)
    }
    
    func stopAll() {
        for region in self.locationManager.rangedRegions {
            locationManager.stopMonitoringForRegion(region)
            locationManager.stopRangingBeaconsInRegion(region as! CLBeaconRegion)
        }
        print(self.locationManager.rangedRegions.count)
    }

}