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
    
    var leagueName = String()

    var leagueNumber = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let Update = leagues()
        
        Update.leagues()
        
    }
    
    override func queryForTable() -> PFQuery {
        
        let query = PFQuery(className: "Leagues")
        
        query.orderByAscending("League")
        
        print(query)
        
        return query
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! SignUpLeagueCell
        
        cell.titleLabel.text = object?.objectForKey("League") as? String
        
        leagueName = cell.titleLabel.text!
        
        leagueNumber = object?.objectForKey("LeagueNumber") as! String

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
        
        //HERE WE GO
        //Save League
        PFUser.currentUser()?["league"] = leagueName
        
        PFUser.currentUser()?["leagueNumber"] = leagueNumber
        
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
