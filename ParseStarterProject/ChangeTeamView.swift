//
//  LogoutView.swift
//  BCS Gameday
//
//  Created by Mark Manstof on 12/22/15.
//  Copyright © 2015 Manstof. All rights reserved.
//

import UIKit
import Parse

class ChangTeamView: UIViewController {
    
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
    
    override func viewWillAppear(animated: Bool) {
        
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("teamStack")
        
        self.presentViewController(viewController, animated: true, completion: nil)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
