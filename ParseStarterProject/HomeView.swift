//
//  HomeView.swift
//  BCS Gameday
//
//  Created by Mark Manstof on 11/18/15.
//  Copyright © 2015 Manstof. All rights reserved.
//

import UIKit
import Parse

class HomeView: UIViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var userTeamLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Control Menu Bar
        if self.revealViewController() != nil {
            
            menuButton.target = self.revealViewController()
            
            menuButton.action = "revealToggle:"
            
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
        
        //Get user info
        //Get team name
        if let teamName = PFUser.currentUser()!["teamName"] as? String {
            
            userTeamLabel.text = teamName
            
        }
        
        //Get username
        if let username = PFUser.currentUser()!["username"] as? String {
            
            usernameLabel.text = username
            
        }
        
        if let userImage = PFUser.currentUser()!["image"] as? String {
            
            let userImage = userImage
            
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {

        if (PFUser.currentUser()?.username == nil) {

            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LoginView") 
                
                self.presentViewController(viewController, animated: true, completion: nil)
            
            })
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
