//
//  RightAnswersCountLE.swift
//  QLearn
//
//  Created by Eyad Shokry on 1/3/21.
//  Copyright © 2021 Eyad Shokry. All rights reserved.
//

import Foundation

//MARK: - RightAnswersCountLE
public struct RightAnswersCountLE: Codable {
    
    public var response : RightAnswersCountResponse!
    public var status : Int!
    
}

import Foundation

//MARK: - Response
public struct RightAnswersCountResponse: Codable {
    
    public var exams : [RightAnswersCountExam]!
    public var msg : String!
    
}

public struct RightAnswersCountExam: Codable {
    
    public var exam_id : String!
    public var right_count : String!
    
}
