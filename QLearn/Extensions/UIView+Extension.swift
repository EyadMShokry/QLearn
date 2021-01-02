//
//  UIView+Extension.swift
//  El-Khateeb
//
//  Created by Eyad Shokry on 10/4/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import UIKit

extension UIView {
    public func createsBorderForView(color: UIColor, radius: CGFloat, width: CGFloat = 2){
        layer.borderWidth = width
        layer.cornerRadius = radius
        layer.shouldRasterize = false
        layer.rasterizationScale = 2
        clipsToBounds = true
        layer.masksToBounds = true
        let cgColor: CGColor = color.cgColor
        layer.borderColor = cgColor
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
         let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
         let mask = CAShapeLayer()
         mask.path = path.cgPath
         layer.mask = mask
     }
}
