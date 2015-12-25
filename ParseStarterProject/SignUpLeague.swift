//
//  SignUpLeague.swift
//  BCS Gameday
//
//  Created by Mark Manstof on 12/2/15.
//  Copyright © 2015 Manstof. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class SignUpLeague: PFQueryTableViewController {
    
    var activityIndicator = UIActivityIndicatorView()
    
    var leagueName = [String]()

    var leagueNumber = [String]()
    
    var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let Update = leagues()
        
        Update.leagues()
        
        //Configure Colors for Table
        tableView.backgroundColor = UIColor.orangeColor()
        
        tableView.tableFooterView = UIView(frame:CGRectZero)
        
        tableView.separatorColor = UIColor.whiteColor()
        
    }
    
    override func queryForTable() -> PFQuery {
        
        let query = PFQuery(className: "Leagues")
        
        query.orderByAscending("League")
        
        return query
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! SignUpLeagueCell
        
        cell.titleLabel.text = object?.objectForKey("League") as? String
        
        cell.textLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
   
        cell.textLabel?.numberOfLines = 0
        
        //Configure Cell Colors
        cell.backgroundColor = UIColor.orangeColor()
        
        cell.textLabel?.textColor = UIColor.whiteColor()
        
        //Save
        leagueName.append(cell.titleLabel.text!)
        
        leagueNumber.append(object?.objectForKey("LeagueNumber") as! String)
        
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
        
        PFUser.currentUser()?["league"] = leagueName[indexPath.row]
        
        PFUser.currentUser()?["leagueNumber"] = leagueNumber[indexPath.row]
        
        //Save all data
        PFUser.currentUser()?.save()

        //Kill spinner
        self.activityIndicator.stopAnimating()
        
        UIApplication.sharedApplication().endIgnoringInteractionEvents()
        
        performSegueWithIdentifier("leagueToTeam", sender: self)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
