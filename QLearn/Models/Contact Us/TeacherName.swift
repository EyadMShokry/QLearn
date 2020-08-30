//
//  TeacherName.swift
//  El-Khateeb
//
//  Created by Eyad Shokry on 9/27/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import Foundation

struct TeacherName: Decodable {
    let RESULT: [TeacherFullName]
}

struct TeacherFullName: Decodable {
    let fullName: String
}
