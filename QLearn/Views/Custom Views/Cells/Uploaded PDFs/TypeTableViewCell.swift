//
//  TypeTableViewCell.swift
//  El-Khateeb
//
//  Created by Eyad Shokry on 9/19/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import UIKit

class TypeTableViewCell: UITableViewCell {

    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var cellView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellView.layer.borderWidth = 1
        cellView.layer.borderColor = UIColor.black.cgColor
        cellView.layer.cornerRadius = 10
        self.selectionStyle = .none
    }
}
