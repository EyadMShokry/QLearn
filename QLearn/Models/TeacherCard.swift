//
//  TeacherCard.swift
//  QLearn
//
//  Created by Eyad Shokry on 9/3/20.
//  Copyright © 2020 Eyad Shokry. All rights reserved.
//

import Foundation

class TeacherCard: Decodable {
    let RESULT: [Card]
}

class Card: Decodable {
    let id: String
    let teacherID: String
    let cardNumber: String
    let status: String
}
