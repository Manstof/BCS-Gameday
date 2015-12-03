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
    
    func getTeams() {
        
        let attemptedUrl = NSURL(string: "http://beachcitysports.leagueapps.com/leagues/67883/schedule?gameState=&teamId=&locationId=")
        
        if let url = attemptedUrl {
            
            let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) -> Void in
                
                if let urlContent = data {
                    
                    let webContent = NSString(data: urlContent, encoding: NSUTF8StringEncoding)
                    
                    //Manipulate string to get the team information
                    var teamWebDataArray = webContent!.componentsSeparatedByString(">All s</option>")
                    
                    print(teamWebDataArray)
                    
                    let teamWebString = teamWebDataArray[1]
                        
                    var teamDataArray = teamWebString.componentsSeparatedByString("</select>")
                        
                    let teamString = teamDataArray[0]
                    
                    let teamArray = teamString.componentsSeparatedByString("<option value=")
                    
                    print(teamArray.count)
                    
                    for var team in teamArray {
                        
                        //Playing with strings
                        //*****************************ADD SOMETHING TO CLIP WHITE SPACE
                        
                        team = team.stringByReplacingOccurrencesOfString("</option>", withString: "")
                        
                        team = team.stringByReplacingOccurrencesOfString("\"", withString: "")
                        
                        team = team.stringByReplacingOccurrencesOfString(">", withString: " - ")
                        
                        print(team)
                        
                        //Saving Strings
                        let teams = PFObject(className: "Database")
                        
                        teams["Teams"] = team
                        
                        teams.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in }
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

