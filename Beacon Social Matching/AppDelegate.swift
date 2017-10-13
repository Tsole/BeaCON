 //
 //  AppDelegate.swift
 //  Beacon Social Matching
 //
 //  Created by Tsole on 16/9/15.
 //  Copyright © 2015 Konstantinos Tsoleridis. All rights reserved.
 //

 import UIKit
 import Parse
 import Bolts
 import RealmSwift
 import CoreBluetooth
 import CoreLocation
 import DBAlertController
 import AVFoundation
 import SpriteKit

 @UIApplicationMain
 class AppDelegate: UIResponder, UIApplicationDelegate, ReceiverDelegate {

    var window: UIWindow?
    var bluetoothPeripheralManager: CBPeripheralManager!
    var audioPlayer = AVAudioPlayer()
    var timeForNotification = 10.0
//    var beaconSpotter = BeaconSpotter()
//    var previousAlertControllers:[DBAlertController] = []


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        // [Optional] Power your app with Local Datastore. For more info, go to
        // https://parse.com/docs/ios_guide#localdatastore/iOS
        //Parse.enableLocalDatastore()

        // Initialize Parse.
        Parse.setApplicationId("JOtNU8lSnly1F23T065UJxJHat2Mn0sKGezQbJqg",
            clientKey: "2OAYqzg2S0bHJq8DPfb2EKGUx0cj7sFDNTkV4GIc")

        // [Optional] Track statistics around application opens.
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)

        window!.tintColor = UIColor.orangeColor()

//        BITHockeyManager.sharedHockeyManager().configureWithIdentifier("15f46951bb7b4b68a081aea1ede8600c")
//        // Do some additional configuration if needed here
//        BITHockeyManager.sharedHockeyManager().startManager()
//        BITHockeyManager.sharedHockeyManager().authenticator.authenticateInstallation()

        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 8,

            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if (oldSchemaVersion < 8) {
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                }
        })

        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config

        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Sound, .Alert, .Badge], categories: nil))

        _ = try! Realm()
        /*try! realm.write {
        realm.deleteAll()
        }*/

        var myTimer: NSTimer? = nil


        myTimer = NSTimer(timeInterval: 20, target: self, selector:"retrieveNewMatches", userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(myTimer!, forMode: NSRunLoopCommonModes)


        BeaconSpotter.sharedInstance.delegate = self

        if !CLLocationManager.locationServicesEnabled() {
            let alertController = DBAlertController(title: "Location services are not enabled", message: "Please turn them on to use BeaCON appropriately", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            alertController.show()
        }

        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let stopEverthing = userDefaults.valueForKey("stopEverything") {
            // do something here when stopEverything exists
        }
        else {
            // instantiate the variabe for the first time
            let stopEverything = false
            let userDefaults = NSUserDefaults.standardUserDefaults()
            userDefaults.setValue(stopEverything, forKey: "stopEverything")
            userDefaults.synchronize() // don't forget this!!!!
        }

        return true
    }

    //these matches exist already in parse and I try every few seconds to retrieve them
    func retrieveNewMatches() {
        if (PFUser.currentUser() != nil) {
            let predicate = NSPredicate(format:"matchOwner2Notified = %@ AND matchOwner2Minor = %@", "No", PFUser.currentUser()?["minor"] as! NSNumber)
            let query = PFQuery(className: "Match", predicate: predicate)

            query.findObjectsInBackgroundWithBlock {
                (objects: [PFObject]?, error: NSError?) -> Void in

                if error == nil {
                    // The find succeeded.
                    print("Successfully retrieved \(objects!.count) matches.")
                    // Do something with the found objects

                    if objects?.count > 0 {
                        /*if objects?.count == 1 {
                        //print("you have a new match")
                        self.pushAlertAfterRetrievingMatchFromParse()

                        } else {
                        print("You have new matches, check the matches tab")
                        }*/
                        self.pushAlertAfterRetrievingMatchFromParse()
                    }
                    if let objects = objects {
                        for object in objects {
                            object["matchOwner2Notified"] = "Yes"
                            object.saveInBackground()
                            print("Notified a broadcaster")
                        }
                    }
                } else {
                    // Log details of the failure
                    print("Error: \(error!) \(error!.userInfo)")
                }
            }
        }
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    /*func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
    var beaconRecion = notification.region as! CLBeaconRegion

    let majorString = String(beaconRecion.major!.intValue)
    let minorString = String(beaconRecion.minor!.intValue)
    let uuidString = beaconRecion.proximityUUID.UUIDString
    print(majorString + minorString + uuidString)
    }*/

    func beaconSpotted(major:NSString, minor:NSString, uuid:NSString, identifier:NSString, proximity:NSString) {

        let signalToInterestTransformer = SignalToInterestTransformer()
        let interestSignalReceived = InterestSignal()
        interestSignalReceived.major = Int(major as String)!
        interestSignalReceived.minor = Int(minor as String)!
        interestSignalReceived.identifier = identifier as String
        interestSignalReceived.uuid = NSUUID.init(UUIDString: uuid as String)
        let receivedInterest = signalToInterestTransformer.transformSignalToInterest(interestSignalReceived)
        receivedInterest.major = major as String
        let matchEngine = MatchEngine()

        let matchCheck = matchEngine.isItAMatch(receivedInterest)

        if matchCheck != "No" {
            let matchToBeSaved = PFObject(className:"Match")
            matchToBeSaved["identifier"] = receivedInterest.identifier
            matchToBeSaved["interestType"] = receivedInterest.interestType
            matchToBeSaved["title"] = receivedInterest.title

            //My information store in the match
            matchToBeSaved["matchOwner1Minor"] = PFUser.currentUser()!.objectForKey("minor")
            matchToBeSaved["matchOwner1"] = PFUser.currentUser()
            matchToBeSaved["matchOwner1UserName"] = PFUser.currentUser()?.username
            matchToBeSaved["matchOwner1Major"] = matchCheck
            matchToBeSaved["matchOwner1Notified"] = "Yes"

            //information from the broadcaster stored in the match
            matchToBeSaved["matchOwner2Minor"] = interestSignalReceived.minor
            //matchToBeSaved["matchOwner2"] = PFUser.currentUser() will be udpated when the Broadcaster retrieves the match from Parse
            matchToBeSaved["matchOwner2UserName"] = "Unknown"
            matchToBeSaved["matchOwner2Major"] = String(interestSignalReceived.major)
            matchToBeSaved["matchOwner2Notified"] = "No"

            //print(receivedInterest)
            //create a new match will will potentially be stored
            let newMatch = Match()
            newMatch.identifier = receivedInterest.identifier
            newMatch.broadcasterMinor = minor as String
            newMatch.keyBroadcasterMinorIdentifier = minor as String + receivedInterest.identifier //+ matchCheck

            matchToBeSaved["keyBroadcasterMinorIdentifier"] = newMatch.keyBroadcasterMinorIdentifier

            //instantiate realm
            let realm = try! Realm()
            let existingMatch = realm.objectForPrimaryKey(Match.self, key: newMatch.keyBroadcasterMinorIdentifier)

            try! realm.write {
                if existingMatch != nil {// match exists in Device
                    if NSDate.larger(NSDate(), secondDate: existingMatch!.lastNotified.dateByAddingTimeInterval(self.timeForNotification)) { //is the match old enough, so that I should notify the user again?
                        existingMatch?.lastNotified = NSDate()

                        if UIApplication.sharedApplication().applicationState != .Active {
                            let notification = UILocalNotification()
                            notification.alertBody =  "New match for " + receivedInterest.interestType
                            notification.alertTitle = "You have a new Match"
                            notification.soundName = "CustomSonar.wav";
                            UIApplication.sharedApplication().presentLocalNotificationNow(notification)
                        }


                        if UIApplication.sharedApplication().applicationState == .Active {

                            /*if self.previousAlertControllers.count > 0 {
                            for alertControllerToBeDismissed in self.previousAlertControllers {
                                alertControllerToBeDismissed.delete(self)
                            }
                            }*/

                            var alertController = DBAlertController()
                            alertController = DBAlertController(title: "You have a new Match", message: "New match for " + receivedInterest.interestType, preferredStyle: .Alert)
                            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))

                            let sonarSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("CustomSonar", ofType: "wav")!)

                            do {
                                self.audioPlayer = try AVAudioPlayer(contentsOfURL: sonarSound)
                            } catch {
                                print("No sound found by URL:\(sonarSound)")
                            }
                            self.audioPlayer.prepareToPlay()
                            self.audioPlayer.play()

                            //let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(5 * Double(NSEC_PER_SEC)))
                            //self.previousAlertControllers.append(alertController)
                            /*alertController.show(animated: true, completion: { dispatch_after(delayTime, dispatch_get_main_queue(), {
                                alertController.dismiss(animated: true, completion: nil)
                            }) })*/
                            alertController.show()
                }

                        //query for informing other user again
                        var query = PFQuery(className:"Match")
                        query.whereKey("keyBroadcasterMinorIdentifier", equalTo:newMatch.keyBroadcasterMinorIdentifier)
                        query.findObjectsInBackgroundWithBlock {
                            (objects: [PFObject]?, error: NSError?) -> Void in

                            if error == nil {

                                // The find succeeded.
                                print("retrieved \(objects!.count) a match.")
                                // Do something with the found objects
                                if let objects = objects {
                                    for object in objects {
                                        print("updated existing match")
                                        object["matchOwner2Notified"] = "No"
                                        object.saveInBackground()
                                    }
                                }

                            } else {
                                // Log details of the failure
                                print("Error: \(error!) \(error!.userInfo)")
                            }
                        }

                    }
                } else {//mtach does not exist in Device, #toDo -> but maybe in Parse?
                    newMatch.lastNotified = NSDate()
                    realm.add(newMatch)

                    if UIApplication.sharedApplication().applicationState != .Active {
                        let notification = UILocalNotification()
                        notification.alertTitle = "You have a new Match"
                        notification.alertBody =  "New match for " + receivedInterest.interestType
                        notification.soundName = "CustomSonar.wav";
                        UIApplication.sharedApplication().presentLocalNotificationNow(notification)
                    }

                    if UIApplication.sharedApplication().applicationState == .Active {
                        var alertController = DBAlertController()
                        alertController = DBAlertController(title: "You have a new Match", message: "New match for " + receivedInterest.interestType, preferredStyle: .Alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))

                        let sonarSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("CustomSonar", ofType: "wav")!)

                        do {
                            self.audioPlayer = try AVAudioPlayer(contentsOfURL: sonarSound)
                        } catch {
                            print("No sound found by URL:\(sonarSound)")
                        }
                        self.audioPlayer.prepareToPlay()
                        self.audioPlayer.play()

                        alertController.show()
                    }

                    var query = PFQuery(className:"Match")
                    query.whereKey("keyBroadcasterMinorIdentifier", equalTo:newMatch.keyBroadcasterMinorIdentifier)
                    query.findObjectsInBackgroundWithBlock {
                        (objects: [PFObject]?, error: NSError?) -> Void in

                        if error == nil {

                            // The find succeeded.
                            print("retrieved \(objects!.count) a match.")
                            // Do something with the found objects
                            if let objects = objects {
                                for object in objects {
                                    print("updated existing match")
                                    object["matchOwner2Notified"] = "No"
                                    object.saveInBackground()
                                }
                            }

                        } else {
                            // Log details of the failure
                            print("Error: \(error!) \(error!.userInfo)")
                        }
                    }

                    //matchToBeSaved

                    matchToBeSaved.saveInBackgroundWithBlock{
                        (success: Bool, error: NSError?) -> Void in
                        if (success) {
                            // The object has been saved
                            print("pushed a new match in parse")

                        } else {
                            // There was a problem, check error.description
                        }
                    }
                }
            }
        }
    }
    
    func pushAlertAfterRetrievingMatchFromParse() {
        let alertController = DBAlertController(title: "You have a new Match", message: "Go to your matches view to check it", preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        
        let sonarSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("CustomSonar", ofType: "wav")!)
        
        do {
            self.audioPlayer = try AVAudioPlayer(contentsOfURL: sonarSound)
        } catch {
            print("No sound found by URL:\(sonarSound)")
        }
        self.audioPlayer.prepareToPlay()
        self.audioPlayer.play()
        
        alertController.show()
    }
 }
