//
//  SchedulePFCell.swift
//  BCS Gameday
//
//  Created by Mark Manstof on 11/18/15.
//  Copyright © 2015 Manstof. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class SchedulePFCell: PFTableViewCell {

    @IBOutlet weak var displayDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}