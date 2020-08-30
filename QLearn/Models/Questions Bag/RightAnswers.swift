//
//  RightAnswers.swift
//  El-Khateeb
//
//  Created by Eyad Shokry on 9/29/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import Foundation

struct RightAnswers: Decodable {
    let RESULT: [RightAnswersResult]
}

struct RightAnswersResult: Decodable {
    let chapter_id: String
    let right_count: String
}
