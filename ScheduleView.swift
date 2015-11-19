//
//  ScheduleView.swift
//  BCS Gameday
//
//  Created by Mark Manstof on 11/18/15.
//  Copyright © 2015 Manstof. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class ScheduleView: PFQueryTableViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        //Control Menu Bar
        if self.revealViewController() != nil {
    
        menuButton.target = self.revealViewController()
    
        menuButton.action = "revealToggle:"
    
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    
        }
    }
    
    override func queryForTable() -> PFQuery {
     
        let query = PFQuery(className: "Date")
        
        query.orderByAscending("Date")
        
        return query
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! ScheduleCell
        
        cell.titleLabel.text = object?.objectForKey("Date") as? String
        
        return cell
    }
}
