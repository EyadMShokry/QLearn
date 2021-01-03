//
//  NotAnsweredMCQQuestions.swift
//  QLearn
//
//  Created by Eyad Shokry on 1/3/21.
//  Copyright © 2021 Eyad Shokry. All rights reserved.
//

import Foundation

//MARK: - NotAnsweredMCQQuestions
public struct NotAnsweredMCQQuestions: Codable {
    
    public var response : NotAnsweredMCQQuestionsResponse!
    public var status : Int!
    
}

//MARK: - NotAnsweredMCQQuestionsResponse
public struct NotAnsweredMCQQuestionsResponse: Codable {
    
    public var msg : String!
    public var questions : [NotAnsweredMcqQuestion]!
    
}

//MARK: - McqQuestion
public struct NotAnsweredMcqQuestion: Codable {
    
    public var choice1 : String!
    public var choice2 : String!
    public var choice3 : String!
    public var choice4 : String!
    public var correct_answer : String!
    public var exam_id : String!
    public var id : String!
    public var image : String!
    public var level : String!
    public var question : String!
    public var teacherID : String!
    
}

