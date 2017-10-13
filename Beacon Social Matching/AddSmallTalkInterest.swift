//
//  AddSmallTalkInterest.swift
//  BeaCON
//
//  Created by Tsole on 18/11/15.
//  Copyright © 2015 Konstantinos Tsoleridis. All rights reserved.
//

import UIKit
import Parse
import DBAlertController
import RealmSwift

class AddSmallTalkInterest: AddAbstractInterestTVC {

    @IBOutlet var opennessLevelLabel: UILabel!
    @IBOutlet var opennessSlider: UISlider!

    @IBOutlet var ageLevelLabel: UILabel!
    @IBOutlet var ageSlider: UISlider!

    @IBOutlet var myGenderControl: UISegmentedControl!

    @IBOutlet var languagesISpeak: UILabel!

    @IBOutlet var deleteCell: UITableViewCell!
    @IBOutlet var matchesCell: UITableViewCell!

    @IBOutlet var topicLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.deleteCell.hidden = true
        self.saveButton.enabled = false
        self.matchesCell.hidden = true

        if self.comingFrom == "Search" {
            self.saveButton.enabled = true
            self.saveButton.title = "Save Changes"
            self.saveButton.enabled = true
            //self.deleteCell.hidden = false

            self.opennessLevelLabel.text = (selectedInterest.objectForKey("openness") as! String)
            self.ageLevelLabel.text = (selectedInterest.objectForKey("myAge") as! String)
            self.languagesISpeak.text = (selectedInterest.objectForKey("languagesISpeak") as! String)

            self.opennessSlider.value = self.returnFloatFromOpenness(selectedInterest.objectForKey("openness") as! String)
            self.ageSlider.value = self.returnFloatFromAge(selectedInterest.objectForKey("myAge") as! String)
            self.topicLabel.text = "Topic: " + (selectedInterest.objectForKey("topic") as! String)

            if selectedInterest.objectForKey("myGender") as! String == "Man" {
                self.myGenderControl.selectedSegmentIndex = 1
            }
        }

        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "languagesISpeakSelected:",
            name: "Selected Languages I Speak",
            object: nil)

        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "topicSelected:",
            name: "Selected Topic",
            object: nil)
    }

    @IBAction func ageSLider(sender: UISlider) {
        let currentValue = Double(sender.value)
        self.ageLevelLabel.text = returnAgeStringBasedOnPassedValue(currentValue)
    }


    @IBAction func opennessSlider(sender: UISlider) {

        let currentValue = Double(sender.value)
        self.opennessLevelLabel.text = self.returnOpennessStringBasedOnPassedValue(currentValue)
    }


    func saveButtonPressed() {

        var interestToBeSaved = PFObject(className:"Interest")
        var alertToShow = "You have created a new Interest"
        //create Parse Object
        if self.saveButton.title == "Save Changes" {

            //var query = PFQuery(className:"Interest")
            interestToBeSaved = self.selectedInterest
            alertToShow = "You have modified the parametes of an existing Interest"

        }

        interestToBeSaved["interestType"] = InterestType.SmallTalk.rawValue
        interestToBeSaved["title"] = InterestType.SmallTalk.rawValue + " " + self.topicLabel.text!.stringByReplacingOccurrencesOfString("Topic: ", withString: "", options: .RegularExpressionSearch, range: nil)


        interestToBeSaved["interestOwner"] = PFUser.currentUser()
        interestToBeSaved["myGender"] = self.myGenderControl.titleForSegmentAtIndex(self.myGenderControl.selectedSegmentIndex)
        interestToBeSaved["topic"] = self.topicLabel.text!.stringByReplacingOccurrencesOfString("Topic: ", withString: "", options: .RegularExpressionSearch, range: nil)
        interestToBeSaved["openness"] = self.opennessLevelLabel.text
        interestToBeSaved["myAge"] = self.ageLevelLabel.text
        interestToBeSaved["languagesISpeak"] = self.languagesISpeak.text
        interestToBeSaved["status"] = "Active"

        let identifier = InterestType.SmallTalk.rawValue + " " + self.topicLabel.text!
        interestToBeSaved["identifier"] = identifier

        //duplicate test for all Interests
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


    @objc func languagesISpeakSelected (notification: NSNotification) {
        let languagesISpeak = notification.object as! String
        self.languagesISpeak.text = languagesISpeak
    }

    @objc func topicSelected (notification: NSNotification) {
        let topicISpeak = notification.object as! String
        self.saveButton.enabled = true
        self.topicLabel.text = "Topic: " + topicISpeak
    }


    @IBAction func deleteButtonPressed(sender: AnyObject) {

        //self.deleteInterest(self.retrieveItemWithObjectID(self.selectedInterest.objectId!))
        self.deleteInterest(self.selectedInterest)
    }
}
