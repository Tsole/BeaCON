//
//  AddANewInterestVC.swift
//  Beacon Social Matching
//
//  Created by Tsole on 21/9/15.
//  Copyright © 2015 Konstantinos Tsoleridis. All rights reserved.
//

import Foundation
import UIKit
import Parse
import ParseUI
import DBAlertController
import RealmSwift

class AddLanguageTandemPartnerInterestVC: AddAbstractInterestTVC {

    @IBOutlet var languageIWantToPractice: UILabel!
    @IBOutlet var languageIAmOffering: UILabel!
    @IBOutlet var flagFromlanguageIWantToPractice: UIImageView!
    @IBOutlet var flagFromLanguageIamOffering: UIImageView!

    @IBOutlet var languageIAmOfferingSkillLabel: UILabel!
    @IBOutlet var languageIwantToPracticeSkillLabel: UILabel!
    @IBOutlet var languageOfferingSkillLevelLabel: UILabel!
    @IBOutlet var languagePracticingSkillLevelLabel: UILabel!

    @IBOutlet var languageOfferingSlider: UISlider!
    @IBOutlet var languagePracticingSlider: UISlider!

    @IBOutlet var opennessLevelLabel: UILabel!
    @IBOutlet var opennessSlider: UISlider!

    @IBOutlet var deleteCell: UITableViewCell!


    override func viewDidLoad() {
        super.viewDidLoad()
        /*self.saveButton = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.Done , target: self, action: "saveButtonPressed")
        self.navigationItem.rightBarButtonItem = self.saveButton
        self.saveButton.enabled = false*/
        self.deleteCell.hidden = true


        // Do any additional setup after loading the view, typically from a nib.
        if self.comingFrom == "Search" {
            //self.selectedInterest = self.retrieveItemWithObjectID(self.objectIDFromPassedItem)
            self.saveButton.title = "Save Changes"
            //self.deleteCell.hidden = false
            self.saveButton.enabled = true

            self.languageIAmOffering.text = (selectedInterest.objectForKey("languageISpeak") as! String)
            self.flagFromLanguageIamOffering.image = UIImage(named: selectedInterest.objectForKey("languageISpeak") as! String)
            self.languageIAmOfferingSkillLabel.text = (selectedInterest.objectForKey("languageISpeak") as! String) + " Level"

            self.languageIWantToPractice.text = (selectedInterest.objectForKey("languageIWantToPractice") as! String)
            self.flagFromlanguageIWantToPractice.image = UIImage(named: selectedInterest.objectForKey("languageIWantToPractice") as! String)
            self.languageIwantToPracticeSkillLabel.text = (selectedInterest.objectForKey("languageIWantToPractice") as! String) + " Level"


            if (selectedInterest.objectForKey("openness") != nil) {
                self.opennessLevelLabel.text = (selectedInterest.objectForKey("openness") as! String)
            }

            self.languagePracticingSkillLevelLabel.text = (selectedInterest.objectForKey("languageIWantToPracticeSkillLevel") as! String)
            self.languageOfferingSkillLevelLabel.text = (selectedInterest.objectForKey("languageISpeakSkillLevel") as! String)

            //set slider values from corresponding methods
            self.opennessSlider.value = self.returnFloatFromOpenness(selectedInterest.objectForKey("openness") as! String)
            self.languageOfferingSlider.value = self.returnFloatFromLanguageSKill(selectedInterest.objectForKey("languageISpeakSkillLevel") as! String)
            self.languagePracticingSlider.value = self.returnFloatFromLanguageSKill(selectedInterest.objectForKey("languageIWantToPracticeSkillLevel") as! String)

            //enable modifications of skill level without having to reselect language
            self.languagePracticingSlider.userInteractionEnabled = true
            self.languageOfferingSlider.userInteractionEnabled = true

        }

        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "languageIwantToPracticeSelected:",
            name: "Selected language I want To Practice",
            object: nil)

        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "languageIAmOffering:",
            name: "Selected language I want To Offer",
            object: nil)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*@IBAction func saveButtonPressed(sender: AnyObject) {
    //var currentValue = Int(sender.value)
    self.dismissViewControllerAnimated(true, completion: nil)

    }*/

    @IBAction func languageIAmOfferingSlider(sender: UISlider) {
        let currentValue = Int(sender.value)

        switch currentValue {
        case 0:
            self.languageOfferingSkillLevelLabel.text = LanguageSkill.NoEntry.rawValue
        case 1:
            self.languageOfferingSkillLevelLabel.text = LanguageSkill.B.rawValue
        case 2:
            self.languageOfferingSkillLevelLabel.text = LanguageSkill.G.rawValue
        case 3:
            self.languageOfferingSkillLevelLabel.text = LanguageSkill.VG.rawValue
        case 4:
            self.languageOfferingSkillLevelLabel.text = LanguageSkill.E.rawValue
        case 5:
            self.languageOfferingSkillLevelLabel.text = LanguageSkill.N.rawValue
        default: break

        }

        if self.saveButton.title == "Save Changes" {
            self.saveButton.enabled = true
        }
    }

    @IBAction func languageIAmPracticingSlider(sender: UISlider) {
        let currentValue = Int(sender.value)

        switch currentValue {
        case 0:
            self.languagePracticingSkillLevelLabel.text = LanguageSkill.NoEntry.rawValue
        case 1:
            self.languagePracticingSkillLevelLabel.text = LanguageSkill.B.rawValue
        case 2:
            self.languagePracticingSkillLevelLabel.text = LanguageSkill.G.rawValue
        case 3:
            self.languagePracticingSkillLevelLabel.text = LanguageSkill.VG.rawValue
        case 4:
            self.languagePracticingSkillLevelLabel.text = LanguageSkill.E.rawValue
        case 5:
            self.languagePracticingSkillLevelLabel.text = LanguageSkill.N.rawValue
        default: break

        }

        if self.saveButton.title == "Save Changes" {
            self.saveButton.enabled = true
        }
    }

    @IBAction func opennessSlider(sender: UISlider) {
        let currentValue = Double(sender.value)

        self.opennessLevelLabel.text = self.returnOpennessStringBasedOnPassedValue(currentValue)

        if self.saveButton.title == "Save Changes" {
            self.saveButton.enabled = true
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {

        if segue.identifier == "selectLanguageIWantToPractice" {
            self.comingFrom = "I want to practice: "
            let destinationVC = segue.destinationViewController as! ChooseLanguageTVC
            destinationVC.comingFrom = self.comingFrom

        } else if segue.identifier == "selectLanguageIOffer" {
            self.comingFrom = "I am offering: "
            let destinationVC = segue.destinationViewController as! ChooseLanguageTVC
            destinationVC.comingFrom = self.comingFrom
        }
    }

    @objc func languageIwantToPracticeSelected (notification: NSNotification) {
        let languageSelected = notification.object as! String
        self.languageIWantToPractice.text = languageSelected
        self.languageIwantToPracticeSkillLabel.text = languageSelected + " Level:"
        self.flagFromlanguageIWantToPractice.image = UIImage(named: languageSelected)
        self.languagePracticingSlider.userInteractionEnabled = true

        if languageIWantToPractice.text != "Select" && languageIAmOffering.text != "Select" {
            self.saveButton.enabled = true
            //self.saveButton.backgroundColor = UIColor.greenColor()
        }

        if self.saveButton.title == "Save Changes" && languageIWantToPractice.text != "Select" && languageIAmOffering.text != "Select" {
            self.saveButton.enabled = true
        }
    }

    @objc func languageIAmOffering (notification: NSNotification) {
        let languageSelected = notification.object as! String
        self.languageIAmOffering.text = languageSelected
        self.languageIAmOfferingSkillLabel.text = languageSelected + " Level:"
        self.flagFromLanguageIamOffering.image = UIImage(named: languageSelected)
        self.languageOfferingSlider.userInteractionEnabled = true

        if languageIWantToPractice.text != "Select" && languageIAmOffering.text != "Select" {
            self.saveButton.enabled = true
            //self.saveButton.backgroundColor = UIColor.greenColor()
        }

        if self.saveButton.title == "Save Changes" && languageIWantToPractice.text != "Select" && languageIAmOffering.text != "Select" {
            self.saveButton.enabled = true
        }
    }

    //duplicate code if modifying an interest or searching for first time
    func saveButtonPressed() {

        var interestToBeSaved = PFObject(className:"Interest")
        var alertToShow = "You have created a new Interest"
        //create Parse Object
        if self.saveButton.title == "Save Changes" {

            //var query = PFQuery(className:"Interest")
            interestToBeSaved = self.selectedInterest
            alertToShow = "You have modified the parametes of an existing Interest"

        }

        interestToBeSaved["interestType"] = InterestType.Language.rawValue
        interestToBeSaved["title"] = self.languageIWantToPractice.text!
        interestToBeSaved["languageIWantToPractice"] = self.languageIWantToPractice.text
        interestToBeSaved["languageISpeak"] = self.languageIAmOffering.text

        interestToBeSaved["interestOwner"] = PFUser.currentUser()

        interestToBeSaved["openness"] = self.opennessLevelLabel.text
        interestToBeSaved["languageISpeakSkillLevel"] = self.languageOfferingSkillLevelLabel.text
        interestToBeSaved["languageIWantToPracticeSkillLevel"] = self.languagePracticingSkillLevelLabel.text
        interestToBeSaved["status"] = "Active"

        let identifier = InterestType.Language.rawValue + " " + self.languageIWantToPractice.text! + " " + self.languageIAmOffering.text!
        interestToBeSaved["identifier"] = identifier



        //check if I already have an Interest with the same Identifier
        if self.saveButton.title == "Save Changes" {
            self.saveInterestWithAlertMessage(interestToBeSaved, messageToShow: alertToShow)
        }

        //duplicate code!, this code tests whether an interest with such an identifier already exists
        let realm = try! Realm()
        let exstingInterest = realm.objectForPrimaryKey(SavedInterest.self, key: identifier)
        try! realm.write {
            if exstingInterest != nil {
                //print("exists")
                if self.saveButton.title == "Save" {// make  sure that I am not changing interests
                    let alertController = DBAlertController(title: "Interest exists", message: "You already have an Interest with these characteristics!", preferredStyle: .Alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                    alertController.show()
                }
            } else {
                //print("does not exist")
                self.saveInterestWithAlertMessage(interestToBeSaved, messageToShow: alertToShow)
            }
        }
    }


    @IBAction func deleteButtonPressed(sender: AnyObject) {

        self.deleteInterest(self.selectedInterest)
    }


    func returnFloatFromLanguageSKill(openness: String) -> Float {
        
        var valueToReturn:Float = 0.00
        
        switch openness {
        case "No Selection": valueToReturn = 0
        case "Basic": valueToReturn = 1
        case "Good": valueToReturn = 2
        case "Very Good": valueToReturn = 3
        case "Excellent": valueToReturn = 4
        case "Native": valueToReturn = 5
        default: break
        }
        
        return valueToReturn
    }
    
}