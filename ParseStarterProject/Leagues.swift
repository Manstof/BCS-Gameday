//
//  Findsports.swift
//  BCS Gameday
//
//  Created by Mark Manstof on 10/5/15.
//  Copyright © 2015 Manstof. All rights reserved.
//

import Foundation
import Parse
import FBSDKCoreKit

class leagues {
    
    func leagues() {
        
        // Then query and compare (check to see if league entries exist)
        let query = PFQuery(className: "Leagues")
        
        //query.whereKey("League", equalTo: league)
        
        query.findObjectsInBackgroundWithBlock {
            
            (objects: [AnyObject]?, error: NSError?) in
            
            if error == nil {
                
                if (objects!.count > 0) {
                    //if let objects = objects as? [PFObject] {
                    
                    for object in objects! {
                        
                        object.deleteInBackground()
                        
                    }
                }
                
            } else {
                
                print("error")
            }
        }
        
        //Sports
        let attemptedUrl = NSURL(string: "http://beachcitysports.leagueapps.com/widgets/leagueListingContent?heightSetting=600px&wmode=opaque")
        
        if let url = attemptedUrl {
            
            let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) -> Void in
                
                if let urlContent = data {
                    
                    let webContent = NSString(data: urlContent, encoding: NSUTF8StringEncoding)
                    
                    var sportWebDataArray = webContent!.componentsSeparatedByString("<ul>")
                    
                    let sportWebString = sportWebDataArray[1]
                    
                    var sportArray = sportWebString.componentsSeparatedByString("</li>")
                    
                    sportArray.removeLast()
                    
                    for var sport in sportArray {
                   
                        //Playing with strings
                        
                        sport = sport.stringByReplacingOccurrencesOfString("\t", withString: "")
                        
                        sport = sport.stringByReplacingOccurrencesOfString("\r", withString: "")
                        
                        sport = sport.stringByReplacingOccurrencesOfString("\n", withString: "")
                        
                        sport = sport.stringByReplacingOccurrencesOfString("\0", withString: "")
                        
                        sport = sport.stringByReplacingOccurrencesOfString("volleyball", withString: "")
                        
                        sport = sport.stringByReplacingOccurrencesOfString("football", withString: "")
                        
                        sport = sport.stringByReplacingOccurrencesOfString("flag-", withString: "")
                        
                        sport = sport.stringByReplacingOccurrencesOfString("soccer-(outdoor)", withString: "")
                        
                        sport = sport.stringByReplacingOccurrencesOfString("bowling", withString: "")
                        
                        sport = sport.stringByReplacingOccurrencesOfString(" <", withString: "<")
                        
                        sport = sport.stringByReplacingOccurrencesOfString("> ", withString: ">")
                        
                        sport.removeRange(sport.startIndex..<sport.startIndex.advancedBy(50))
                        
                        //Get number for league
                        let leagueNumberRange = sport.startIndex..<sport.startIndex.advancedBy(5)
                        
                        let leagueNumber = sport[leagueNumberRange]

                        //Keep playing with strings
                        sport.removeRange(sport.startIndex..<sport.startIndex.advancedBy(11))
                        
                        sport.removeRange(sport.endIndex.advancedBy(-384)..<sport.endIndex)
                        
                        sport = sport.stringByReplacingOccurrencesOfString("</a", withString: "")
                        
                        sport = sport.stringByReplacingOccurrencesOfString("<em c", withString: "")
                        
                        sport = sport.stringByReplacingOccurrencesOfString("<e", withString: "")
                        
                        sport = sport.stringByReplacingOccurrencesOfString("<", withString: "")
                        
                        sport = sport.stringByReplacingOccurrencesOfString(">", withString: "")
                   
                        sport = sport.stringByReplacingOccurrencesOfString("/", withString: "")
                        
                        sport = sport.stringByReplacingOccurrencesOfString("Season-", withString: "Season -")
                        
                        sport = sport.stringByReplacingOccurrencesOfString(":", withString: "-")
                        
                        let league = sport
                        
                        //Saving to Parse
                        let Leagues = PFObject(className: "Leagues")
                        
                        Leagues["League"] = league
                        
                        Leagues["LeagueNumber"] = leagueNumber
                        
                        print("saved")
                        
                        Leagues.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in }

                    }
                    
                } else {
                    
                    print("URL could not connect")
                    
                }
                
                //Close internet session
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                })
            }
            
            task.resume()
            
        } else {
            
            print("Fail")
            
            //Create alert that it couldn't find sport name
            
        }
    }
}