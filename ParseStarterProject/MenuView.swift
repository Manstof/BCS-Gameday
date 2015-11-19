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

    let MenuViewItems = ["Home", "Team", "Schedule", "Standings", "Events", "VIP"]
    
    var team = String()
    
    var menuSegue = String()
    
    let backgroundColor = UIColor(
        red: 233/255.0,
        green: 150/255.0,
        blue: 122/255.0,
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
    
    //var user = PFUser.currentUser()?.username
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Setbackground Color
        self.tableView.backgroundColor = backgroundColor
    
        //Get team name
        if let teamName = PFUser.currentUser()!["teamName"] as? String {
        
        self.team = teamName
        
        }
    }
    
    //Change cell colors
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        cell.backgroundColor = UIColor.clearColor()
        
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
        
        return cell
    
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let segue = self.MenuViewItems[indexPath.row]
        
        print(segue)
        
        performSegueWithIdentifier(segue, sender: self)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
