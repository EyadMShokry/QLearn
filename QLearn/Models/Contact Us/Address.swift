//
//  Address.swift
//  El-Khateeb
//
//  Created by Eyad Shokry on 9/27/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import Foundation

struct Address: Decodable {
    let RESULT: [AddressResult]
}

struct AddressResult: Decodable{
    let id: String
    let address_title: String
    let address: String
}
