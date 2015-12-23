//
//  LogoutView.swift
//  BCS Gameday
//
//  Created by Mark Manstof on 12/22/15.
//  Copyright © 2015 Manstof. All rights reserved.
//

import UIKit
import Parse

class LogoutView: UIViewController {

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

        // Send a request to log out a user
        PFUser.logOut()

        if (PFUser.currentUser()?.username == nil) {

            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LoginViewStack")
                
                self.presentViewController(viewController, animated: true, completion: nil)
            })
        }
        
        /*
        //Alternate Logout User Code
        PFUser.logOutInBackgroundWithBlock() {
        
            (error: NSError?) -> Void in
        
            if error != nil {
        
                print("logout fail")
        
                print(error)
        
                } else {
        
            print("logout success")
        
            print(PFUser.currentUser())
        
            }
        }
        */

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
