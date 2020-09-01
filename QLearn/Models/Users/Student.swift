//
//  Student.swift
//  El-Khateeb
//
//  Created by Eyad Shokry on 9/27/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import Foundation

class Student: SchoolUser {    
    
    func getPdfCategories(completion: @escaping(_ result: PDFCategories?, _ error: NSError?) -> Void) {
        Client.shared().selectPdfCategories() {(data, error) in
            if let categories = data {
                completion(categories, nil)
            }
            else if let error = error {
                completion(nil, error)
            }
        }
    }
    
    func getPdfs(parameters: [String : AnyObject], completion: @escaping(_ result: PDFs?, _ error: NSError?) -> Void) {
        Client.shared().selectPDFs(parameters: parameters) {(data, error) in
            if let pdfs = data {
                completion(pdfs, nil)
            }
            else if let error = error {
                completion(nil, error)
            }
        }
    }
    
    func getStudentQuestions(parameters: [String : AnyObject], completion: @escaping(_ result: Questions?, _ error: NSError?) -> Void) {
        Client.shared().selectStudentAskedQuestions(parameters: parameters) {(data, error) in
            if let questions = data {
                completion(questions, nil)
            }
            else if let error = error {
                completion(nil, error)
            }
        }
    }
    
    func getChapterAskedQuestions(parameters: [String : AnyObject], completion: @escaping(_ result: Questions?, _ error: NSError?) -> Void) {
        Client.shared().selectChapterAskedQuestions(parameters: parameters) {(data, error) in
            if let questions = data {
                completion(questions, nil)
            }
            else if let error = error {
                completion(nil, error)
            }
        }
    }
    
    func postAskQuestion(parameters: [String : AnyObject], completion: @escaping(_ result: String?, _ error: NSError?) -> Void) {
        Client.shared().insertOrDeleteRequest(method: "insert_ask_question.php", parameters: parameters) {(data, error) in
            if let response = data {
                completion(response, nil)
            }
            else if let error = error {
                completion(nil, error)
            }
        }
    }
    
    func getQuestionsCount(completion: @escaping(_ result: QuestionsCount?, _ error: NSError?) -> Void) {
        Client.shared().select_countOfAll_questions() {(data, error) in
            if let questionsCount = data {
                completion(questionsCount, nil)
            }
            else if let error = error {
                completion(nil, error)
            }
        }
    }
    
    func getRightAnswersCount(parameters: [String : AnyObject], completion: @escaping(_ result: RightAnswers?, _ error: NSError?) -> Void) {
        Client.shared().selectCountOfRightAnswers(parameters: parameters) {(data, error) in
            if let rightAnswers = data {
                completion(rightAnswers, nil)
            }
            else if let error = error {
                completion(nil, error)
            }
        }
    }
    
    func login(parameters: [String : AnyObject], completion: @escaping(_ result: StudentLogin?, _ error: NSError?) -> Void) {
        Client.shared().loginStudent(parameters: parameters) {(data, error) in
            if let student = data {
                completion(student, nil)
            }
            else if let error = error {
                completion(nil, error)
            }
        }
    }
//    func registerStudent(parameters: [String : AnyObject], completion: @escaping(_ result: StudentLogin?, _ error: NSError?) -> Void) {
//        Client.shared().RegistreStudent(parameters: parameters) {(data, error) in
//            if let student = data {
//                completion(student, nil)
//            }
//            else if let error = error {
//                completion(nil, error)
//            }
//        }
//    }

   
    func getAnsweredQuestions(method: String, parameters: [String : AnyObject], completion: @escaping(_ result: FullQuestion?, _ error: NSError?) -> Void) {
        Client.shared().selectAnswerdQuestions(method: method, parameters: parameters) {(data, error) in
            if let answeredQuestions = data {
                completion(answeredQuestions, nil)
            }
            else if let error = error {
                completion(nil, error)
            }
        }
    }
    
    func getNotAnsweredQuestions(method: String, parameters: [String : AnyObject], completion: @escaping(_ result: FullQuestion?, _ error: NSError?) -> Void) {
        Client.shared().selectNotAnsweredQuestion(method: method, parameters: parameters) {(questions, error) in
            if let notAnsweredQuestions = questions {
                completion(notAnsweredQuestions, nil)
            }
            else if let error = error {
                completion(nil, error)
            }
        }
    }
    
    func insertAnswerWithType(method: String, parameters: [String : AnyObject], completion: @escaping(_ result: String?, _ error: NSError?) -> Void) {
        Client.shared().insertAnswerWithType(method: method, parameters: parameters) {(data, error) in
            if let data = data {
                completion(data, nil)
            }
            else if let error = error {
                completion(nil, error)
            }
        }
    }
    
    func getStudentByPhone(parameters: [String : AnyObject], completion: @escaping(_ result: StudentLogin?, _ error: NSError?) -> Void) {
        Client.shared().selectStudentByPhone(parameters: parameters) { (student, error) in
            if let student = student {
                completion(student, nil)
            }
            else if let error = error {
                completion(nil, error)
            }
        }
    }
    
    func updatePassword(parameters: [String : AnyObject], completion: @escaping(_ result: String?, _ error: NSError?) -> Void) {
        Client.shared().updateStudentPassword(parameters: parameters) { (data, error) in
            if let data = data {
                completion(data, nil)
            }
            else if let error = error {
                completion(nil, error)
            }
        }
    }
    
    func getStudentLevels(parameters: [String : AnyObject], completion: @escaping(_ result: StudentLevel?, _ error: NSError?) -> Void) {
        Client.shared().getStudentLevels(parameters: parameters) { (studentLevel, error) in
            if let studentLevel = studentLevel {
                completion(studentLevel, nil)
            }
            else if let error = error {
                completion(nil, error)
            }
        }
    }
    
    func getStudentTeachers(parameters: [String : AnyObject], completion: @escaping(_ result: Teachers?, _ error: NSError?) -> Void) {
           Client.shared().getStudentTeachers(parameters: parameters) { (studentTeachers, error) in
               if let studentTeachers = studentTeachers {
                   completion(studentTeachers, nil)
               }
               else if let error = error {
                   completion(nil, error)
               }
           }
       }
    
}
