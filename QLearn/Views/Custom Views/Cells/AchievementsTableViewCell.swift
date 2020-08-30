//
//  AchievementsTableViewCell.swift
//  El-Khateeb
//
//  Created by Abdalah on 9/16/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import UIKit

class AchievementsTableViewCell: UITableViewCell {

    @IBOutlet weak var AchievementLable: UILabel!
    @IBOutlet weak var AchievementImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none

    }

    
}
