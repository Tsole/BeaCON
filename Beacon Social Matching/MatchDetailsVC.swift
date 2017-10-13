//
//  MatchDetailsVC.swift
//  BeaCON
//
//  Created by Tsole on 5/12/15.
//  Copyright © 2015 Konstantinos Tsoleridis. All rights reserved.
//

import UIKit
import Parse
import MessageUI
import DBAlertController

class MatchDetailsVC: UIViewController, MFMessageComposeViewControllerDelegate, UINavigationControllerDelegate {

    var selectedMatch = PFObject(className:"Match")
    var matchedUser = PFUser()
    //var


    @IBOutlet var userImage: UIImageView!

    @IBOutlet var userName: UILabel!

    @IBOutlet var matchDetails: UITextView!


    override func viewDidLoad() {
        self.userName.text = retrieveUserNameFromMatchedUser()
        self.matchDetails.text = retrieveMatchDetailsFromMatchedUser()
        self.matchedUser = retrieveMatchedUser()

        let dimensions = NSDictionary()
        PFAnalytics.trackEvent("MatchDetailsViewLoaded", dimensions:(dimensions as! [String : String]))
    }

    override func viewDidAppear(animated: Bool) {
        //self.matchedUser = retrieveMatchedUser()
        if let userImageFile = try! matchedUser.fetchIfNeeded().objectForKey("userImage") as? PFFile {
            userImageFile.getDataInBackgroundWithBlock {
                (imageData: NSData?, error: NSError?) -> Void in
                if error == nil {
                    if let imageData = imageData {
                        let image = UIImage(data:imageData)
                        self.userImage.image = image
                    }
                }
            }
        }
    }

    func retrieveUserNameFromMatchedUser() -> String {
        var userNameToReturn = ""

        if PFUser.currentUser()?.username == (self.selectedMatch.objectForKey("matchOwner1UserName") as! String) {
            userNameToReturn = self.selectedMatch.objectForKey("matchOwner2UserName") as! String
        } else {
            userNameToReturn = self.selectedMatch.objectForKey("matchOwner1UserName") as! String
        }

        return userNameToReturn
    }

    func retrieveMatchedUser() -> PFUser {
        var userToReturn = PFUser()

        if PFUser.currentUser()?.username == (self.selectedMatch.objectForKey("matchOwner1UserName") as! String) {
            userToReturn = self.selectedMatch.objectForKey("matchOwner2") as! PFUser
        } else {
            userToReturn = self.selectedMatch.objectForKey("matchOwner1") as! PFUser
        }

        return userToReturn
    }

    //this method should be reworked as it ist largely duplicate code from SignalToInterestTransformer
    func retrieveMatchDetailsFromMatchedUser() -> String {

        var textToReturn = ""
        var majorToDecode = ""
        print(PFUser.currentUser()?.username)
        if PFUser.currentUser()?.username == (self.selectedMatch.objectForKey("matchOwner1UserName") as! String) {
            majorToDecode = self.selectedMatch.objectForKey("matchOwner2Major") as! String
        } else {
            majorToDecode = self.selectedMatch.objectForKey("matchOwner1Major") as! String
        }

        let interestToReturn = MegaInterest()

        let major = String(majorToDecode)
        let first = major[major.startIndex]
        let second = major[major.startIndex.advancedBy(1)]
        let third = major[major.startIndex.advancedBy(2)]
        let fourth = major[major.startIndex.advancedBy(3)]
        let fifth = major[major.startIndex.advancedBy(4)]



        interestToReturn.interestType = selectedMatch.objectForKey("interestType") as! String
        //use a signalToInterestTransformer object to decode the major into String
        let signalToInterestTransformer = SignalToInterestTransformer()

        if interestToReturn.interestType == InterestType.Sport.rawValue {
            interestToReturn.title = signalToInterestTransformer.sportTypeFromCharacter(first)
            interestToReturn.frequency = signalToInterestTransformer.frequencyFromCharacter(second)
            interestToReturn.myAge = signalToInterestTransformer.myAgeFromCharacter(third)
            interestToReturn.openness = signalToInterestTransformer.oppennessFromCharacter(fourth)
            interestToReturn.languagesISpeak = signalToInterestTransformer.languagesFromCharacter(fifth)

            textToReturn = interestToReturn.title + "\nExperience: " + interestToReturn.frequency! + "\nAge: " + interestToReturn.myAge! + "\nOpenness: " + interestToReturn.openness! + "\nSpeaks: " + interestToReturn.languagesISpeak!
        }

        if interestToReturn.interestType == InterestType.BoardGames.rawValue {
            interestToReturn.title = signalToInterestTransformer.gamesTypeFromCharacter(first)
            interestToReturn.frequency = signalToInterestTransformer.frequencyFromCharacter(second)
            interestToReturn.myAge = signalToInterestTransformer.myAgeFromCharacter(third)
            interestToReturn.openness = signalToInterestTransformer.oppennessFromCharacter(fourth)
            interestToReturn.languagesISpeak = signalToInterestTransformer.languagesFromCharacter(fifth)

            textToReturn = interestToReturn.title + "\nExperience: " + interestToReturn.frequency! + "\nAge:" + interestToReturn.myAge! + "\nOpenness: " + interestToReturn.openness! + "\nSpeaks: " + interestToReturn.languagesISpeak!
        }

        if interestToReturn.interestType == InterestType.SmallTalk.rawValue {
            interestToReturn.title = signalToInterestTransformer.topicFromCharacter(first)
            interestToReturn.myAge = signalToInterestTransformer.myAgeFromCharacter(second)
            interestToReturn.openness = signalToInterestTransformer.oppennessFromCharacter(third)
            interestToReturn.myGender = signalToInterestTransformer.myGenderFromCharacter(fourth)
            interestToReturn.languagesISpeak = signalToInterestTransformer.languagesFromCharacter(fifth)

            textToReturn = interestToReturn.title + "\nAge: " + interestToReturn.myAge! + "\nIs: " + interestToReturn.openness! + "\nIs a: " + interestToReturn.myGender! + "\nSpeaks: " + interestToReturn.languagesISpeak!
        }

        if interestToReturn.interestType == InterestType.Language.rawValue {
            interestToReturn.title = signalToInterestTransformer.languageFromCharacter(first)
            interestToReturn.languageIwantToPractice = signalToInterestTransformer.languageFromCharacter(first)
            interestToReturn.languageISpeak = signalToInterestTransformer.languageFromCharacter(fifth)
            interestToReturn.skillLanguageIWantToPractice = signalToInterestTransformer.skilllevelLanguageFromCharacter(second)
            interestToReturn.skillLanguageISpeak = signalToInterestTransformer.skilllevelLanguageFromCharacter(third)
            interestToReturn.openness = signalToInterestTransformer.oppennessFromCharacter(fourth)

            textToReturn = "\nWants to practice: " + interestToReturn.languageIwantToPractice! + "\nSpeaks: " + interestToReturn.languageISpeak! + "\nSkill in " + interestToReturn.languageIwantToPractice! + " " + interestToReturn.skillLanguageIWantToPractice! + "\nSkill in " + interestToReturn.languageISpeak! + " " + interestToReturn.skillLanguageISpeak! + "\nIs: " + interestToReturn.openness!
        }

        if interestToReturn.interestType == InterestType.Partner.rawValue {
            interestToReturn.myAge = signalToInterestTransformer.myAgeFromCharacter(first)
            interestToReturn.genderMatch = signalToInterestTransformer.genderMatchFromCharacter(second)
            interestToReturn.appearanceBody = signalToInterestTransformer.appearanceBodyFromCharacter(third)
            interestToReturn.openness = signalToInterestTransformer.oppennessFromCharacter(fourth)
            interestToReturn.appearanceHeight = signalToInterestTransformer.appearanceHeightFromCharacter(fifth)

            textToReturn = "\nAge: " + interestToReturn.myAge! + "\nIs a: " + interestToReturn.genderMatch! + "\nAppearance: " + interestToReturn.appearanceBody! + "\nHeight: " + interestToReturn.appearanceHeight! + "\nIs: " + interestToReturn.openness!
        }

        return textToReturn
    }

    @IBAction func sendAnSMSButtonPressed(sender: AnyObject) {

        let messageVC = MFMessageComposeViewController()

        messageVC.body = "Hi! We matched in Beacon";
        //messageVC.recipients = [PFUser.currentUser()!["phoneNumber"] as! String]

        if  (try! matchedUser.fetchIfNeeded().objectForKey("phoneNumber")) as? String != "" &&  (try! matchedUser.fetchIfNeeded().objectForKey("phoneNumber")) != nil {

            messageVC.recipients = [try! matchedUser.fetchIfNeeded().objectForKey("phoneNumber") as! String]
            messageVC.messageComposeDelegate = self;
            self.presentViewController(messageVC, animated: false, completion: nil)
        } else {
            //print("No phone number provided")
            let alertController = DBAlertController(title: "Can't send an SMS", message: "Sorry, the matched user did not provide a phone number", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            alertController.show()
        }

    }

    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
        switch (result) {
        case MessageComposeResultCancelled:
            break

        case MessageComposeResultFailed:
            let alert = UIAlertController(title: "Alert", message: "Your device doesn't support SMS!", preferredStyle: UIAlertControllerStyle.Alert)

            let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in

            })
            alert.addAction(ok)
            self.presentViewController(alert, animated: true, completion: nil)
            break
        case MessageComposeResultSent:
            break
            
        default:
            break
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}