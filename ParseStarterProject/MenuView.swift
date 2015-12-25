//
//  MenuView.swift
//  BCS Gameday
//
//  Created by Mark Manstof on 11/17/15.
//  Copyright © 2015 Manstof. All rights reserved.
//

import UIKit
import Parse

class MenuView: UITableViewController {

    let MenuViewItems = ["Home", "Team", "Schedule", "Standings", "Events", "VIP", "Change Team", "Logout"]
    
    var team = String()
    
    var menuSegue = String()
    
    let lightBlueColor = UIColor(
        red: 51/255.0,
        green: 153/255.0,
        blue: 255/255.0,
        alpha: 1.0)
    
    let backgroundColorAlt = UIColor(
        red: 223/255.0,
        green: 170/255.0,
        blue: 142/255.0,
        alpha: 1.0)
    
    let textColor = UIColor(
        red: 248/255.0,
        green: 248/255.0,
        blue: 255/255.0,
        alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Setbackground Color
        self.tableView.backgroundColor = lightBlueColor
        
        tableView.tableFooterView = UIView(frame:CGRectZero)
        
        tableView.separatorColor = UIColor.whiteColor()
    
        //Get team name
        if let teamName = PFUser.currentUser()!["teamName"] as? String {
        
        self.team = teamName
        
        }
    }
    
    //Change cell colors
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        cell.backgroundColor = UIColor.clearColor()
        
        //Alternating colors
        /*if indexPath.row % 2 == 0 {
            
            cell.backgroundColor = backgroundColorAlt
            
        }*/
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        //return "Section"
        
        return self.team
        
        //return user
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return MenuViewItems.count
    
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        //Text Color
        cell.textLabel?.textColor = textColor
        
        cell.textLabel?.font = UIFont(name:"HelveticaNeue-Bold", size: 16.0)
        
        //Text
        cell.textLabel?.text = MenuViewItems[indexPath.row]
        
        //cell.imageView?.image = UIImage(named: MenuViewItems[indexPath.row])
            
        return cell
    
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let segue = self.MenuViewItems[indexPath.row]
        
        performSegueWithIdentifier(segue, sender: self)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
