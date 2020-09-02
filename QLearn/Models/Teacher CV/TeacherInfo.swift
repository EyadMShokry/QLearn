//
//  TeacherInfo.swift
//  El-Khateeb
//
//  Created by Eyad Shokry on 9/27/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import Foundation

struct TeacherInfo: Decodable {
    let RESULT: [TeacherInfoResult]
}

struct TeacherInfoResult: Decodable {
    let info_id: String
    let fullName: String
    let job: String
    let speciality: String
    let DOB: String
    let school: String
    let photo_url: String!
    let cover_url: String!
    let teacherID: String
}
