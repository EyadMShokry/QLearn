//
//  StudentLogin.swift
//  El-Khateeb
//
//  Created by Eyad Shokry on 9/30/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import Foundation

struct StudentLogin: Decodable {
    let RESULT: [StudentLoginResult]
}

struct StudentLoginResult: Decodable {
        let id: String
        let name: String
        let phone: String
        let parentPhone: String
        let level: String
        let password: String
}
