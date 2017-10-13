//
//  StartSearchingVC.swift
//  Beacon Social Matching
//
//  Created by Tsole on 16/9/15.
//  Copyright © 2015 Konstantinos Tsoleridis. All rights reserved.
//

import Foundation
import Parse
import UIKit

class StartSearchingVC: UIViewController,UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var startBtn: UIButton!
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var startButton: UIBarButtonItem!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!

    var myInterests:[AnyObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        statusLabel.text = "Press the Start Button to start searching in your area for Matches based on your interests"
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "reloadTableView:",
            name: "Reload Start Searching TableView",
            object: nil)

        //self.fetchAllObjects()
        self.activityIndicator.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func startButtonPressed(sender: AnyObject) {
    }


    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("InterestCell", forIndexPath: indexPath) as! InterestCell
        //var cell = InterestCell()

        /*if indexPath.row == 0{
            cell = tableView.dequeueReusableCellWithIdentifier("LanguageTandemInterestCell", forIndexPath: indexPath) as! InterestCell
        }

        if indexPath.row == 1 {
            cell = tableView.dequeueReusableCellWithIdentifier("PokerInterestCell", forIndexPath: indexPath) as! InterestCell
        }

        if indexPath.row == 2 {
            cell = tableView.dequeueReusableCellWithIdentifier("BoardGamesInterestCell", forIndexPath: indexPath) as! InterestCell
        }

        if indexPath.row == 3 {
            cell = tableView.dequeueReusableCellWithIdentifier("FootballInterestCell", forIndexPath: indexPath) as! InterestCell
        }

        if indexPath.row == 4 {
            cell = tableView.dequeueReusableCellWithIdentifier("RomanticPartnerInterestCell", forIndexPath: indexPath) as! InterestCell
        }*/

        let currentInterest = self.myInterests[indexPath.row]
        cell.interestTitle.text = currentInterest.objectForKey("title") as? String
        let image = UIImage(named: currentInterest.objectForKey("interestType") as! String + " Active") as UIImage?
        cell.interestButton.setBackgroundImage(image, forState: .Normal)

        let labelCell = cell.interestActivityStatus
        let buttonCell = cell.interestButton

        buttonCell.addTarget(self, action: "cellButtonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        buttonCell.tag = indexPath.row


        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.myInterests.count
    }

    @IBAction func startButonPressed(sender: AnyObject) {

        if startButton.title == "Stop searching" {
            startButton.title = "Start"
            statusLabel.text = "Press the Start Button to start searching in your area for matches based on your interests"
            activityIndicator.stopAnimating()
            activityIndicator.hidden = true
        } else if startButton.title == "Start" {

            startButton.title = "Stop searching"
            self.statusLabel.text = "Searching matches for language tandem partner..."
            let timer = NSTimer.scheduledTimerWithTimeInterval(20.0, target: self, selector:  Selector("switchInterest"), userInfo: nil, repeats: false)
            activityIndicator.hidden = false
            activityIndicator.startAnimating()
        }
    }


    func switchInterest(){
        // do your stuff here
        self.statusLabel.text = "Searching matches for people to play poker with..."
        let timer = NSTimer.scheduledTimerWithTimeInterval(20.0, target: self, selector:  Selector("switchInterest2"), userInfo: nil, repeats: false)
    }


    func switchInterest2(){
        // do your stuff here
        self.statusLabel.text = "Searching matches for people to play catan with..."
        let timer = NSTimer.scheduledTimerWithTimeInterval(20.0, target: self, selector:  Selector("switchInterest3"), userInfo: nil, repeats: false)
    }


    func switchInterest3(){
        // do your stuff here
        self.statusLabel.text = "Searching matches for people to play football with..."
        let timer = NSTimer.scheduledTimerWithTimeInterval(20.0, target: self, selector:  Selector("switchInterest"), userInfo: nil, repeats: false)
    }


    func cellButtonClicked(sender: AnyObject) {
        //println(String(sender.tag) + " clicked")
        //BeaconSenderManager.sharedInstance.updateBeaconRegionFromWhichISend(sender.tag)
        //BeaconSenderManager.sharedInstance.beaconsToSendAs[sender.tag].sendingAs = !BeaconSenderManager.sharedInstance.beaconsToSendAs[sender.tag].sendingAs

        self.tableView.reloadData()
    }

    override func viewWillAppear(animated: Bool) {
        self.retrieveinterestsInLocalStore()
        self.tabBarController?.tabBar.hidden = false
        self.navigationController?.toolbar.hidden = true
    }

    override func viewDidAppear(animated: Bool) {
        self.tableView.flashScrollIndicators()
        self.navigationController!.navigationBar.clipsToBounds = true;

    }

    func retrieveinterestsInLocalStore() {

        let queryInterests = PFQuery(className: "Interest")
        queryInterests.fromLocalDatastore()
        queryInterests.whereKey("interestOwner", equalTo: PFUser.currentUser()!)
        queryInterests.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) Interests.")
                // Do something with the found objects
                if let objects = objects as [PFObject]! {

                    //upload objects from local storage to parseCloud
                    for object in objects {
                        object.saveInBackground()
                    }

                    self.myInterests = objects
                    self.tableView.reloadData()
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }

    // Mark: Fetch all objects from Parse (and replace local storage if uncommented)
    func fetchAllObjects() {

        //PFObject.unpinAllObjectsInBackgroundWithBlock(nil)

        let query: PFQuery = PFQuery(className: "Interest")

        query.whereKey("interestOwner", equalTo: PFUser.currentUser()!)

        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in

            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count)  jobs from database.")
                // Do something with the found objects
                if let objects = objects as [PFObject]! {
                    for object in objects {
                        //print(object.objectId)
                    }
                }
                self.tableView.reloadData()
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }   
        }
    }

    @objc func reloadTableView (notification: NSNotification){
        if notification.name == "Reload Start Searching TableView" {
            self.retrieveinterestsInLocalStore()
        }
    }
    
}