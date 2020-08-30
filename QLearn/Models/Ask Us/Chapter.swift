//
//  Chapter.swift
//  El-Khateeb
//
//  Created by Eyad Shokry on 9/28/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import Foundation

struct Chapter: Decodable {
    let RESULT: [ChapterResult]
}

struct ChapterResult: Decodable {
    let id: String
    let title: String
    let questions_count: String!
    let mcq_count: String!
    let essay_count: String!
    let tf_count: String!
    var rightAnswersPercent: String!
}
