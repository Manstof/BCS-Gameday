//
//  HomeView.swift
//  BCS Gameday
//
//  Created by Mark Manstof on 11/18/15.
//  Copyright © 2015 Manstof. All rights reserved.
//

import UIKit

class HomeView: UIViewController {
    
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
    
    override func viewDidAppear(animated: Bool) {
        

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
