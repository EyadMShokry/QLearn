//
//  AttendanceTableViewCell.swift
//  El-Khateeb
//
//  Created by Eyad Shokry on 9/17/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import UIKit

class AttendanceTableViewCell: UITableViewCell {
    @IBOutlet weak var weekNumberLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        weekNumberLabel.addBorder(borderWidth: 1, cornerRadius: 5, borderColor: UIColor.lightGray.cgColor)
        statusLabel.addBorder(borderWidth: 1, cornerRadius: 5, borderColor: UIColor.red.cgColor)
        dateLabel.addBorder(borderWidth: 1, cornerRadius: 5, borderColor: UIColor.lightGray.cgColor)
        self.selectionStyle = .none

    }

}
