//
//  FamilyTableViewCell.swift
//  FamJam
//
//  Created by Lucio Tan on 4/25/16.
//  Copyright © 2016 Accord.io. All rights reserved.
//

import UIKit

class FamilyTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var profilePicture: UIImageView!
    
    

    @IBAction func remindButtonPushed(sender: UIButton) {
        sender.titleLabel?.text = "Reminded"
    }
    
    
    
    @IBOutlet weak var remindButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
