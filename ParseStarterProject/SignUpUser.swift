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
    
    @IBOutlet var toLeague: UIButton!
    
    @IBOutlet var toLogin: UIButton!
    
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
        
        //Looks for single or multiple taps to dismiss keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        //Configure Pretty Things
        //Set Background Color
        self.view.backgroundColor = orangeColor
        
        //Border Width
        usernameField.layer.borderWidth = 1
        
        passwordField.layer.borderWidth = 1
        
        emailField.layer.borderWidth = 1
        
        toLogin.layer.borderWidth = 1
        
        toLeague.layer.borderWidth = 1
        
        //Border Color
        usernameField.layer.borderColor = UIColor.whiteColor().CGColor
        
        passwordField.layer.borderColor = UIColor.whiteColor().CGColor
        
        emailField.layer.borderColor = UIColor.whiteColor().CGColor
        
        toLogin.layer.borderColor = UIColor.whiteColor().CGColor
        
        toLeague.layer.borderColor = UIColor.whiteColor().CGColor
        
        //Placeholder Text Color
        usernameField.attributedPlaceholder = NSAttributedString(string:"Create Username", attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        
        passwordField.attributedPlaceholder = NSAttributedString(string:"Create Password", attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        
        emailField.attributedPlaceholder = NSAttributedString(string:"Enter email", attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        
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
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
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
    
    @IBAction func backToLogin(sender: AnyObject) {
        
        //Move to next screen
        self.performSegueWithIdentifier("backToLogin", sender: self)
        
    }
    
    @IBAction func continueToLeague(sender: AnyObject) {
        
        if keyboardShowing == false {
        
            self.view.frame.origin.y = 0
            
        }
        
        var username = usernameField.text?.lowercaseString
        
        var password = passwordField.text
        
        var email = emailField.text
        
        //Check if fields have content
        if imageSet == false {
            
            self.displayAlert("Failed Signup", message: "Please choose a picture")
            
        } else if username == "" {
                
            self.displayAlert("Failed Signup", message: "Please create a username")
            
        } else if password == "" {
            
            self.displayAlert("Failed Signup", message: "Please create a password")
        
        } else if email == "" {
        
            self.displayAlert("Failed Signup", message: "Please enter an email")
            
        //Validate Fields
            
        } else if username?.characters.count < 5 {
            
            self.displayAlert("Failed Signup", message: "Username must be greater than 5 characters")
            
        } else if password?.characters.count < 8 {
            
            self.displayAlert("Failed Signup", message: "Password must be greater than 8 characters")
            
        } else if email?.characters.count < 8 {

            self.displayAlert("Failed Signup", message: "Password must be greater than 8 characters")
            
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
        
            //*************************
            //Save Information to Parse
            let newUser = PFUser()
            
            newUser.username = username
            
            newUser.password = password
            
            newUser.email = email
            
            //*****************************
            //Save chosen image for profile
            let imageData = UIImageJPEGRepresentation(userImage.image!, 0.0)
            
            let imageFile:PFFile = PFFile(name: "image.png", data: imageData!)
            
            PFUser.currentUser()?["image"] = imageFile
            
            //*****************************
            //Sign up the user asynchronously
            newUser.signUpInBackgroundWithBlock({ (succeed, error) -> Void in

                //Kill spinner
                self.activityIndicator.stopAnimating()
                
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                
                //Start parse things
                if ((error) != nil) {
                    
                    self.displayAlert("Error", message: "\(error)")
                    
                } else {
                    
                    let alert = UIAlertView(title: "Success", message: "Signed Up", delegate: self, cancelButtonTitle: "OK")
                    
                    alert.show()
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        //Move to next screen
                        self.performSegueWithIdentifier("toLeague", sender: self)
                        
                    })
                }
            })
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
