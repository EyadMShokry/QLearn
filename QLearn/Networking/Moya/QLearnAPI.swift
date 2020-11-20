//
//  QLearnAPI.swift
//  QLearn
//
//  Created by Eyad Shokry on 11/20/20.
//  Copyright © 2020 Eyad Shokry. All rights reserved.
//

import Moya

public enum QLearnAPI {
    // MARK: Live Exam APIs
    // LE -> Live Exam
    case insertEssayQuestionLE(essay_type: String, exam_id: String, teacher_id: String, level: String)
    case insertMcqQuestionLE(correct_answer: String, exam_id: String, teacher_id: String, level: String)
    case insertTFQuestionLE(explanation: String, exam_id: String, teacher_id: String, level: String)
    case updateEssayQuestionLE(id: String, question: String, correct_answer: String)
    case updateMcqQuestionLE(id: String, question: String, choice1: String, choice2: String)
    case updateTFQuestionLE(id: String, question: String, correct_answer: String, explanation: String)
    case deleteLEQuestion(id: String, q_type: String)
    case selectExam(id: String)
    case selectAllLEQuestions(level: String, teacher_id: String, q_type: String)
    case selectAnswerdEssayQuestionsLE(exam_id: String, teacher_id: String, student_id: String, level: String)
    case selectAnswerMcqQuestionsLE(exam_id: String, teacher_id: String, student_id: String, level: String)
    case selectAnswerdTFQuestionsLE(exam_id: String, teacher_id: String, student_id: String, level: String)
    case selectCountOfQuestionsLE(teacher_id: String, level: String)
    case selectNotAnswerdEssayQuestionsLE(exam_id: String, teacher_id: String, student_id: String, level: String)
    case selectNotAnswerdMcqQuestionsLE(exam_id: String, teacher_id: String, student_id: String, level: String)
    case selectNotAnswerdTFQuestionsLE(exam_id: String, teacher_id: String, student_id: String, level: String)
    
}

extension QLearnAPI: TargetType {
    
    public var baseURL: URL {
        switch self {
        default: return URL(string: "http://vmi448785.contaboserver.net/~qlearn/khaled/Qlearn_API/")!
        }
    }
    
    public var path: String {
        switch self {
        // MARK: Live Exam APIs
        case .insertEssayQuestionLE: return "insert_essay_question_liveexam"
        case .insertMcqQuestionLE: return "insert_mcq_question_liveexam"
        case .insertTFQuestionLE: return "insert_tf_question_liveexam"
        case .updateEssayQuestionLE: return "update_essay_question_liveexam"
        case .updateMcqQuestionLE: return "update_mcq_question_liveexam"
        case .updateTFQuestionLE: return "update_tf_question_liveexam"
        case.deleteLEQuestion: return "delete_liveexam_question"
        case .selectExam: return "select_exam"
        case .selectAllLEQuestions: return "select_all_liveexam_questions"
        case .selectAnswerdEssayQuestionsLE: return "select_answered_essay_question_liveexam"
        case .selectAnswerMcqQuestionsLE: return "select_answered_mcq_questions_liveexam"
        case .selectAnswerdTFQuestionsLE: return "select_answered_tf_questions_liveexam"
        case .selectCountOfQuestionsLE: return "select_countOf_all_questions_liveexam"
        case .selectNotAnswerdEssayQuestionsLE: return "select_not_answered_essay_question_liveexam"
        case .selectNotAnswerdMcqQuestionsLE: return "select_not_answered_mcq_questions_liveexam"
        case .selectNotAnswerdTFQuestionsLE: return "select_not_answered_tf_questions_liveexam"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .insertEssayQuestionLE, .insertMcqQuestionLE, .insertTFQuestionLE,
             .updateEssayQuestionLE, .updateMcqQuestionLE, .updateTFQuestionLE: return .post
        default: return .get
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        switch self {
        case .contactUs(userName: let userName, jobPosition: let jobPosition, phoneNumber: let phoneNumber, message: let message):
            return .requestParameters(parameters: ["user_name": userName, "job_position": jobPosition, "phone_number": phoneNumber, "message": message], encoding: URLEncoding.queryString)
//        case .getAdsByCountry(countryCode: let countryCode, start: let start, limit: let limit): return .requestParameters(parameters: ["type": "ads", "country": countryCode, "limit": limit, "start": start], encoding: URLEncoding.queryString)
//        case .getLocation(ipAddress: let ipAddress):
//            return .requestParameters(parameters: ["ip": ipAddress], encoding: URLEncoding.queryString)
//        case .getCategories: return .requestParameters(parameters: ["type": "catogaries"], encoding: URLEncoding.queryString)
//        case .getCountries: return .requestParameters(parameters: ["type": "countries"], encoding: URLEncoding.queryString)
//        case .getAds(countryCode: let countryCode, regionCode: let regionCode, category: let category): return .requestParameters(parameters: ["type": "ads", "country": countryCode, "region": regionCode ,"cat": category], encoding: URLEncoding.queryString)
        }
    }
    
    public var headers: [String: String]? {
        switch self {
        default: return ["Content-Type": "application/json"]
        }
    }
    
    public var validationType: ValidationType {
        return .successCodes
    }
    
}
