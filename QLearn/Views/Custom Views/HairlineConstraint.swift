//
//  HairlineConstraint.swift
//  El-Khateeb
//
//  Created by Eyad Shokry on 9/20/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import UIKit

class HairlineConstraint: NSLayoutConstraint {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.constant = 1.0 / UIScreen.main.scale
    }
}
