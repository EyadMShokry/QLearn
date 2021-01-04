//
//  AnswerdMCQQuestions.swift
//  QLearn
//
//  Created by Eyad Shokry on 1/4/21.
//  Copyright © 2021 Eyad Shokry. All rights reserved.
//

import Foundation

//MARK: - MCQAnswers
public struct AnsweredMCQQuestions: Codable {
    
    public var response : MCQAnswersResponse!
    public var status : Int!
    
}

//MARK: - MCQAnswersResponse
public struct MCQAnswersResponse: Codable {
    
    public var msg : String!
    public var questions : [AnswerdMCQQuestion]!
    
}

//MARK: - MCQQuestion
public struct AnswerdMCQQuestion: Codable {
    
    public var answer : MCQAnswerLE!
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

//MARK: - MCQAnswerLE
public struct MCQAnswerLE: Codable {
    
    public var actualAnswer : String!
    public var examId : String!
    public var id : String!
    public var isCorrect : String!
    public var questionId : String!
    public var studentId : String!
    public var type : String!
    
}
