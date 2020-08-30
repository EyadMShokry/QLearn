//
//  MonthGradesTableViewCell.swift
//  El-Khateeb
//
//  Created by Eyad Shokry on 9/17/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import UIKit

class MonthGradesTableViewCell: UITableViewCell {
    @IBOutlet weak var monthNumberLabel: UILabel!
    @IBOutlet weak var gradeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        monthNumberLabel.addBorder(borderWidth: 1, cornerRadius: 5, borderColor: UIColor.lightGray.cgColor)
        gradeLabel.addBorder(borderWidth: 1, cornerRadius: 5, borderColor: UIColor.lightGray.cgColor)
        self.selectionStyle = .none


    }



}
