//
//  Test.swift
//  BCS Gameday
//
//  Created by Mark Manstof on 10/5/15.
//  Copyright © 2015 Manstof. All rights reserved.
//

import Foundation

class test: UIViewController {

    
    @IBAction func Button1(sender: AnyObject) {
        
        let teams = Teams()
        
        teams.getTeams()
        
        print(teams)
        
    }
    
    
    @IBAction func Button2(sender: AnyObject) {
        
        let schedule = Schedule()
        
        schedule.getSchedule()
        
        print(schedule)
        
        
    }
    
    
    @IBAction func Button3(sender: AnyObject) {
        
        
    }
}