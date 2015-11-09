//
//  Schedule.swift
//  BCS Gameday
//
//  Created by Mark Manstof on 10/5/15.
//  Copyright © 2015 Manstof. All rights reserved.
//

import Foundation
import Parse
import FBSDKCoreKit

class Schedule {
    
    var dateArray = [String]()
    
    func getSchedule() {
        
        let attemptedUrl = NSURL(string: "http://beachcitysports.leagueapps.com/leagues/66872/schedule?gameState=&teamId=291781&locationId=")
        
        if let url = attemptedUrl {
            
            let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) -> Void in
                
                if let urlContent = data {
                    
                    let webContent = NSString(data: urlContent, encoding: NSUTF8StringEncoding)
                    
                    //Get the dates of the games
                    var dateDataArray = webContent!.componentsSeparatedByString("<span class=\"date\">")
                    
                    dateDataArray.removeAtIndex(0)
                    
                    //Loops
                    //***************ADD SOMETHING TO CLIP WHITE SPACE
                    for var date in dateDataArray {
                        
                        date = date.stringByReplacingOccurrencesOfString("</span> <abbr>@</abbr> <span class=\"time\">", withString: " @ ")
                        
                        date = date.stringByReplacingOccurrencesOfString("<", withString: "")
                        
                        date.removeRange(date.startIndex.advancedBy(22)..<date.endIndex)
                        
                        date = date.stringByReplacingOccurrencesOfString("/", withString: "")
                        
                        //Saving Dates
                        let dates = PFObject(className: "Date")
                        
                        dates["Date"] = date
                        
                        dates.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in }
                    
                    }
                    
                    //Close internet session
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                    })
                }
            }
            
            task.resume()
            
        } else {
            
            print("You blew it trying to get the game dates, try again (2nd line)")
            
        }
    }
    
    //activityIndicator.stopAnimating()
    //UIApplication.sharedApplication().endIgnoringInteractionEvents()
    

    
}