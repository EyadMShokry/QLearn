//
//  AddNewNewsTableViewCell.swift
//  El-Khateeb
//
//  Created by Abdalah on 9/19/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import UIKit

class AddNewNewsTableViewCell: UITableViewCell {

    @IBOutlet weak var AddNewNewslable: UILabel!
    @IBOutlet weak var NewsDate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none

    }

  

}
