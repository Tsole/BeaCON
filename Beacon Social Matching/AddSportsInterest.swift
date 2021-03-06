//
//  File.swift
//  Beacon Social Matching
//
//  Created by Tsole on 29/9/15.
//  Copyright © 2015 Konstantinos Tsoleridis. All rights reserved.
//

import Foundation
import UIKit
import Parse
import ParseUI
import RealmSwift
import DBAlertController

class AddSportsInterest: AddAbstractInterestTVC {

    @IBOutlet var opennessLevelLabel: UILabel!
    @IBOutlet var opennessSlider: UISlider!

    @IBOutlet var ageLevelLabel: UILabel!
    @IBOutlet var ageSlider: UISlider!

    @IBOutlet var sportSelectedLabel: UILabel!
    @IBOutlet var sportSelectedImage: UIImageView!

    @IBOutlet var frequencyLabel: UILabel!
    @IBOutlet var frequencySlider: UISlider!

    @IBOutlet var languagesISpeak: UILabel!

    @IBOutlet var deleteCell: UITableViewCell!
    @IBOutlet var matchesCell: UITableViewCell!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.deleteCell.hidden = true
        self.matchesCell.hidden = true

        if self.comingFrom == "Search" {

            self.saveButton.title = "Save Changes"
            //self.deleteCell.hidden = false
            self.saveButton.enabled = true

            self.sportSelectedLabel.text = (selectedInterest.objectForKey("title") as! String)
            self.sportSelectedImage.image = UIImage(named: selectedInterest.objectForKey("title") as! String)

            self.opennessLevelLabel.text = (selectedInterest.objectForKey("openness") as! String)
            self.frequencyLabel.text = (selectedInterest.objectForKey("frequency") as! String)
            self.ageLevelLabel.text = (selectedInterest.objectForKey("myAge") as! String)
            self.languagesISpeak.text = (selectedInterest.objectForKey("languagesISpeak") as! String)

            self.opennessSlider.value = self.returnFloatFromOpenness(selectedInterest.objectForKey("openness") as! String)
            self.ageSlider.value = self.returnFloatFromAge(selectedInterest.objectForKey("myAge") as! String)
            self.frequencySlider.value = self.returnFloatFromFrequency(selectedInterest.objectForKey("frequency") as! String)
        }

        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "sportSelected:",
            name: "Selected Sport",
            object: nil)

        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "languagesISpeakSelected:",
            name: "Selected Languages I Speak",
            object: nil)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func frequencySLider(sender: UISlider) {

        let currentValue = Double(sender.value)
        self.frequencyLabel.text = self.returnFrequencyStringBasedOnPassedValue(currentValue)

    }


    @IBAction func ageSLider(sender: UISlider) {

        let currentValue = Double(sender.value)
        self.ageLevelLabel.text = returnAgeStringBasedOnPassedValue(currentValue)
    }


    @IBAction func opennessSlider(sender: UISlider) {

        let currentValue = Double(sender.value)
        self.opennessLevelLabel.text = self.returnOpennessStringBasedOnPassedValue(currentValue)
    }


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {

    }

    @objc func sportSelected (notification: NSNotification) {
        let sportSelected = notification.object as! String
        self.sportSelectedLabel.text = sportSelected
        self.sportSelectedImage.image = UIImage(named: sportSelected)

        if sportSelectedLabel.text != "Select"  {
            self.saveButton.enabled = true
        }
    }


    @objc func languagesISpeakSelected (notification: NSNotification) {
        let languagesISpeak = notification.object as! String
        self.languagesISpeak.text = languagesISpeak
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

        interestToBeSaved["interestType"] = InterestType.Sport.rawValue
        interestToBeSaved["title"] = self.sportSelectedLabel.text

        interestToBeSaved["interestOwner"] = PFUser.currentUser()

        interestToBeSaved["openness"] = self.opennessLevelLabel.text
        interestToBeSaved["frequency"] = self.frequencyLabel.text
        interestToBeSaved["myAge"] = self.ageLevelLabel.text
        interestToBeSaved["languagesISpeak"] = self.languagesISpeak.text
        interestToBeSaved["status"] = "Active"

        let identifier = InterestType.Sport.rawValue + " " + self.sportSelectedLabel.text!
        interestToBeSaved["identifier"] = identifier

        //check if I already have an Interest with the same Identifier
        if self.saveButton.title == "Save Changes" {
            self.saveInterestWithAlertMessage(interestToBeSaved, messageToShow: alertToShow)
        }

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
    
    
    @IBAction func deleteButtonPressed(sender: AnyObject) {
        self.deleteInterest(self.selectedInterest)
    }
}
