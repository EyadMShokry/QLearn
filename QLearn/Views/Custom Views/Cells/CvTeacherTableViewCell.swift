//
//  CvTeacherTableViewCell.swift
//  El-Khateeb
//
//  Created by Abdalah on 9/15/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import UIKit

class CvTeacherTableViewCell: UITableViewCell {
    @IBOutlet weak var informationLable: UILabel!
    
    @IBOutlet weak var dataLable: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none

    }

  

}
