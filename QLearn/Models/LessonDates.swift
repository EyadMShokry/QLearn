//
//  LessonDates.swift
//  El-Khateeb
//
//  Created by Eyad Shokry on 9/15/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import Foundation

class LessonDate: Decodable {
    let RESULT: [LessonResult]
}

class LessonResult: Decodable {
    let id: String
    let place: String
    let day: String
    let time: String
    let minutes: String
    let order: String
    let level: String
    let teacherID: String
    let level_id: String
    let levelTitle: String
}
