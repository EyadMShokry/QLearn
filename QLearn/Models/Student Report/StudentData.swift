//
//  StudentData.swift
//  QLearn
//
//  Created by Eyad Shokry on 11/5/20.
//  Copyright © 2020 Eyad Shokry. All rights reserved.
//

import Foundation

// For student report
struct StudentData: Decodable {
    let RESULT: [StudentResult]
}

struct StudentResult: Decodable {
    let id: String
    let name: String
    let phone: String
    let parentPhone: String
    let motherPhone: String
    let level: String
    let school: String
    let password: String
}
