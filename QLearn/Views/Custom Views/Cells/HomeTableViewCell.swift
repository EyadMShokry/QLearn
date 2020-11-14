//
//  HomeTableViewCell.swift
//  El-Khateeb
//
//  Created by Eyad Shokry on 9/12/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var cellSwitch: UISwitch!
    @IBOutlet weak var availabilityLabel: UILabel!
    @IBOutlet weak var teacherCardStackView: UIStackView!
    @IBOutlet weak var lockingImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
}
 
