//
//  FirstViewController.swift
//  Beacon Social Matching
//
//  Created by Tsole on 16/9/15.
//  Copyright © 2015 Konstantinos Tsoleridis. All rights reserved.
//

import UIKit
import MessageUI

class HelpVC: UITableViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet var previousMatchVC: UISegmentedControl!
    @IBOutlet var broadcastRotationVC: UISegmentedControl!

    @IBOutlet var stopEverythingSwitch: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //let userDefaults = NSUserDefaults.standardUserDefaults()
        self.stopEverythingSwitch.on = NSUserDefaults.standardUserDefaults().valueForKey("stopEverything") as! Bool
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func sendFeedbackButtonPressed(sender: AnyObject) {

        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = self
        mailComposer.setSubject("[Feedback] BeaCON App")
        mailComposer.setToRecipients(["konstantinos.tsoleridis@rwth-aachen.de"])

        presentViewController(mailComposer, animated: true, completion: nil)
    }

    @IBAction func requestHelpButtonPressed(sender: AnyObject) {

        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = self
        mailComposer.setSubject("[Help] BeaCON App")
        mailComposer.setToRecipients(["konstantinos.tsoleridis@rwth-aachen.de"])

        presentViewController(mailComposer, animated: true, completion: nil)

    }

    // MFMailComposeViewControllerDelegate

    // 1
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    // UITextFieldDelegate

    // 2
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        return true
    }

    // UITextViewDelegate

    // 3
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {

        return true
    }

    @IBAction func previousMatchTimeAdjusted(sender: AnyObject) {
        var segmentTitle = self.previousMatchVC.titleForSegmentAtIndex(self.previousMatchVC.selectedSegmentIndex)

        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

        if segmentTitle == "10 seconds" {
             appDelegate.timeForNotification = 10
        } else if segmentTitle == "15 minutes" {
            appDelegate.timeForNotification = 15*60
        } else if segmentTitle == "1 hour" {
            appDelegate.timeForNotification = 1*60*60
        }
    }

    @IBAction func switchedStopEverythingState(sender: AnyObject) {

        let userDefaults = NSUserDefaults.standardUserDefaults()
        if var stopEverything = userDefaults.valueForKey("stopEverything") {
            // do something here when stopEverything exists
            if self.stopEverythingSwitch.on == true {
                stopEverything = true
                BeaconSpotter.sharedInstance.stopAll()
            } else {
                stopEverything = false
            }
            userDefaults.setValue(stopEverything, forKey: "stopEverything")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        print("StopEverything: " + String(NSUserDefaults.standardUserDefaults().valueForKey("stopEverything") as! Bool))
    }


    @IBOutlet var broadcastRotationTimeAdjusted: UISegmentedControl!

}

