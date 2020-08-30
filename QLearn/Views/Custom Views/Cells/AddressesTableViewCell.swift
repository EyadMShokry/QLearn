//
//  AddressesTableViewCell.swift
//  El-Khateeb
//
//  Created by Abdalah on 9/17/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import UIKit

class AddressesTableViewCell: UITableViewCell {

    @IBOutlet weak var AddressesLable: UILabel!
    @IBOutlet weak var AddressesImage: UIImageView!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

}
