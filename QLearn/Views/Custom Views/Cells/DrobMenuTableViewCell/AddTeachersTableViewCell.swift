//
//  AddTeachersTableViewCell.swift
//  El-Khateeb
//
//  Created by Abdalah on 9/19/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import UIKit

class AddTeachersTableViewCell: UITableViewCell {

    @IBOutlet weak var ImageTeacher: UIImageView!
    @IBOutlet weak var NameTeacherLable: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none

    }

}
