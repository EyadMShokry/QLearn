//
//  Date+Extension.swift
//  El-Khateeb
//
//  Created by Eyad Shokry on 10/21/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import Foundation

extension Date {
    static func getCurrentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: Date())
    }
}
