//
//  Attendance.swift
//  El-Khateeb
//
//  Created by Eyad Shokry on 9/17/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import Foundation

struct AttendanceResult: Decodable {
    let RESULT: [Attendance]
}

struct Attendance: Decodable {
    let num: String
    let status: String
}
