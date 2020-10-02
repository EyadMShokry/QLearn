//
//  Admin.swift
//  El-Khateeb
//
//  Created by Abdalah on 10/1/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import Foundation

class Admin:SchoolUser{
    
    func getTeacher(completion: @escaping(_ result: TeacherDrobMenu?, _ error: NSError?) -> Void) {
        Client.shared().selectTeacher() {(data, error) in
            if let teacher = data {
                completion(teacher, nil)
            }
            else if let error = error {
                completion(nil, error)
            }
        }
    }
    
    func getAllNews(completion: @escaping(_ result: AllNews?, _ error: NSError?) -> Void) {
        Client.shared().selectAllNews() {(data, error) in
            if let news = data {
                completion(news, nil)
            }
            else if let error = error {
                completion(nil, error)
            }
        }
    }
    
    func getPdfCategories(parameters: [String : AnyObject], completion: @escaping(_ result: PDFCategories?, _ error: NSError?) -> Void) {
        Client.shared().selectPdfCategories(parameters: parameters) {(data, error) in
            if let categories = data {
                completion(categories, nil)
            }
            else if let error = error {
                completion(nil, error)
            }
        }
    }
    
    func getStudentsQuestion(completion: @escaping(_ result: Questions?, _ error: NSError?) -> Void) {
        Client.shared().selectStudentsQuestion() {(data, error) in
            if let question = data {
                completion(question, nil)
            }
            else if let error = error {
                completion(nil, error)
            }
        }
    }

    func login(parameters: [String : AnyObject], completion: @escaping(_ result: AdminLogin?, _ error: NSError?) -> Void) {
        Client.shared().loginAdmin(parameters: parameters) {(data, error) in
            if let admin = data {
                completion(admin, nil)
            }
            else if let error = error {
                completion(nil, error)
            }
        }
    }

    func insertAddress(parameters: [String : AnyObject], completion: @escaping(_ result: String?, _ error: NSError?) -> Void) {
        Client.shared().insertOrDeleteRequest(method: "insert_address.php", parameters: parameters) {(data, error) in
            if let response = data {
                completion(response, nil)
            }
            else if let error = error {
                completion(nil, error)
            }
        }
    }
    
    func insertAchievement(parameters: [String : AnyObject], completion: @escaping(_ result: String?, _ error: NSError?) -> Void) {
        Client.shared().insertOrDeleteRequest(method: "insert_achievements.php", parameters: parameters) {(data, error) in
            if let response = data {
                completion(response, nil)
            }
            else if let error = error {
                completion(nil, error)
            }
        }
    }
    
    func insertCategory(parameters: [String : AnyObject], completion: @escaping(_ result: String?, _ error: NSError?) -> Void) {
        Client.shared().insertOrDeleteRequest(method: "insert_pdf_category.php", parameters: parameters) {(data, error) in
            if let response = data {
                completion(response, nil)
            }
            else if let error = error {
                completion(nil, error)
            }
        }
    }
    
    func insertChapter(parameters: [String : AnyObject], completion: @escaping(_ result: String?, _ error: NSError?) -> Void) {
        Client.shared().insertOrDeleteRequest(method: "insert_chapter.php", parameters: parameters) {(data, error) in
            if let response = data {
                completion(response, nil)
            }
            else if let error = error {
                completion(nil, error)
            }
        }
    }
    
    func insertStudent(parameters: [String : AnyObject], completion: @escaping(_ result: String?, _ error: NSError?) -> Void) {
        Client.shared().insertOrDeleteRequest(method: "insert_student.php", parameters: parameters) {(data, error) in
            if let response = data {
                completion(response, nil)
            }
            else if let error = error {
                completion(nil, error)
            }
        }
    }
    
    func insertEssayQuestion(parameters: [String : AnyObject], completion: @escaping(_ result: String?, _ error: NSError?) -> Void) {
        Client.shared().insertOrDeleteRequest(method: "insert_Essay_question_to_bank.php", parameters: parameters) {(data, error) in
            if let response = data {
                completion(response, nil)
            }
            else if let error = error {
                completion(nil, error)
            }
        }
    }
  
    func insertEssayType(parameters: [String : AnyObject], completion: @escaping(_ result: String?, _ error: NSError?) -> Void) {
        Client.shared().insertOrDeleteRequest(method: "insert_essay_type.php", parameters: parameters) {(data, error) in
            if let response = data {
                completion(response, nil)
            }
            else if let error = error {
                completion(nil, error)
            }
        }
    }
    
    func insertMcqQuestion(parameters: [String : AnyObject], completion: @escaping(_ result: String?, _ error: NSError?) -> Void) {
        Client.shared().insertOrDeleteRequest(method: "insert_MCQ_question_to_bank.php", parameters: parameters) {(data, error) in
            if let response = data {
                completion(response, nil)
            }
            else if let error = error {
                completion(nil, error)
            }
        }
    }
    func insertTFQuestion(parameters: [String : AnyObject], completion: @escaping(_ result: String?, _ error: NSError?) -> Void) {
        Client.shared().insertOrDeleteRequest(method: "insert_TrueFalse_question_to_bank.php", parameters: parameters) {(data, error) in
            if let response = data {
                completion(response, nil)
            }
            else if let error = error {
                completion(nil, error)
            }
        }
    }

    
    func insertNews(parameters: [String : AnyObject], completion: @escaping(_ result: String?, _ error: NSError?) -> Void) {
        Client.shared().insertOrDeleteRequest(method: "insert_news.php", parameters: parameters) {(data, error) in
            if let response = data {
                completion(response, nil)
            }
            else if let error = error {
                completion(nil, error)
            }
        }
    }
    
    func insertPdf(parameters: [String : AnyObject], completion: @escaping(_ result: String?, _ error: NSError?) -> Void) {
        Client.shared().insertOrDeleteRequest(method: "insert_pdf.php", parameters: parameters) {(data, error) in
            if let response = data {
                completion(response, nil)
            }
            else if let error = error {
                completion(nil, error)
            }
        }
    }
    
    func insertPhone(parameters: [String : AnyObject], completion: @escaping(_ result: String?, _ error: NSError?) -> Void) {
        Client.shared().insertOrDeleteRequest(method: "insert_phone.php", parameters: parameters) {(data, error) in
            if let response = data {
                completion(response, nil)
            }
            else if let error = error {
                completion(nil, error)
            }
        }
    }
    
    func insertTeacher(parameters: [String : AnyObject], completion: @escaping(_ result: String?, _ error: NSError?) -> Void) {
        Client.shared().insertOrDeleteRequest(method: "insert_teacher.php", parameters: parameters) {(data, error) in
            if let response = data {
                completion(response, nil)
            }
            else if let error = error {
                completion(nil, error)
            }
        }
    }
    
    func updateTeacher(parameters: [String : AnyObject], completion: @escaping(_ result: String?, _ error: NSError?) -> Void) {
        Client.shared().insertOrDeleteRequest(method: "update_teacher.php", parameters: parameters) { (data, error) in
            if let response = data {
                completion(response, nil)
            }
            else if let error = error {
                completion(nil, error)
            }
        }
    }
    
    func insertTeacherInfo(parameters: [String : AnyObject], completion: @escaping(_ result: String?, _ error: NSError?) -> Void) {
        Client.shared().insertOrDeleteRequest(method: "insert_teacher_info.php", parameters: parameters) {(data, error) in
            if let response = data {
                completion(response, nil)
            }
            else if let error = error {
                completion(nil, error)
            }
        }
    }
    
    func insertQuestionAnswer(parameters: [String : AnyObject], completion: @escaping(_ result: String?, _ error: NSError?) -> Void) {
        Client.shared().insertOrDeleteRequest(method: "insert_answer_question.php", parameters: parameters) { (data, error) in
            if let response = data {
                completion(response, nil)
            }
            else if let error = error {
                completion(nil, error)
            }
        }
    }
    
    func insertAdmin(parameters: [String : AnyObject], completion: @escaping(_ result: String?, _ error: NSError?) -> Void) {
        Client.shared().insertOrDeleteRequest(method: "insert_admin.php", parameters: parameters) { (data, error) in
            if let response = data {
                completion(response, nil)
            }
            else if let error = error {
                completion(nil, error)
            }
        }
    }

    
    func deleteNews(parameters: [String : AnyObject], completion: @escaping(_ result: String?, _ error: NSError?) -> Void) {
        Client.shared().insertOrDeleteRequest(method: "delete_news.php", parameters: parameters) {(data, error) in
            if let response = data {
                completion(response, nil)
            }
            else if let error = error {
                completion(nil, error)
            }
        }
    }
    //delete_pdf.php
    func deletePds(parameters: [String : AnyObject], completion: @escaping(_ result: String?, _ error: NSError?) -> Void) {
        Client.shared().insertOrDeleteRequest(method: "delete_pdf.php", parameters: parameters) {(data, error) in
            if let response = data {
                completion(response, nil)
            }
            else if let error = error {
                completion(nil, error)
            }
        }
    }
    //delete_phone.php
    func deletePhone(parameters: [String : AnyObject], completion: @escaping(_ result: String?, _ error: NSError?) -> Void) {
        Client.shared().insertOrDeleteRequest(method: "delete_phone.php", parameters: parameters) {(data, error) in
            if let response = data {
                completion(response, nil)
            }
            else if let error = error {
                completion(nil, error)
            }
        }
    }
    func deleteAddress(parameters: [String : AnyObject], completion: @escaping(_ result: String?, _ error: NSError?) -> Void) {
        Client.shared().insertOrDeleteRequest(method: "delete_address.php", parameters: parameters) {(data, error) in
            if let response = data {
                completion(response, nil)
            }
            else if let error = error {
                completion(nil, error)
            }
        }
    }
   
    func deleteTeacher(parameters: [String : AnyObject], completion: @escaping(_ result: String?, _ error: NSError?) -> Void) {
        Client.shared().insertOrDeleteRequest(method: "delete_teacher.php", parameters: parameters) {(data, error) in
            if let response = data {
                completion(response, nil)
            }
            else if let error = error {
                completion(nil, error)
            }
        }
    }
    
    func deleteAchievement(parameters: [String : AnyObject], completion: @escaping(_ result: String?, _ error: NSError?) -> Void) {
        Client.shared().insertOrDeleteRequest(method: "delete_achievement.php", parameters: parameters) {(data, error) in
            if let response = data {
                completion(response, nil)
            }
            else if let error = error {
                completion(nil, error)
            }
        }
    }
    
    //mark-: ///////////////////////////delet Questions /////////
    func deleteEssayQuestions(parameters: [String : AnyObject], completion: @escaping(_ result: String?, _ error: NSError?) -> Void) {
        Client.shared().insertOrDeleteRequest(method: "", parameters: parameters) {(data, error) in
            if let response = data {
                completion(response, nil)
            }
            else if let error = error {
                completion(nil, error)
            }
        }
    }
    
    func deleteMcqQuestions(parameters: [String : AnyObject], completion: @escaping(_ result: String?, _ error: NSError?) -> Void) {
        Client.shared().insertOrDeleteRequest(method: "delete_mcq_question.php", parameters: parameters) {(data, error) in
            if let response = data {
                completion(response, nil)
            }
            else if let error = error {
                completion(nil, error)
            }
        }
    }
    
    func deleteTrueFalseQuestions(parameters: [String : AnyObject], completion: @escaping(_ result: String?, _ error: NSError?) -> Void) {
        Client.shared().insertOrDeleteRequest(method: "", parameters: parameters) {(data, error) in
            if let response = data {
                completion(response, nil)
            }
            else if let error = error {
                completion(nil, error)
            }
        }
    }
    
    
    
    func selectAllEssayQuestions(parameters: [String : AnyObject], completion: @escaping(_ result: FullQuestion?, _ error: NSError?) -> Void) {
        Client.shared().selectAllQuestion(method: "select_all_essay_questions.php") {(data, error) in
            if let response = data {
                completion(response, nil)
            }
            else if let error = error {
                completion(nil, error)
            }
        }
    }
    
    func selectAllMcqQuestions(parameters: [String : AnyObject], completion: @escaping(_ result: FullQuestion?, _ error: NSError?) -> Void) {
        Client.shared().selectAllQuestion(method: "select_all_mcq_questions.php") {(data, error) in
            if let response = data {
                completion(response, nil)
            }
            else if let error = error {
                completion(nil, error)
            }
        }
    }
    
    func selectAllTrueFalseQuestions(parameters: [String : AnyObject], completion: @escaping(_ result: FullQuestion?, _ error: NSError?) -> Void) {
        Client.shared().selectAllQuestion(method: "select_all_trueFalse_questions.php") {(data, error) in
            if let response = data {
                completion(response, nil)
            }
            else if let error = error {
                completion(nil, error)
            }
        }
    }

    func updataTrueFalseQuestions(parameters: [String : AnyObject], completion: @escaping(_ result: String?, _ error: NSError?) -> Void) {
        Client.shared().updateRequest(method: "update_trueFalse_question.php", parameters: parameters) {(data, error) in
            if let response = data {
                completion(response, nil)
            }
            else if let error = error {
                completion(nil, error)
            }
        }
    }
    
    func updateMcqQuestions(parameters: [String : AnyObject], completion: @escaping(_ result: String?, _ error: NSError?) -> Void) {
        Client.shared().updateRequest(method: "update_mcq_question.php", parameters: parameters) {(data, error) in
            if let response = data {
                completion(response, nil)
            }
            else if let error = error {
                completion(nil, error)
            }
        }
    }
    
    func updateEssayQuestions(parameters: [String : AnyObject], completion: @escaping(_ result: String?, _ error: NSError?) -> Void) {
        Client.shared().updateRequest(method: "update_essay_question.php", parameters: parameters) {(data, error) in
            if let response = data {
                completion(response, nil)
            }
            else if let error = error {
                completion(nil, error)
            }
        }
    }
    
    func updateTeacherInfo(parameters: [String : AnyObject], completion: @escaping(_ result: String?, _ error: NSError?) -> Void) {
        Client.shared().updateRequest(method: "update_teacher_info.php", parameters: parameters) { (data, error) in
            if let response = data {
                completion(response, nil)
            }
            else if let error = error {
                completion(nil, error)
            }
        }
    }
    
    func updateAchievement(parameters: [String : AnyObject], completion: @escaping(_ result: String?, _ error: NSError?) -> Void) {
        Client.shared().updateRequest(method: "update_achievement.php", parameters: parameters) { (data, error) in
            if let response = data {
                completion(response, nil)
            }
            else if let error = error {
                completion(nil, error)
            }
        }
    }
    
    func updatePhoneNumber(parameters: [String : AnyObject], completion: @escaping(_ result: String?, _ error: NSError?) -> Void) {
        Client.shared().updateRequest(method: "update_phone.php", parameters: parameters) { (data, error) in
            if let response = data {
                completion(response, nil)
            }
            else if let error = error {
                completion(nil, error)
            }
        }
    }
    
    func updateAddress(parameters: [String : AnyObject], completion: @escaping(_ result: String?, _ error: NSError?) -> Void) {
        Client.shared().updateRequest(method: "update_address.php", parameters: parameters) { (data, error) in
            if let response = data {
                completion(response, nil)
            }
            else if let error = error {
                completion(nil, error)
            }
        }
    }
    
    func updateChapter(parameters: [String : AnyObject], completion: @escaping(_ result: String?, _ error: NSError?) -> Void) {
        Client.shared().updateRequest(method: "update_chapter.php", parameters: parameters) { (data, error) in
            if let response = data {
                completion(response, nil)
            }
            else if let error = error {
                completion(nil, error)
            }
        }
    }
}
