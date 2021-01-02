//
//  QLearnAPI.swift
//  QLearn
//
//  Created by Eyad Shokry on 11/20/20.
//  Copyright © 2020 Eyad Shokry. All rights reserved.
//

import Moya

public enum QLearnAPI {
    // MARK: Select Teachers APIs
    case insertStudentTeacherRequest(stuID: String, teacher_id: String)
    
    // MARK: Live Exam APIs
    // LE -> Live Exam
    case insertEssayQuestionLE(question: String, correct_answer: String, essay_type: String, exam_id: String, teacher_id: String, level: String)
    case insertMcqQuestionLE(question: String, choice1: String, choice2: String,
        choice3 : String, choice4: String, correct_answer: String, exam_id: String, teacher_id: String, level: String)
    case insertTFQuestionLE(question: String, correct_mark: String, explanation: String, exam_id: String, teacher_id: String, level: String)
    case updateEssayQuestionLE(id: String, question: String, correct_answer: String)
    case updateMcqQuestionLE(id: String, question: String, choice1: String, choice2: String,
        choise3: String, choise4: String, correct_answer: String, level: String)
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
    case selectOnGoingExamsLE(teacher_id: String, level: String)
    
}

extension QLearnAPI: TargetType {
    
    public var baseURL: URL {
        switch self {
        default: return URL(string: "https://vmi448785.contaboserver.net/~qlearn/qlearn/api/")!
        }
    }
    
    public var path: String {
        switch self {
        // MARK: Select Teachers APIs
        case .insertStudentTeacherRequest: return "insert_stu_teacher_request.php"
            
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
        case .selectOnGoingExamsLE: return "select_ongoin_exams"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .insertEssayQuestionLE, .insertMcqQuestionLE, .insertTFQuestionLE,
             .updateEssayQuestionLE, .updateMcqQuestionLE, .updateTFQuestionLE, .insertStudentTeacherRequest: return .post
        default: return .get
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        switch self {
        // MARK: Select Teachers APIs
        case .insertStudentTeacherRequest(stuID: let studentId, teacher_id: let teacherId):
            return .requestParameters(parameters: ["stuID" : studentId, "teacher_id" : teacherId], encoding: URLEncoding.queryString)
            
        // MARK: Live Exam APIs
        case .insertEssayQuestionLE(question: let question, correct_answer: let correctAnswer, essay_type: let essayType, exam_id: let examId, teacher_id: let teacherId, level: let level) :
            return .requestParameters(parameters: ["question" : question, "correct_answer" : correctAnswer, "essay_type" : essayType, "exam_id" : examId, "teacher_id" : teacherId, "level" : level], encoding: URLEncoding.queryString)
            
        case .insertMcqQuestionLE(question: let question, choice1: let choice1, choice2: let choice2, choice3: let choice3, choice4: let choice4, correct_answer: let correctAnswer, exam_id: let examId, teacher_id: let teacherId, level: let level) :
            return .requestParameters(parameters: ["question" : question, "choice1" : choice1, "choice2" : choice2, "choice3" : choice3, "choice4" : choice4,"correct_answer" : correctAnswer, "exam_id" : examId, "teacher_id" : teacherId, "level" : level], encoding: URLEncoding.queryString)
            
        case .insertTFQuestionLE(question: let question, correct_mark: let correctMark, explanation: let explanation, exam_id: let examId, teacher_id: let teacherId, level: let level) :
            return .requestParameters(parameters: ["question" : question, "correct_mak" : correctMark,"explanation" : explanation, "exam_id" : examId, "teacher_id" : teacherId, "level" : level], encoding: URLEncoding.queryString)
            
        case .updateEssayQuestionLE(id: let id, question: let question, correct_answer: let correctAnswer) :
            return .requestParameters(parameters: ["id" : id, "question" : question, "correct_answer" : correctAnswer], encoding: URLEncoding.queryString)
            
        case . updateMcqQuestionLE(id: let id, question: let question, choice1: let choice1, choice2: let choice2, choise3: let choice3, choise4: let choice4, correct_answer: let correctAnswer, level: let level) :
            return .requestParameters(parameters: ["id" : id, "question" : question, "choice1" : choice1, "choice2" : choice2, "choice3" : choice3, "choice4" : choice4 ,"correct_answer" : correctAnswer, "level" : level], encoding: URLEncoding.queryString)
            
        case .updateTFQuestionLE(id: let id, question: let question, correct_answer: let correctAnswer, explanation: let explanation) :
            return .requestParameters(parameters: ["id" : id, "question" : question, "correct_answer" : correctAnswer, "explanation" : explanation], encoding: URLEncoding.queryString)
            
        case .deleteLEQuestion(id: let id, q_type: let questionType) :
            return .requestParameters(parameters: ["id" : id, "q_type" : questionType], encoding: URLEncoding.queryString)
            
        case .selectExam(id: let id) :
            return .requestParameters(parameters: ["id" : id], encoding: URLEncoding.queryString)
            
        case .selectAllLEQuestions(level: let level, teacher_id: let teacherId, q_type: let qType) :
            return .requestParameters(parameters: ["level" : level, "teacher_id" : teacherId, "q_type" : qType], encoding: URLEncoding.queryString)
            
        case .selectAnswerdEssayQuestionsLE(exam_id: let examId, teacher_id: let teacherId, student_id: let studentId, level: let level) :
            return .requestParameters(parameters: ["exam_id" : examId, "teacher_id" : teacherId, "student_id" : studentId, "level" : level], encoding: URLEncoding.queryString)
            
        case .selectAnswerMcqQuestionsLE(exam_id: let examId, teacher_id: let teacherId, student_id: let studentId, level: let level) :
            return .requestParameters(parameters: ["exam_id" : examId, "teacher_id" : teacherId, "student_id" : studentId, "level" : level], encoding: URLEncoding.queryString)
            
        case .selectAnswerdTFQuestionsLE(exam_id: let examId, teacher_id: let teacherId, student_id: let studentId, level: let level) :
            return .requestParameters(parameters: ["exam_id" : examId, "teacher_id" : teacherId, "student_id" : studentId, "level" : level], encoding: URLEncoding.queryString)
            
        case .selectCountOfQuestionsLE(teacher_id: let teacherId, level: let level) :
            return .requestParameters(parameters: ["teacher_id" : teacherId, "level" : level], encoding: URLEncoding.queryString)
            
        case .selectNotAnswerdEssayQuestionsLE(exam_id: let examId, teacher_id: let teacherId, student_id: let studentId, level: let level) :
            return .requestParameters(parameters: ["exam_id" : examId, "teacher_id" : teacherId, "student_id" : studentId, "level" : level], encoding: URLEncoding.queryString)
            
        case .selectNotAnswerdMcqQuestionsLE(exam_id: let examId, teacher_id: let teacherId, student_id: let studentId, level: let level) :
            return .requestParameters(parameters: ["exam_id" : examId, "teacher_id" : teacherId, "student_id" : studentId, "level" : level], encoding: URLEncoding.queryString)
            
        case .selectNotAnswerdTFQuestionsLE(exam_id: let examId, teacher_id: let teacherId, student_id: let studentId, level: let level) :
            return .requestParameters(parameters: ["exam_id" : examId, "teacher_id" : teacherId, "student_id" : studentId, "level" : level], encoding: URLEncoding.queryString)
        case .selectOnGoingExamsLE(teacher_id: let teacherId, level: let level) :
            return .requestParameters(parameters: ["teacher_id" : teacherId, "level" : level], encoding: URLEncoding.queryString)
        default :
            return .requestPlain
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
