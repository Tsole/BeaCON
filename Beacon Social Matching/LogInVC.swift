//
//  LogInVC.swift
//  BeaCON
//
//  Created by Tsole on 10/11/15.
//  Copyright © 2015 Konstantinos Tsoleridis. All rights reserved.
//

import UIKit
import Parse
import Bolts

class LogInVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var userNameField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var phoneNumberField: UITextField!
    

    @IBOutlet var registeredText: UILabel!

    @IBOutlet var signupButton: UIButton!
    @IBOutlet var loginButton: UIButton!

    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var signupActive = true

    var minorToBeAssigned: Int = 0


    @IBOutlet var userImage: UIImageView!
    @IBOutlet var chooseImageButton: UIButton!
    @IBOutlet var takeImageButton: UIButton!

    func displayAlert(title: String, message: String) {

        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction((UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in

            //self.dismissViewControllerAnimated(true, completion: nil)
            self.navigationController?.popToRootViewControllerAnimated(true)

        })))

        self.presentViewController(alert, animated: true, completion: nil)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let testObject = PFObject(className: "TestObject")
        testObject["foo"] = "bar"

    }

    override func viewDidAppear(animated: Bool) {
        if (PFUser.currentUser() != nil) {
            self.performSegueWithIdentifier("login", sender: self)
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func signUp(sender: AnyObject) {

        if userNameField.text == "" || passwordField.text == "" {

            displayAlert("Error in form", message: "Please enter a username and password")

        } else {

            activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()

            var errorMessage = "Please try again later"

            if signupActive == true {

                let user = PFUser()
                user.username = userNameField.text
                user.password = passwordField.text

                //let minor = 0
                // other fields can be set just like with PFObject
                print("Minor to be assigned: ",self.minorToBeAssigned)
                let minorForNewUser = self.minorToBeAssigned
                user["minor"] = minorForNewUser
                user["phoneNumber"] = self.phoneNumberField.text


                //store userImage in parse
                let imageData = UIImageJPEGRepresentation(self.userImage.image!, 0.2)
                let imageFile = PFFile(name: "userImage.jpg", data: imageData!)
                user["userImage"] = imageFile

                user.signUpInBackgroundWithBlock({ (success, error) -> Void in

                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()

                    if error == nil {
                        // Signup successful
                        self.performSegueWithIdentifier("login", sender: self)

                    } else {
                        if let errorString = error!.userInfo["error"] as? String {
                            errorMessage = errorString
                        }
                        self.displayAlert("Failed SignUp", message: errorMessage)
                    }
                })

            } else {

                PFUser.logInWithUsernameInBackground(userNameField.text!, password: passwordField.text!, block: { (user, error) -> Void in
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()

                    if user != nil {
                        // Logged In!
                        self.fetchAllObjects()
                        self.performSegueWithIdentifier("login", sender: self)

                    } else {
                        if let errorString = error!.userInfo["error"] as? String {
                            errorMessage = errorString
                        }
                        self.displayAlert("Failed Login", message: errorMessage)
                    }
                })
            }
        }
    }



    @IBAction func logIn(sender: AnyObject) {

        if signupActive == true {
            signupButton.setTitle("Log In", forState: UIControlState.Normal)
            registeredText.text = "Not registered?"
            loginButton.setTitle("Sign Up", forState: UIControlState.Normal)
            signupActive = false
            self.takeImageButton.hidden = true
            self.chooseImageButton.hidden = true
            self.userImage.hidden = true

        } else {
            signupButton.setTitle("Sign Up", forState: UIControlState.Normal)
            registeredText.text = "Already registered?"
            loginButton.setTitle("Login", forState: UIControlState.Normal)
            signupActive = true

            self.takeImageButton.hidden = false
            self.chooseImageButton.hidden = false
            self.userImage.image = UIImage(named: "placeholderImage")
            self.userImage.hidden = false

        }
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }


    func returnAUniqueMinor() {
        var lastUsedMinor = 0

        let query = PFUser.query()
        query?.orderByDescending("createdAt")

        query!.getFirstObjectInBackgroundWithBlock{ (object: PFObject?, error: NSError?) -> Void in

            if error == nil {
                // The find succeeded.
                lastUsedMinor = object!.objectForKey("minor") as! Int
                //print("Last assigned Minor: ", lastUsedMinor)
                self.minorToBeAssigned = lastUsedMinor + 1
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
        
        //print(self.minorToBeAssigned)
    }

    func fetchAllObjects() {

        //PFObject.unpinAllObjectsInBackgroundWithBlock(nil)

        let query: PFQuery = PFQuery(className: "Interest")

        query.whereKey("interestOwner", equalTo: PFUser.currentUser()!)

        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in

            if error == nil {
                // The find succeeded.
                // Do something with the found objects
                if let objects = objects as [PFObject]! {
                    for object in objects {
                        object.pinInBackground()
                    }
                }
                NSNotificationCenter.defaultCenter().postNotificationName("Reload Start Searching TableView", object: self)
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }   
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.returnAUniqueMinor()
    }


    @IBAction func chooseAnImage(sender: AnyObject) {

        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = true
        self.presentViewController(image, animated: true, completion: nil)

    }


    @IBAction func takeImage(sender: AnyObject) {

        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.Camera
        image.allowsEditing = true
        self.presentViewController(image, animated: true, completion: nil)

    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.dismissViewControllerAnimated(true, completion: nil)
        userImage.image = image
    }

}
