//
//  Teachers.swift
//  QLearn
//
//  Created by Eyad Shokry on 8/31/20.
//  Copyright © 2020 Eyad Shokry. All rights reserved.
//

import Foundation

class Teachers: Decodable {
    let RESULT: [Teacher]
}

class Teacher: Decodable {
    let id: String
    let name: String
    let phone: String
    let subject: String
    let photo_url: String
}
