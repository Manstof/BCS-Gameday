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

class SignUpView: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var teamPicker: UIPickerView! = UIPickerView()
    
    @IBOutlet var teamPickerText: UITextField!
    
    @IBOutlet var userImage: UIImageView!
    
    var imageSet = false
    
    var activityIndicator = UIActivityIndicatorView()
    
    var teamArray = [String]()
    
    var userTeam = String()
    
    var userTeamNumber = String()
    
    //******
    //Alerts
    func displayAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction((UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            
            //self.dismissViewControllerAnimated(true, completion: nil)
            
        })))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
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
        
        userImage.image = image
        
        self.imageSet = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                        
                            self.userImage.image = UIImage(data: data)
                        
                            let imageFile:PFFile = PFFile(data: data)
                        
                            PFUser.currentUser()?["image"] = imageFile
                        
                            PFUser.currentUser()?.save()
                            
                            self.imageSet = true
                        }
                    }
                }
            })
        }
        
        //**********************
        //Get data for UI Picker
        // Connect data:

        teamPicker.hidden = true
        
        let query = PFQuery(className: "Team")
        
        query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            
            if error == nil {
                
                for object in objects! {
                    
                    let team = object["Teams"] as! String
                    
                    self.teamArray.append(team)
                    
                    self.teamPicker.reloadAllComponents()
                }
                
            } else {
                
                // Log details of the failure
                print(error)
                
            }
        })
        
    }
    
    //**************
    //Setup UIPicker
    // The number of columns of data
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        
        return 1
    
    }
    
    // The number of rows of data
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return teamArray.count

    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return teamArray[row]
    
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        //********************
        //Playing with Strings
        let teamString = teamArray[row]
        
        //Get Team Name
        let teamNameString = teamString.substringWithRange(Range<String.Index>(start: teamString.startIndex.advancedBy(9), end: teamString.endIndex.advancedBy(0)))
        
        //Get Team Number
        let teamNumberString = teamString.substringWithRange(Range<String.Index>(start: teamString.startIndex.advancedBy(0), end: teamString.startIndex.advancedBy(6)))        
        self.userTeamNumber = teamNumberString
        
        //Display in Picker
        teamPickerText.text = teamNameString
        self.userTeam = teamNameString
        self.view.endEditing(true)
        
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        teamPicker.hidden = false
    
        return false
    
    }
    
    @IBAction func signUp(sender: AnyObject) {
        
        //WHY DOES  THIS  MAKE  IT  JUMP  TO  THE  LOGIN  SCREEN
        if userTeam.isEmpty {
            
            self.displayAlert("Failed Signup", message: "Please select a team")
            
        } else if imageSet == false {
            
            self.displayAlert("Failed Signup", message: "Please choose a picture")
        
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
            //Save Team Name and Number
            let teamName = userTeam
            PFUser.currentUser()?["teamName"] = teamName
        
            let teamNumber = userTeamNumber
            PFUser.currentUser()?["teamNumber"] = teamNumber
            
            //Save all data
            PFUser.currentUser()?.save()
        
            //Kill spinner
            self.activityIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
            //Move to next screen
            performSegueWithIdentifier("GO", sender: self)
        
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
