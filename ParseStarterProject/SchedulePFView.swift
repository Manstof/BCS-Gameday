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
    
    override init(style: UITableViewStyle, className: String!) {
        super.init(style: style, className: className)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        //Use the Parse built-in user class
        self.parseClassName = "Date"
        
        //This is a custom column in the user class.
        self.textKey = "Date"
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    override func queryForTable() -> PFQuery {
        let query = PFQuery(className: self.parseClassName!)
        
        query.limit = 1000
        
        query.cachePolicy = PFCachePolicy.CacheThenNetwork
        
        return query
    
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell",  forIndexPath: indexPath) as! SchedulePFCell
        
        //These two columns are custom fields.  You'll need to add them to the Parse _User class manually.
        
        let date = object!["Date"] as! String
       
        cell.displayDate?.text = date
        
        return cell
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
        
    }
    
        override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
        
    }
    

    

}
