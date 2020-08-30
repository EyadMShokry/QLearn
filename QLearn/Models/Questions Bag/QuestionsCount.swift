//
//  QuestionsCount.swift
//  El-Khateeb
//
//  Created by Eyad Shokry on 9/29/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import Foundation

struct QuestionsCount: Decodable {
    let RESULT: [QuestionsCountResult]
}

struct QuestionsCountResult: Decodable {
    let mcq_count: String
    let essay_count: String
    let tf_count: String
}
