//
//  AskUsTableViewCell.swift
//  El-Khateeb
//
//  Created by Eyad Shokry on 9/23/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import UIKit

class AskUsTableViewCell: UITableViewCell {
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var cellView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellView.layer.borderColor = UIColor.white.cgColor
        cellView.layer.borderWidth = 2.5
        cellView.layer.cornerRadius = 10
        self.selectionStyle = .none
    }

    

}
