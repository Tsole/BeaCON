//
//  AddAbstractInterestTVC.swift
//  BeaCON
//
//  Created by Tsole on 15/11/15.
//  Copyright © 2015 Konstantinos Tsoleridis. All rights reserved.
//

import UIKit
import Parse

class AddAbstractInterestTVC: UITableViewController {

    //passed to segue I am going to
    var comingFrom: String = ""

    var saveButton = UIBarButtonItem()

    var selectedInterest = PFObject(className:"Interest")

    var objectIDFromPassedItem = ""

    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = false
        //self.navigationController?.toolbarHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.saveButton = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.Done , target: self, action: "saveButtonPressed")
        self.navigationItem.rightBarButtonItem = self.saveButton
        self.saveButton.enabled = false

    }


    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }


    func returnOpennessStringBasedOnPassedValue(valuePassed: Double) -> String {

        switch valuePassed {
        case 0..<0.3:
            return Openness.NoEntry.rawValue
        case 0.3..<1.3:
            return Openness.NVO.rawValue
        case 1.3..<2.3:
            return Openness.SO.rawValue
        case 2.3..<3.3:
            return Openness.O.rawValue

        default: break
        }

        return ""
    }


    func returnAgeStringBasedOnPassedValue(valuePassed: Double) -> String {

        switch valuePassed {
        case 0..<0.3:
            return Age.NoEntry.rawValue
        case 0..<1:
            return Age.A.rawValue
        case 1..<2:
            return Age.B.rawValue
        case 2..<3:
            return Age.C.rawValue
        case 3..<4.3:
            return Age.D.rawValue

        default: break
        }

        return ""
    }


    func returnFrequencyStringBasedOnPassedValue(valuePassed: Double) -> String {

        switch valuePassed {
        case 0..<1:
            return Frequency.IWTS.rawValue
        case 1..<2:
            return Frequency.M.rawValue
        case 2..<3:
            return Frequency.W.rawValue

        case 3..<4:
            return Frequency.AD.rawValue

        case 4..<5.3:
            return Frequency.D.rawValue

        default: break
        }

        return ""
    }


    func returnAppearanceStringBasedOnPassedValue(valuePassed: Double) -> String {

        switch valuePassed {
        case 0..<0.3:
            return Apperance.NoEntry.rawValue
        case 0.3..<1.3:
            return Apperance.S.rawValue
        case 1.3..<2.3:
            return Apperance.N.rawValue
        case 2.3..<3.3:
            return Apperance.M.rawValue
        case 3.3..<4.3:
            return Apperance.L.rawValue

        default: break
        }

        return ""
    }


    func returnHeightStringOnPassedValue(valuePassed: Double) -> String {

        switch valuePassed {
        case 0..<0.3:
            return Height.NoEntry.rawValue
        case 0.3..<1.3:
            return Height.A.rawValue
        case 1.3..<2.3:
            return Height.B.rawValue
        case 2.3..<3.3:
            return Height.C.rawValue
        case 3.3..<4.3:
            return Height.D.rawValue
        case 4.3..<5.3:
            return Height.E.rawValue
        case 5.3..<6.3:
            return Height.F.rawValue

        default: break
        }

        return ""
    }

    func deleteInterest (interestToBeDeleted: PFObject) {

        let dimensions = ["user": (PFUser.currentUser()?.username)! as String, "Interest type": interestToBeDeleted.objectForKey("interestType") as! String,"Interest title": interestToBeDeleted.objectForKey("title") as! String]
        PFAnalytics.trackEvent("InterestDeleted", dimensions: dimensions)

        interestToBeDeleted.deleteInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                // The object has been saved.

                let alert = UIAlertController(title: "Alert", message: "You have deleted an Interest", preferredStyle: UIAlertControllerStyle.Alert)
                let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
                    self.navigationController?.popViewControllerAnimated(true)
                })
                alert.addAction(ok)
                self.presentViewController(alert, animated: true, completion: nil)
            } else {
                // There was a problem, check error.description
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }

    func saveInterestWithAlertMessage (interestToSave: PFObject, messageToShow: String) {

        if messageToShow == "You have modified the parametes of an existing Interest" {
            let dimensions = ["user": (PFUser.currentUser()?.username)! as String, "Interest type": interestToSave.objectForKey("interestType") as! String,"Interest title": interestToSave.objectForKey("title") as! String]
            PFAnalytics.trackEvent("InterestModified", dimensions: dimensions)
        } else {
            let dimensions = ["user": (PFUser.currentUser()?.username)! as String, "Interest type": interestToSave.objectForKey("interestType") as! String,"Interest title": interestToSave.objectForKey("title") as! String]
            PFAnalytics.trackEvent("InterestCreated", dimensions: dimensions)
        }

        interestToSave.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                // The object has been saved

                let alert = UIAlertController(title: "Alert", message: messageToShow, preferredStyle: UIAlertControllerStyle.Alert)
                let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in

                    if messageToShow == "You have created a new Interest" {
                        self.dismissViewControllerAnimated(true, completion: nil)
                    } else {

                        self.navigationController?.popViewControllerAnimated(true)
                    }
                })
                alert.addAction(ok)
                self.presentViewController(alert, animated: true, completion: nil)
            } else {
                // There was a problem, check error.description
                self.navigationController?.popViewControllerAnimated(true)
            }
        }
    }


    func returnFloatFromOpenness(openness: String) -> Float {

        var valueToReturn:Float = 0.00

        switch openness {
        case "No Selection": valueToReturn = 0
        case "Not Very Open": valueToReturn = 1
        case "Somewhat Open": valueToReturn = 2
        case "Open": valueToReturn = 3
        default: break
        }

        return valueToReturn
    }

    func returnFloatFromAge(openness: String) -> Float {

        var valueToReturn:Float = 0.00

        switch openness {
        case "No Selection": valueToReturn = 0
        case "18-25": valueToReturn = 1
        case "25-35": valueToReturn = 2
        case "35-45": valueToReturn = 3
        case "45+": valueToReturn = 4

        default: break
        }

        return valueToReturn
    }


    func returnFloatFromFrequency(frequency: String) -> Float {

        var valueToReturn:Float = 0.00

        switch frequency {
        case "No Selection": valueToReturn = 0
        case "I want to start": valueToReturn = 1
        case "Monthly": valueToReturn = 2
        case "Weekly": valueToReturn = 3
        case "Almost Daily": valueToReturn = 4
        case "Daily": valueToReturn = 5
            
        default: break
        }
        
        return valueToReturn
    }
    
    
    func retrieveItemWithObjectID(objectID: String) -> PFObject {
        let query = PFQuery(className:"Interest")
        let selectedInterest = try! query.getObjectWithId(objectID)
        //print(selectedInterest)
        return selectedInterest
    }
    
}
