//
//  Phone.swift
//  El-Khateeb
//
//  Created by Eyad Shokry on 9/27/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import Foundation

struct Phone: Decodable {
    let RESULT: [PhoneResult]
}

struct PhoneResult: Decodable{
    let id: String
    let phone: String
}
