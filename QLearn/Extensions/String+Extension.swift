//
//  String+Extension.swift
//  El-Khateeb
//
//  Created by Eyad Shokry on 10/29/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import Foundation

extension String {
    public var replacedArabicDigitsWithEnglish: String {
        var str = self
        let map = ["٠": "0",
                   "١": "1",
                   "٢": "2",
                   "٣": "3",
                   "٤": "4",
                   "٥": "5",
                   "٦": "6",
                   "٧": "7",
                   "٨": "8",
                   "٩": "9"]
        map.forEach {str = str.replacingOccurrences(of: $0, with: $1)}
        return str
    }
}
