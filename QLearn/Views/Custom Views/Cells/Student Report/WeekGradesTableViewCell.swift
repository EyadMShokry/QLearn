//
//  WeekGradesTableViewCell.swift
//  El-Khateeb
//
//  Created by Eyad Shokry on 9/17/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import UIKit

class WeekGradesTableViewCell: UITableViewCell {
    @IBOutlet weak var weekNumberLabel: UILabel!
    @IBOutlet weak var gradeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        weekNumberLabel.addBorder(borderWidth: 1, cornerRadius: 5, borderColor: UIColor.lightGray.cgColor)
        gradeLabel.addBorder(borderWidth: 1, cornerRadius: 5, borderColor: UIColor.lightGray.cgColor)
        dateLabel.addBorder(borderWidth: 1, cornerRadius: 5, borderColor: UIColor.lightGray.cgColor)
        self.selectionStyle = .none


    }

  

}
