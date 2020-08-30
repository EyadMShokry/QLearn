//
//  Question.swift
//  El-Khateeb
//
//  Created by Eyad Shokry on 9/23/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import Foundation

struct Questions: Decodable {
    let RESULT: [QuestionResult]
}

struct QuestionResult: Decodable {
    let id: String
    let student_id: String
    let question: String
    let answer: String
    let chapter_id: String
}
