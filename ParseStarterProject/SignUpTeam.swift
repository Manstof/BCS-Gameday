//
//  SignUpTeam.swift
//  BCS Gameday
//
//  Created by Mark Manstof on 12/2/15.
//  Copyright © 2015 Manstof. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class SignUpTeam: PFQueryTableViewController {

    var activityIndicator = UIActivityIndicatorView()
    
    var teamName = String()
    
    var teamNumber = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewWillAppear(animated: Bool) {

        super.viewWillAppear(true)
        
        let Update = Teams()
        
        Update.Teams()
        
    }
    
    override func queryForTable() -> PFQuery {
        

        
        let query = PFQuery(className: "Teams")
        
        query.orderByAscending("Team")
        
        return query
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! SignUpTeamCell
        
        cell.titleLabel.text = object?.objectForKey("Team") as? String
        
        teamName = cell.titleLabel.text!
        
        teamNumber = object?.objectForKey("TeamNumber") as! String
        
        return cell
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
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
        
        //Save League
        PFUser.currentUser()?["team"] = teamName
        
        PFUser.currentUser()?["teamNumber"] = teamNumber
        
        //Save all data
        PFUser.currentUser()?.save()
        
        //Kill spinner
        self.activityIndicator.stopAnimating()
        
        UIApplication.sharedApplication().endIgnoringInteractionEvents()
        
        performSegueWithIdentifier("teamToMenu", sender: self)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
