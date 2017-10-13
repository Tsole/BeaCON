//
//  SettingsVC.swift
//  BeaCON
//
//  Created by Tsole on 23/11/15.
//  Copyright © 2015 Konstantinos Tsoleridis. All rights reserved.
//

import UIKit
import Parse
import MessageUI
import RealmSwift

class SettingsVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MFMessageComposeViewControllerDelegate {

    @IBOutlet var userImage: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var myPhoneNumber: UILabel!
    @IBOutlet var placeHolderSpinner: UIActivityIndicatorView!

    //@IBOutlet var myPhoneNumber: UITextField!

    @IBAction func logOutButtonPressed(sender: AnyObject) {

        PFUser.logOut()
        self.performSegueWithIdentifier("logout", sender: self)
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }

    @IBAction func changeImageButtonPressed(sender: AnyObject) {

        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = true
        self.presentViewController(image, animated: true, completion: nil)

    }

    @IBAction func takeNewImageButtonPressed(sender: AnyObject) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.Camera
        image.allowsEditing = true
        self.presentViewController(image, animated: true, completion: nil)

    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.placeHolderSpinner.startAnimating()
        self.dismissViewControllerAnimated(true, completion: nil)
        self.userImage.image = image

        //store userImage in parse
        let imageData = UIImageJPEGRepresentation(self.userImage.image!, 0.2)
        let imageFile = PFFile(name: "userImage.jpg", data: imageData!)
        //user["userImage"] = imageFile
        PFUser.currentUser()?["userImage"] = imageFile
        PFUser.currentUser()?.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                // The object has been saved
                self.placeHolderSpinner.stopAnimating()
            } else {
                // There was a problem, check error.description

            }
        }

    }

    @IBAction func conactMe(sender: AnyObject) {

        let messageVC = MFMessageComposeViewController()

        messageVC.body = "Enter a message";
        //messageVC.recipients = ["01723923662"]
        messageVC.recipients = [PFUser.currentUser()!["phoneNumber"] as! String]
        messageVC.messageComposeDelegate = self;

        self.presentViewController(messageVC, animated: false, completion: nil)

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



    override func viewDidLoad() {
        self.userNameLabel.text = "User Name: " + (PFUser.currentUser()?.username)!
        self.myPhoneNumber.text = (PFUser.currentUser()!["phoneNumber"] as! String)

        if self.myPhoneNumber.text == "" {
           // self.myPhoneNumber.text = "No phone number entered"
        }

        self.placeHolderSpinner.startAnimating()

        /*let userImage = PFUser.currentUser()?.objectForKey("userImage") as! UIImage
        self.userImage.image = userImage*/

        /*if PFUser.currentUser()?.objectForKey("userImage") == nil {
        self.placeHolderSpinner.stopAnimating()
        }*/


    }

    override func viewWillAppear(animated: Bool) {
        if let userImageFile = PFUser.currentUser()?["userImage"] as? PFFile {
            userImageFile.getDataInBackgroundWithBlock {
                (imageData: NSData?, error: NSError?) -> Void in
                if error == nil {
                    if let imageData = imageData {
                        let image = UIImage(data:imageData)
                        self.userImage.image = image
                        self.placeHolderSpinner.stopAnimating()
                    }
                }
            }
        }
    }
}
