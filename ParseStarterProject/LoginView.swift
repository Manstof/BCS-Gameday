//
//  ViewController.swift
//
//  Copyright 2011-present Parse Inc. All rights reserved.
//

import UIKit
import Parse
import FBSDKCoreKit

class LoginView: UIViewController, UITextFieldDelegate {

    @IBOutlet var username: UITextField!
    
    @IBOutlet var password: UITextField!
    
    @IBOutlet var signupButton: UIButton!
    
    @IBOutlet var forgotPasswordButton: UIButton!
    
    @IBOutlet var loginButton: UIButton!
    
    @IBOutlet var facebookF: UIButton!
    
    @IBOutlet var loginFacebook: UIButton!
    
    var imageSet = false
    
    var signupActive = true
    
    var keyboardShowing = false
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    //Configure Colors and Things
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
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        })))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

    
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        /*
        //Logout User Code
        PFUser.logOutInBackgroundWithBlock() {
            
            (error: NSError?) -> Void in
            
            if error != nil {
                
                print("logout fail")
                
                print(error)
                
            } else {
                
                print("logout success")
                
        print(PFUser.currentUser())
        
            }
        }
        
        //Skip if use is logged in ***************************CURRENTLY NOT WORKING
        if PFUser.currentUser() != nil {
            
            self.performSegueWithIdentifier("showMasterView", sender: self)
        
        }*/
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //keyboard Things
        
        username.delegate=self
        
        password.delegate=self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
    
        //Configure Pretty Things
        //Set Background Color
        self.view.backgroundColor = orangeColor

        //Border Width
        username.layer.borderWidth = 1
        
        password.layer.borderWidth = 1
        
        loginButton.layer.borderWidth = 1
        
        forgotPasswordButton.layer.borderWidth = 1
        
        signupButton.layer.borderWidth = 1
        
        //facebookF.layer.borderWidth = 1/2
        
        //loginFacebook.layer.borderWidth = 1/2
        
        //Border Color
        username.layer.borderColor = orangeColor.CGColor
        
        password.layer.borderColor = orangeColor.CGColor
        
        loginButton.layer.borderColor = orangeColor.CGColor
        
        forgotPasswordButton.layer.borderColor = UIColor.whiteColor().CGColor
        
        signupButton.layer.borderColor = UIColor.whiteColor().CGColor
        
        //facebookF.layer.borderColor = UIColor.whiteColor().CGColor
        
        //loginFacebook.layer.borderColor = UIColor.whiteColor().CGColor
        
    }
    
    //************************
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
        
        username.resignFirstResponder()
        
        password.resignFirstResponder()
        
        return true;
    }
    
    //************************
    //Start Signup and Sign in
    @IBAction func loginButton(sender: AnyObject) {
        
        if username.text == "" || password.text == "" {
            
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
                user.username = username.text
                user.password = password.text
                
                user.signUpInBackgroundWithBlock({ (success, error) -> Void in
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    
                    if error == nil {
                        
                        self.performSegueWithIdentifier("showSigninScreen", sender: self)
                        
                    } else {
                        
                        if let errorString = error!.userInfo["error"] as? String {
                            
                            errorMessage = errorString
                            
                        }
                        
                        self.displayAlert("Failed SignUp", message: errorMessage)
                        
                    }
                })
                
            } else {
                
                PFUser.logInWithUsernameInBackground(username.text!, password: password.text!, block: { (user, error) -> Void in
                    
                    self.activityIndicator.stopAnimating()
                    
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    
                    if user != nil {
                        
                        // Logged In!
                        
                        self.performSegueWithIdentifier("loginToReveal", sender: self)
                        
                        
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
    
    @IBAction func signupButton(sender: AnyObject) {
    
        self.performSegueWithIdentifier("showSigninScreen", sender: self)
        
    }
    
    //**************************
    //Login with facebook button
    @IBAction func FBSignIn(sender: AnyObject) {
        
        let permissions = ["public_profile"]
        
        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions) {
            
            (user: PFUser?, error: NSError?) -> Void in
            
            if let error = error {
                
                print(error)
                
            } else {
                
                //********************Need to come up with something if user already has signed in
                //if they have a username
                
                if let user = user {
                    
                    //****************************
                    //Get facebook profile picture
                    if let username = PFUser.currentUser()?.username {
                        
                        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name"])
                        
                        graphRequest.startWithCompletionHandler( {
                            
                            (connection, result, error) -> Void in
                            
                            if error != nil {
                                
                                print(error)
                                
                            } else if let result = result {
                                
                                PFUser.currentUser()?["name"] = result["name"]
                                
                                //Get profile picture
                                
                                PFUser.currentUser()?.save()
                                
                                let userId = result["id"] as! String
                                
                                let facebookProfilePictureUrl = "https://graph.facebook.com/" + userId + "/picture?type=large"
                                
                                if let fbpicUrl = NSURL(string: facebookProfilePictureUrl) {
                                    
                                    if let data = NSData(contentsOfURL: fbpicUrl) {
                                        
                                        //Save Image
                                        let imageFile:PFFile = PFFile(data: data)
                                        
                                        PFUser.currentUser()?["image"] = imageFile
                                        
                                        PFUser.currentUser()?.save()
                                        
                                        self.imageSet = true
                                    }
                                }
                            }
                        })
                    
                    self.performSegueWithIdentifier("showSigninScreen", sender: self)
                    
                    }
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
