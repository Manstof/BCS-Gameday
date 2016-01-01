//
//  ViewController.swift
//
//  Copyright 2011-present Parse Inc. All rights reserved.
//

import UIKit
import Parse
import FBSDKCoreKit

class LoginView: UIViewController, UITextFieldDelegate {

    @IBOutlet var usernameField: UITextField!
    
    @IBOutlet var passwordField: UITextField!
    
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
        

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Keyboard Things
        usernameField.delegate = self
        
        passwordField.delegate = self
        
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
        
        loginButton.layer.borderWidth = 1
        
        forgotPasswordButton.layer.borderWidth = 1
        
        signupButton.layer.borderWidth = 1
        
        //Border Color
        usernameField.layer.borderColor = UIColor.whiteColor().CGColor
        
        passwordField.layer.borderColor = UIColor.whiteColor().CGColor
        
        loginButton.layer.borderColor = UIColor.whiteColor().CGColor
        
        forgotPasswordButton.layer.borderColor = UIColor.whiteColor().CGColor
        
        signupButton.layer.borderColor = UIColor.whiteColor().CGColor
        
        //Placeholder Text Color
        usernameField.attributedPlaceholder = NSAttributedString(string:"Username", attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        
        passwordField.attributedPlaceholder = NSAttributedString(string:"Password", attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        
    }
    
    //********************
    //Moar Keyboard Things
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
        
        return true;
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    //************************
    //Start Signup and Sign in
    @IBAction func loginButton(sender: AnyObject) {
        
        var username = usernameField.text?.lowercaseString
        
        var password = passwordField.text
        
        if username == "" || password == "" {
            
            displayAlert("Error in form", message: "Please enter a username and password")
            
        } else if username?.characters.count < 5 {
            
            self.displayAlert("Failed Signup", message: "Username must be greater than 5 characters")
            
        } else if password?.characters.count < 8 {
            
            self.displayAlert("Failed Signup", message: "Password must be greater than 8 characters")
            
        } else {
            
            activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
            
            activityIndicator.center = self.view.center
            
            activityIndicator.hidesWhenStopped = true
            
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            
            view.addSubview(activityIndicator)
            
            activityIndicator.startAnimating()
            
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            // Send a request to login
            PFUser.logInWithUsernameInBackground(username!, password: password!, block: { (user, error) -> Void in
                
                //Kill spinner
                self.activityIndicator.stopAnimating()
                
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                
                if ((user) != nil) {
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("HomeView")
                        
                        self.presentViewController(viewController, animated: true, completion: nil)
                    })
                    
                } else {
                    
                    self.displayAlert("Failed Signup", message: "\(error)")

                }
            })
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
