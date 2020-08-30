//
//  AdminLogin.swift
//  El-Khateeb
//
//  Created by Eyad Shokry on 10/1/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import Foundation

struct AdminLogin: Decodable {
    let RESULT: [AdminLoginResult]
}

struct AdminLoginResult: Decodable {
    let id: String
    let phone: String
    let name: String
    let pass: String
}
