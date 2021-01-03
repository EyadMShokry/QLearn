//
//  Exam.swift
//  Model Generated using http://www.jsoncafe.com/
//  Created on January 2, 2021

import Foundation

//MARK: - ExamResult
public struct ExamResult: Codable {
    
    public var response : Response!
    public var status : Int!
    
}

//MARK: - Response
public struct Response: Codable {
    
    public var exams : [Exam]!
    public var msg : String!
    
}

//MARK: - Exam
public struct Exam: Codable {
    
    public var begindate : String!
    public var begintime : String!
    public var enddate : String!
    public var endtime : String!
    public var examduration : String!
    public var id : String!
    public var level : String!
    public var no_of_questions : Int!
    public var teacherID : String!
    public var title : String!
    
}

