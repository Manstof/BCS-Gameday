//
//  SchedulePFView.swift
//  BCS Gameday
//
//  Created by Mark Manstof on 11/17/15.
//  Copyright © 2015 Manstof. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class SchedulePFView: PFQueryTableViewController {
    
    override func queryForTable() -> PFQuery {
        
        let query = PFQuery(className: "User")
        query.cachePolicy = .CacheElseNetwork
        query.orderByAscending("objectId")
        return query
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! SchedulePFCell
        
        cell.displayDate.text = object?.objectForKey("objectId") as? String
        
        return cell
        
    }

    
    
}
