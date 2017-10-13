//
//  AddPartnerInterest.swift
//  BeaCON
//
//  Created by Tsole on 16/11/15.
//  Copyright © 2015 Konstantinos Tsoleridis. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import RealmSwift
import DBAlertController


class AddPartnerInterest: AddAbstractInterestTVC {

    @IBOutlet var opennessLevelLabel: UILabel!
    @IBOutlet var opennessSlider: UISlider!

    @IBOutlet var ageLevelLabel: UILabel!
    @IBOutlet var ageSlider: UISlider!

    @IBOutlet var heightLabel: UILabel!
    @IBOutlet var heightSlider: UISlider!

    @IBOutlet var apperanceSlider: UISlider!
    @IBOutlet var apperanceLabel: UILabel!

    @IBOutlet var myGenderControl: UISegmentedControl!
    @IBOutlet var interestedInControl: UISegmentedControl!

    @IBOutlet var deleteCell: UITableViewCell!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.deleteCell.hidden = true
        //self.matchesCell.hidden = true

        if self.comingFrom == "Search" {

            self.saveButton.title = "Save Changes"
            self.saveButton.enabled = true
            //self.deleteCell.hidden = false

            //self.gameSelectedLabel.text = (selectedInterest.objectForKey("title") as! String)

            self.opennessLevelLabel.text = (selectedInterest.objectForKey("openness") as! String)
            self.heightLabel.text = (selectedInterest.objectForKey("myHeight") as! String)
            self.ageLevelLabel.text = (selectedInterest.objectForKey("myAge") as! String)
            self.apperanceLabel.text = (selectedInterest.objectForKey("myApperance") as! String)

            self.opennessSlider.value = self.returnFloatFromOpenness(selectedInterest.objectForKey("openness") as! String)
            self.ageSlider.value = self.returnFloatFromAge(selectedInterest.objectForKey("myAge") as! String)
            self.heightSlider.value = self.returnFloatFromHeight(selectedInterest.objectForKey("myHeight") as! String)
            self.apperanceSlider.value = self.returnFloatFromApperance(selectedInterest.objectForKey("myApperance") as! String)

            if selectedInterest.objectForKey("myGender") as! String == "Man" {
                self.myGenderControl.selectedSegmentIndex = 1
            }

            if selectedInterest.objectForKey("interestedIn") as! String == "Men" {
                self.interestedInControl.selectedSegmentIndex = 1
            }

        }
    }



    @IBAction func ageSLider(sender: UISlider) {

        let currentValue = Double(sender.value)
        self.ageLevelLabel.text = returnAgeStringBasedOnPassedValue(currentValue)

        if self.ageLevelLabel.text == "No Selection" {
            self.saveButton.enabled = false
        } else {
            self.saveButton.enabled = true
        }
    }


    @IBAction func opennessSlider(sender: UISlider) {

        let currentValue = Double(sender.value)
        self.opennessLevelLabel.text = self.returnOpennessStringBasedOnPassedValue(currentValue)
    }


    @IBAction func appearanceSlider(sender: UISlider) {
        let currentValue = Double(sender.value)
        self.apperanceLabel.text = self.returnAppearanceStringBasedOnPassedValue(currentValue)
    }


    @IBAction func heightSlider(sender: UISlider) {
        let currentValue = Double(sender.value)
        self.heightLabel.text = self.returnHeightStringOnPassedValue(currentValue)
    }



   func saveButtonPressed() {

        var interestToBeSaved = PFObject(className:"Interest")
        var alertToShow = "You have created a new Interest"
        //create Parse Object
        if self.saveButton.title == "Save Changes" {
            //var query = PFQuery(className:"Interest")
            interestToBeSaved = self.selectedInterest

            //interest to be deleted from realm so that it can be readded when the pfquerytableview reloads the objects, I do this for the case that the identifier of an interest changes
            let realm = try! Realm()
            let exstingInterest = realm.objectForPrimaryKey(SavedInterest.self, key: self.selectedInterest.objectForKey("identifier") as! String)
            try! realm.write {
                realm.delete(exstingInterest!)
            }
            alertToShow = "You have modified the parametes of an existing Interest"

        }

        interestToBeSaved["interestType"] = InterestType.Partner.rawValue
        interestToBeSaved["title"] = InterestType.Partner.rawValue
        interestToBeSaved["myGender"] = self.myGenderControl.titleForSegmentAtIndex(self.myGenderControl.selectedSegmentIndex)
        interestToBeSaved["interestedIn"] = self.interestedInControl.titleForSegmentAtIndex(self.interestedInControl.selectedSegmentIndex)

        interestToBeSaved["interestOwner"] = PFUser.currentUser()

        interestToBeSaved["openness"] = self.opennessLevelLabel.text
        interestToBeSaved["myAge"] = self.ageLevelLabel.text
        interestToBeSaved["myHeight"] = self.heightLabel.text
        interestToBeSaved["myApperance"] = self.apperanceLabel.text
        interestToBeSaved["status"] = "Active"

    let identifier = InterestType.Partner.rawValue + " " + self.myGenderControl.titleForSegmentAtIndex(self.myGenderControl.selectedSegmentIndex)! + " " + self.interestedInControl.titleForSegmentAtIndex(self.interestedInControl.selectedSegmentIndex)!
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

    func returnFloatFromHeight(height: String) -> Float {

        var valueToReturn:Float = 0.00

        switch height {
        case "No Selection": valueToReturn = 0
        case "0-160cm": valueToReturn = 1
        case "160-165cm": valueToReturn = 2
        case "165-170cm": valueToReturn = 3
        case "170-175cm": valueToReturn = 4
        case "175-185cm": valueToReturn = 5
        case "185+cm": valueToReturn = 6
        default: break
        }

        return valueToReturn
    }


    func returnFloatFromApperance(apperance: String) -> Float {

        var valueToReturn:Float = 0.00

        switch apperance {
        case "No Selection": valueToReturn = 0
        case "Slim": valueToReturn = 1
        case "Normal": valueToReturn = 2
        case "Muscular": valueToReturn = 3
        case "Heavy": valueToReturn = 4
        default: break
        }

        return valueToReturn
    }

    @IBAction func deleteButtonPressed(sender: AnyObject) {

        //self.deleteInterest(self.retrieveItemWithObjectID(self.selectedInterest.objectId!))
        self.deleteInterest(self.selectedInterest)
    }
}
