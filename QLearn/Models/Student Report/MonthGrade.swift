//
//  MonthGrade.swift
//  El-Khateeb
//
//  Created by Eyad Shokry on 9/17/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import Foundation

struct MonthGrades: Decodable {
    let RESULT: [Grades]
}

struct Grades: Decodable {
    let stuID: String
    let monthNum: String
    let grade: String
    let teacherID: String
    let totalGrade: String
}

