//
//  SignUpViewController.swift
//  BCS Gameday
//
//  Created by Mark Manstof on 7/28/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse

var findTeam = Teams()

class SignUpUser: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet var userImage: UIImageView!

    @IBOutlet var usernameField: UITextField!
    
    @IBOutlet var passwordField: UITextField!
    
    @IBOutlet var emailField: UITextField!
    
    var imageSet = false
    
    var keyboardShowing = false
    
    var activityIndicator = UIActivityIndicatorView()
    
    //********************
    //Set background color
    let orangeColor = UIColor(
        red: 255/255.0,
        green: 153/255.0,
        blue: 0/255.0,
        alpha: 1.0)
    
    let lightBlueColor = UIColor(
        red: 51/255.0,
        green: 153/255.0,
        blue: 255/255.0,
        alpha: 1.0)
    
    //**************
    //Display Alerts
    func displayAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction((UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            
            //self.dismissViewControllerAnimated(true, completion: nil)
            
        })))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //Animation for user image
        self.userImage.frame = CGRectMake(0, 0, 0, 0)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //*********************
        //Set image from facebook
        if let userPicture = PFUser.currentUser()?["image"] as? PFFile {
            
            userPicture.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                
                if (error == nil) {
                    
                    //Round Image
                    self.userImage.layer.borderWidth = 1
                    self.userImage.layer.masksToBounds = false
                    self.userImage.layer.borderColor = UIColor.whiteColor().CGColor
                    self.userImage.layer.cornerRadius = self.userImage.frame.height/2
                    self.userImage.clipsToBounds = true
                    self.imageSet = true
                    self.userImage.image = UIImage(data:imageData!)
                    
                    //Animate Image
                    UIView.animateWithDuration(0.6, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                        
                        
                        self.userImage.frame = CGRectMake(50, 50, 150, 150)
                        
                        self.userImage.alpha = 1
                        
                        }, completion: nil
                    )
                }
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Keyboard Things
        usernameField.delegate = self
        
        passwordField.delegate = self
        
        emailField.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        
        //Configure Pretty Things
        //Set Background Color
        self.view.backgroundColor = orangeColor
        
        //Border Width
        usernameField.layer.borderWidth = 1
        
        passwordField.layer.borderWidth = 1
        
        emailField.layer.borderWidth = 1
        
        //Border Color
        usernameField.layer.borderColor = orangeColor.CGColor
        
        passwordField.layer.borderColor = orangeColor.CGColor
        
        emailField.layer.borderColor = orangeColor.CGColor
        
    }
    
    //***************
    //Keyboard Things
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            
            if keyboardShowing != true {
                
                self.view.frame.origin.y -= keyboardSize.height
                
                keyboardShowing = true
                
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        keyboardShowing = false
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            
            self.view.frame.origin.y += keyboardSize.height
            
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        usernameField.resignFirstResponder()
        
        passwordField.resignFirstResponder()
        
        emailField.resignFirstResponder()
        
        return true;
    }
    
    //*********************
    //Setup Profile Picture
    @IBAction func chooseImage(sender: AnyObject) {
        
        let image = UIImagePickerController()
        
        image.delegate = self
        
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        image.allowsEditing = false
        
        self.presentViewController(image, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        self.dismissViewControllerAnimated(true, completion:nil)
        
        //Round Image
        userImage.layer.borderWidth = 1
        
        userImage.layer.masksToBounds = false
        
        userImage.layer.borderColor = UIColor.whiteColor().CGColor
        
        userImage.layer.cornerRadius = userImage.frame.height/2
        
        userImage.clipsToBounds = true
        
        userImage.image = image
        
        self.imageSet = true
        
        //Animate Image
        UIView.animateWithDuration(0.6, delay: 0.1, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            
            self.userImage.frame = CGRectMake(50, 50, 150, 150)
            
            }, completion: nil
        )
        
    }
    
    @IBAction func continueToLeague(sender: AnyObject) {
            
        if imageSet == false {
            
            self.displayAlert("Failed Signup", message: "Please choose a picture")
            
        } else if usernameField.text == "" {
                
            self.displayAlert("Failed Signup", message: "Please create a username")
            
        } else if passwordField.text == "" {
            
            self.displayAlert("Failed Signup", message: "Please create a password")
            
            if ((passwordField.text?.containsString(" ")) != nil) {
                
                self.displayAlert("Failed Signup", message: "Password cannot contain a space")
                
            }
        
        } else if emailField.text == "" {
        
            self.displayAlert("Failed Signup", message: "Please enter an email")
            
        } else {
        
            //***************************
            //Spin the activity indicator
            activityIndicator = UIActivityIndicatorView(frame: self.view.frame)
            
            activityIndicator.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
            
            activityIndicator.center = self.view.center
            
            activityIndicator.hidesWhenStopped = true
            
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            
            view.addSubview(activityIndicator)
            
            activityIndicator.startAnimating()
            
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()

            //*****************************
            //Save chosen image for profile
            let imageData = UIImageJPEGRepresentation(userImage.image!, 0.0)
            
            let imageFile:PFFile = PFFile(name: "image.png", data: imageData!)
            
            PFUser.currentUser()?["image"] = imageFile
        
            //*************************
            //Save Information to Parse
            let username = usernameField.text
            
            let password = passwordField.text
            
            let email = emailField.text
            
            PFUser.currentUser()?["username"] = username
            
            PFUser.currentUser()?["password"] = password
            
            PFUser.currentUser()?["email"] = email
            
            //Save all data
            PFUser.currentUser()?.save()
        
            //Kill spinner
            self.activityIndicator.stopAnimating()
            
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
            //Move to next screen
            performSegueWithIdentifier("toLeague", sender: self)
        
            }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
