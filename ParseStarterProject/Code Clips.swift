//
//  File.swift
//  BCS Gameday
//
//  Created by Mark Manstof on 12/2/15.
//  Copyright © 2015 Manstof. All rights reserved.
//

import Foundation

/*

TODO

-Get activity indicator to spin while loading image from facebook
-Get League and Teams to load properly
-Hide keyboard when switching between views during login stack

*/

/*  Animating username and password fields in

@IBOutlet weak var centerAlignUsername: NSLayoutConstraint!

@IBOutlet weak var centerAlignPassword: NSLayoutConstraint!

override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    centerAlignUsername.constant -= view.bounds.width
    
    centerAlignPassword.constant -= view.bounds.width
    
}

override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    UIView.animateWithDuration(0.5, delay: 0.0, options:UIViewAnimationOptions.CurveEaseIn, animations: {
        
        self.centerAlignUsername.constant += self.view.bounds.width
        
        self.view.layoutIfNeeded()
        
        }, completion: nil)
    
    UIView.animateWithDuration(0.5, delay: 0.3, options: .CurveEaseIn, animations: {
        
        self.centerAlignPassword.constant += self.view.bounds.width
        
        self.view.layoutIfNeeded()
        
        }, completion: nil)
}
*/





/*
//XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
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

//XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
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
//XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
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

//if imageSet == true

}

func textFieldShouldBeginEditing(textField: UITextField) -> Bool {

teamPicker.hidden = false

return false

}

//XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
//Save Team Name and Number
let teamName = userTeam

PFUser.currentUser()?["teamName"] = teamName

let teamNumber = userTeamNumber

PFUser.currentUser()?["teamNumber"] = teamNumber

//Save all data
PFUser.currentUser()?.save()
*/
