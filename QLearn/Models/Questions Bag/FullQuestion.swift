//
//  FullQuestion.swift
//  El-Khateeb
//
//  Created by Eyad Shokry on 10/2/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import Foundation

struct FullQuestion: Decodable {
    let RESULT: [FullQuestionResult]
}

struct FullQuestionResult: Decodable {
    let id: String
    let question: String
    let chapter_id: String
    
    //for mcq
    let choice1: String!
    let choice2: String!
    let choice3: String!
    let choice4: String!
    let correct_answer: String!
    
    //for essay
    let essay_type: String!
    
    //for TF
    let correct_mark: String!
    let explanation: String!
}
