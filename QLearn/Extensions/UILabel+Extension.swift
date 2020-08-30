//
//  UIView+Extension.swift
//  El-Khateeb
//
//  Created by Eyad Shokry on 9/17/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import UIKit

extension UILabel {
    
    func addBorder(borderWidth: CGFloat, cornerRadius: CGFloat, borderColor: CGColor) {
        layer.borderWidth = borderWidth
        layer.cornerRadius = cornerRadius
        layer.borderColor = borderColor
    }
}
