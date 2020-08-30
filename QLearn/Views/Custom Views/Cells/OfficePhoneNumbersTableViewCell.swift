//
//  OfficePhoneNumbersTableViewCell.swift
//  El-Khateeb
//
//  Created by Abdalah on 9/17/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import UIKit

class OfficePhoneNumbersTableViewCell: UITableViewCell {

    @IBOutlet weak var PhoneNumbersImage: UIImageView!
    @IBOutlet weak var PhoneNumbersLable: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
}
