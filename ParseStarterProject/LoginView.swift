//
//  ViewController.swift
//
//  Copyright 2011-present Parse Inc. All rights reserved.
//

import UIKit
import Parse
import FBSDKCoreKit

class LoginView: UIViewController {
    
    //View Controller Things

    @IBOutlet var username: UITextField!
    
    @IBOutlet var password: UITextField!
    
    @IBOutlet var signupButton: UIButton!
    
    @IBOutlet var registeredText: UILabel!
    
    @IBOutlet var loginButton: UIButton!
    
    var imageSet = false
    
    var signupActive = true
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    let backgroundColor = UIColor(
        red: 233/255.0,
        green: 150/255.0,
        blue: 122/255.0,
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
    
    //******************************
    //Skip view if already logged in
    override func viewDidAppear(animated: Bool) {
        
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
        
        //Setbackground Color
        self.view.backgroundColor = backgroundColor
        
    }
    
    //************************
    //Start Signup and Sign in
    //Sign Up Button
    @IBAction func signUpButton(sender: AnyObject) {
        
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
                        
                        // Signup successful
                        
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
                        
                        self.performSegueWithIdentifier("LoginToReveal", sender: self)
                        
                        
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
    
    @IBAction func logInButton(sender: AnyObject) {
    
        if signupActive == true {
            
            signupButton.setTitle("Log In", forState: UIControlState.Normal)
            
            registeredText.text = "Not registered?"
            
            loginButton.setTitle("Sign Up", forState: UIControlState.Normal)
            
            signupActive = false
            
        } else {
            
            signupButton.setTitle("Sign Up", forState: UIControlState.Normal)
            
            registeredText.text = "Already registered?"
            
            loginButton.setTitle("Login", forState: UIControlState.Normal)
            
            signupActive = true
            
        }
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
