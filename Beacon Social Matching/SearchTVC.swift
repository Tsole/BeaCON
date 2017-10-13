//
//  SearchTVC.swift
//
//
//  Created by Tsole on 12/11/15.
//
//

import UIKit
import Parse
import ParseUI
import RealmSwift
import Bolts

import AVFoundation


class SearchTVC: PFQueryTableViewController {


    @IBOutlet var startButton: UIBarButtonItem!
    //var cell = tableView.dequeueReusableCellWithIdentifier("Section") as? StartSeachingSection
    var sectionView = StartSeachingSection()
    var beaconSender = BeaconSender()
    let interestToSignalTransformer = InterestToSignalTransformer()

    var beaconToSendAs = 0
    var activeInterests:[PFObject] = []

    var broadcastTimer = NSTimer()
    var audioPlayer = AVAudioPlayer()

    var statusText = ""

    //var stopEverything = NSUserDefaults.standardUserDefaults().valueForKey("stopEverything") as! Bool

    override init(style: UITableViewStyle, className: String?) {
        super.init(style: style, className: className)
        parseClassName = "Interest"
        pullToRefreshEnabled = true
        paginationEnabled = true
        objectsPerPage = 25
    }


    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        parseClassName = "Interest"
        pullToRefreshEnabled = true
        paginationEnabled = true
        objectsPerPage = 25
    }


    override func queryForTable() -> PFQuery {
        let query = PFQuery(className: self.parseClassName!)
        query.whereKey("interestOwner", equalTo: PFUser.currentUser()!)
        // If no objects are loaded in memory, we look to the cache first to fill the table
        // and then subsequently do a query against the network.
        if self.objects!.count == 0 {
            query.cachePolicy = .CacheThenNetwork
        }

        query.orderByDescending("createdAt")

        return query
    }

    override func viewDidAppear(animated: Bool) {
        self.loadObjects()
        //broadcastTimer.fire()
    }

    override func objectsDidLoad(error: NSError?) {
        super.objectsDidLoad(error)
        self.updateActiveInterests()

        //use this to persist Interests in Realm if they are not already persisted
        let realm = try! Realm()
        for object in self.objects! {

            let interestToSave = SavedInterest()
            //monitor or not the Interest depending on whether it is active or not
            let signalToMonitor = interestToSignalTransformer.transformInterestToSIgnal(object as! PFObject)

            if NSUserDefaults.standardUserDefaults().valueForKey("stopEverything") as! Bool == false {
            BeaconSpotter.sharedInstance.startMonitoringInterest(signalToMonitor)
            }

            //In the current Implementation, I send always even if an interest is inactive
            /*if (object.objectForKey("status") as! String == "Active") {
                //make sure I am monitoring this region
                BeaconSpotter.sharedInstance.startMonitoringInterest(signalToMonitor)
            } else {
                //BeaconSpotter.sharedInstance.stopMonitoringInterest(signalToMonitor)
            }*/

            //create the interest which I will potentially persist
            interestToSave.identifier = object.objectForKey("identifier") as! String
            interestToSave.interestType = object.objectForKey("interestType") as! String
            interestToSave.title = object.objectForKey("title") as! String
            interestToSave.major = String(signalToMonitor.major)
            interestToSave.status = object.objectForKey("status") as! String

            try! realm.write {
                realm.add(interestToSave, update: true)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("view did load")
        broadcastTimer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: Selector("multipleSending"), userInfo: nil, repeats: true)
        broadcastTimer.fire()
    }

    override func viewWillDisappear(animated: Bool) {
        //startSending = true
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {

        tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine

        let cellIdentifier = "InterestCell"


        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? InterestCell
        if cell == nil {
            cell = InterestCell(style: .Subtitle, reuseIdentifier: cellIdentifier)
        }

        // Configure the cell to show todo item with a priority at the bottom
        if let object = object {
            cell?.interestTitle.text = object["title"] as? String
            var image = UIImage(named: object.objectForKey("interestType") as! String + " "  + (object.objectForKey("status") as! String)) as UIImage?

            if object.objectForKey("interestType") as! String == InterestType.Sport.rawValue {
                image = UIImage(named: object.objectForKey("title") as! String + " " + (object.objectForKey("status") as! String))
            }

            //determing flag for Language Tandem Interest
            if object.objectForKey("interestType") as! String == InterestType.Language.rawValue {
                cell?.countryFlag.image = UIImage(named: object.objectForKey("languageIWantToPractice") as! String)
            } else {
                cell?.countryFlag.image = nil
            }

            if object.objectForKey("interestType") as! String == InterestType.BoardGames.rawValue {
                image = UIImage(named: "BoardGames" + " " + (object.objectForKey("status") as! String))
                if object.objectForKey("title") as! String == "Poker" {
                    image = UIImage(named: "Poker" + " " + (object.objectForKey("status") as! String))
                }
            }

            let signalToMonitor = interestToSignalTransformer.transformInterestToSIgnal(object)

            if (object.objectForKey("status") as! String == "Active") {
                cell?.interestActivityStatus.text = "Active"
                cell?.interestActivityStatus.textColor = UIColor.orangeColor()
                cell?.interestTitle.textColor = UIColor.orangeColor()
            } else {
                cell?.interestActivityStatus.text = "Inactive"
                cell?.interestTitle.textColor = UIColor.lightGrayColor()
                cell?.interestActivityStatus.textColor = UIColor.lightGrayColor()
            }

            //cell?.interestButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
            cell?.interestButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
            cell!.interestButton.setImage(image, forState: .Normal)

        }

        //add a tag to the button (in order to be able to reference it) and a function
        cell?.interestButton.addTarget(self, action: "cellButtonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        cell?.interestButton.tag = indexPath.row

        return cell
    }


    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let object = self.objectAtIndexPath(indexPath)
        self.performSegueWithIdentifier(object?.objectForKey("interestType") as! String, sender: indexPath)
    }



    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }


    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {

            let dimensions = ["user": (PFUser.currentUser()?.username)! as String, "Interest type": objectAtIndexPath(indexPath)!.objectForKey("interestType") as! String,"Interest title": objectAtIndexPath(indexPath)!.objectForKey("title") as! String]
            PFAnalytics.trackEvent("InterestDeleted", dimensions: dimensions)

            //stop monitoring signal of this interest
            let signalToMonitor = interestToSignalTransformer.transformInterestToSIgnal(objectAtIndexPath(indexPath)!)
            BeaconSpotter.sharedInstance.stopMonitoringInterest(signalToMonitor)

            //delete this interest from realm
            let realm = try! Realm()

            let exstingInterest = realm.objectForPrimaryKey(SavedInterest.self, key: objectAtIndexPath(indexPath)!.objectForKey("identifier") as! String)
            try! realm.write {
                if exstingInterest != nil {
                    realm.delete(exstingInterest!)
                    print("deleted interest from realm")
                } else {

                }
            }

            self.removeObjectAtIndexPath(indexPath, animated: true)
            self.loadObjects()
        }
    }


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if segue.identifier == InterestType.Language.rawValue {
            let interestDetailVC = segue.destinationViewController as! AddLanguageTandemPartnerInterestVC
            interestDetailVC.selectedInterest = self.objectAtIndexPath((sender as! NSIndexPath))!
            interestDetailVC.comingFrom = "Search"
        }

        if segue.identifier == InterestType.Sport.rawValue {
            let interestDetailVC = segue.destinationViewController as! AddSportsInterest
            interestDetailVC.selectedInterest = self.objectAtIndexPath((sender as! NSIndexPath))!
            interestDetailVC.comingFrom = "Search"
        }

        if segue.identifier == InterestType.Partner.rawValue {
            let interestDetailVC = segue.destinationViewController as! AddPartnerInterest
            interestDetailVC.selectedInterest = self.objectAtIndexPath((sender as! NSIndexPath))!
            interestDetailVC.comingFrom = "Search"
        }

        if segue.identifier == InterestType.BoardGames.rawValue {
            let interestDetailVC = segue.destinationViewController as! AddPokerBoardGamesInterest
            interestDetailVC.selectedInterest = self.objectAtIndexPath((sender as! NSIndexPath))!
            interestDetailVC.comingFrom = "Search"
        }

        if segue.identifier == InterestType.SmallTalk.rawValue {
            let interestDetailVC = segue.destinationViewController as! AddSmallTalkInterest
            interestDetailVC.selectedInterest = self.objectAtIndexPath((sender as! NSIndexPath))!
            interestDetailVC.comingFrom = "Search"
        }
    }

    @IBAction func startButtonPressed(sender: AnyObject?) {

        if self.startButton.title == "Stop" {
            //self.sectionView.spinner.stopAnimating()
            self.startButton.title = "Start"
            self.broadcastTimer.invalidate()
            self.stopSendingMultiple()
            self.sectionView.spinner.stopAnimating()
            self.statusText = "Press the Start Button to start searching for matches"
            self.sectionView.statusLabel.text = self.statusText
            //BeaconSpotter.sharedInstance.stopAll()
        } else {
            self.startButton.title = "Stop"
            broadcastTimer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: Selector("multipleSending"), userInfo: nil, repeats: true)
            broadcastTimer.fire()
            self.sectionView.spinner.startAnimating()
        }
    }



    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        self.sectionView = (tableView.dequeueReusableCellWithIdentifier("Section") as? StartSeachingSection)!

        if self.startButton.title == "Start" || self.sectionView.statusLabel.text == "No active interests"{
        self.sectionView.spinner.stopAnimating()
        } else  {
            self.sectionView.spinner.startAnimating()
        }

        self.sectionView.statusLabel.text = self.statusText

       /* if self.sectionView.statusLabel.text != "No active interests" {
            self.sectionView.spinner.startAnimating()
        }*/

        return self.sectionView.contentView
    }


    func cellButtonClicked(sender: AnyObject) {

        let object = self.objects![sender.tag] as? PFObject

        let dimensions = ["Interest type": object!.objectForKey("interestType") as! String,"user": (PFUser.currentUser()?.username)! as String, "interest": object!.objectId! as String]
        PFAnalytics.trackEvent("ActivatedDeactivatedInterest", dimensions: dimensions)

        if (object!.objectForKey("status") as! String == "Active") {
            object!["status"] = "Inactive"
            self.stopSendingMultiple()
        } else {
            object!["status"] = "Active"
        }

        object!.saveInBackgroundWithBlock(){
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                //The object has been saved.
                self.loadObjects()
            } else {
                // There was a problem, check error.description
            }
        }
    }

    func multipleSending() {
        //print("multipleSending called")
        if self.objects?.count != 0 {// do I have interests to send as?
            if beaconToSendAs == activeInterests.count || beaconToSendAs > activeInterests.count {
                beaconToSendAs = 0
            }

            //create the signal that I will broadcast as
            if activeInterests.count > 0 {
                let signalToBroadcast = interestToSignalTransformer.transformInterestToSIgnal(activeInterests[self.beaconToSendAs]) //beaconToSendAs will be set to 0 once done

                if NSUserDefaults.standardUserDefaults().valueForKey("stopEverything") as! Bool == false {
                self.beaconSender.startBroadcastingInterestSignal(signalToBroadcast)
                } else {
                    self.beaconSender.stopSendingSignal()
                }

                self.statusText = "Searching Matches for: " + (activeInterests[self.beaconToSendAs].objectForKey("title") as! String)
                self.sectionView.statusLabel.text = self.statusText

                //self.sectionView.spinner.startAnimating()
                print(NSDate().description + " Searching Matches for: " + (activeInterests[self.beaconToSendAs].objectForKey("title") as! String))

                self.beaconToSendAs = self.beaconToSendAs+1
            } else {
                self.beaconSender.stopSendingSignal()
            }
        }
    }

    func stopSendingMultiple() {
        print("I stopped sending")
        self.beaconSender.stopSendingSignal()
    }

    func updateActiveInterests() {
        activeInterests.removeAll()
        for interest in self.objects! {
            if interest.objectForKey("status") as! String == "Active" {
                activeInterests.append(interest as! PFObject)
            }
        }
        
        if activeInterests.count == 0 {
            self.statusText = "No active interests"
            self.sectionView.spinner.stopAnimating()
        }
    }
}
