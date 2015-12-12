//
//  FindTeams.swift
//  BCS Gameday
//
//  Created by Mark Manstof on 10/5/15.
//  Copyright © 2015 Manstof. All rights reserved.
//

import Foundation
import Parse
import FBSDKCoreKit

class Teams {
    
    func Teams() {
        
        print(PFUser.currentUser())
        
        let leagueNumber = PFUser.currentUser()!["leagueNumber"] as? String
        
        let attemptedUrl = NSURL(string: "http://beachcitysports.leagueapps.com/leagues/\(leagueNumber!)/teams")
        
        if let url = attemptedUrl {
            
            let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) -> Void in
                
                if let urlContent = data {
                    
                    let webContent = NSString(data: urlContent, encoding: NSUTF8StringEncoding)
                    
                    //Manipulate string to get the team information
                    var teamDataArray = webContent!.componentsSeparatedByString("<!-- Main Content -->")
                    
                    var teamWebString = teamDataArray[1]
                    
                    teamWebString = teamWebString.stringByReplacingOccurrencesOfString("\t", withString: "")
                    
                    teamWebString = teamWebString.stringByReplacingOccurrencesOfString("\r", withString: "")
                    
                    teamWebString = teamWebString.stringByReplacingOccurrencesOfString("\n", withString: "")
                    
                    teamWebString = teamWebString.stringByReplacingOccurrencesOfString("\0", withString: "")
                    
                    //print(teamWebString)
                    
                    teamDataArray = teamWebString.componentsSeparatedByString("<li class=\"clr\">")
                    
                    teamDataArray.removeAtIndex(0)
                    
                    for var team in teamDataArray {
                        
                        //Playing with strings

                        team.removeRange(team.startIndex..<team.startIndex.advancedBy(65))
                        
                        let teamNumberRange = team.startIndex..<team.startIndex.advancedBy(6)
                        
                        let teamNumber = team[teamNumberRange]

                        team.removeRange(team.startIndex..<team.startIndex.advancedBy(140))
                        
                        let range: Range<String.Index> = team.rangeOfString("<")!
                        
                        let index: Int = team.startIndex.distanceTo(range.startIndex)
                        
                        let teamRange = team.startIndex..<team.startIndex.advancedBy(index)
                        
                        team = team[teamRange]
                        
                        // Then query and compare (check to see if league entries exist)
                        let query = PFQuery(className: "Teams")
                        
                        query.whereKey("Team", equalTo: team)
                        
                        query.findObjectsInBackgroundWithBlock {
                            
                            (objects: [AnyObject]?, error: NSError?) in
                            
                            if error == nil {
                                
                                if (objects!.count > 0){
                                    
                                    for object in objects! {
                                        
                                        object.deleteInBackground()
                                        
                                    }
                                }
                                
                                //Saving to Parse
                                let Teams = PFObject(className: "Leagues")
                                
                                Teams["Team"] = team
                                
                                Teams["TeamNumber"] = teamNumber
                                
                                Teams.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in }
                                
                            } else {
                                
                                print("error")
                         
                            }
                        }
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
            
            //Create alert that it couldn't find team name
            
        }
    }
}

//to run this code: //var findTeam = getTeams() 

