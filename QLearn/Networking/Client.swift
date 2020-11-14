//
//  Client.swift
//  El-Khateeb
//
//  Created by Eyad Shokry on 9/12/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import Foundation

class Client: NSObject {
    
    var session = URLSession.shared
    
    override init() {
        super.init()
    }
    
    class func shared() -> Client {
        struct Singleton {
            static var shared = Client()
        }
        return Singleton.shared
    }
    
    func selectLessonDates(parameters: [String : AnyObject], completionHandler: @escaping(_ result: LessonDate?, _ error: NSError?) -> Void) {
        _ = taskForPOSTMethod("select_lesson_dates_ios.php" ,parameters: parameters, bodyParameters: parameters) {(data, error) in
            if let error = error {
                completionHandler(nil, error)
                return
            }
            
            guard let data = data else {
                let userInfo = [NSLocalizedDescriptionKey : "Couldn't retrive data"]
                completionHandler(nil, NSError(domain: "taskForPOSTMethod", code: 1, userInfo: userInfo))
                return
            }
            
            do {
                let lessonDates = try JSONDecoder().decode(LessonDate.self, from: data)
                completionHandler(lessonDates, nil)
            }
            catch {
                completionHandler(nil, error as NSError)
            }
        }
    }
    
    func selectAddresses(parameters: [String : AnyObject], completionHandler: @escaping(_ result: Address?, _ error: NSError?) -> Void) {
        _ = taskForPOSTMethod("select_addresses_ios.php", parameters: parameters, bodyParameters: parameters) {(data, error) in
            if let error = error {
                completionHandler(nil, error)
                return
            }
            
            guard let data = data else {
                let userInfo = [NSLocalizedDescriptionKey : "Couldn't retrive data"]
                completionHandler(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
                return
            }
            
            do {
                let addresses = try JSONDecoder().decode(Address.self, from: data)
                completionHandler(addresses, nil)
            }
            catch {
                completionHandler(nil, error as NSError)
            }
        }
    }
    
    func selectPhoneNumbers(parameters: [String : AnyObject], completionHandler: @escaping(_ result: Phone?, _ error: NSError?) -> Void) {
        _ = taskForPOSTMethod("select_phones_ios.php", parameters: parameters, bodyParameters: parameters) {(data, error) in
            if let error = error {
                completionHandler(nil, error)
                return
            }
            
            guard let data = data else {
                let userInfo = [NSLocalizedDescriptionKey : "Couldn't retrive data"]
                completionHandler(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
                return
            }
            
            do {
                let phones = try JSONDecoder().decode(Phone.self, from: data)
                completionHandler(phones, nil)
            }
            catch {
                completionHandler(nil, error as NSError)
            }
        }
    }
    
    func selectTeacherFullName(completionHandler: @escaping(_ result: TeacherName?, _ error: NSError?) -> Void) {
        _ = taskForGETMethod("select_teacher_full_name.php", parameters: [:]) {(data, error) in
            if let error = error {
                completionHandler(nil, error)
                return
            }
            
            guard let data = data else {
                let userInfo = [NSLocalizedDescriptionKey : "Couldn't retrive data"]
                completionHandler(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
                return
            }
            
            do {
                let teacherName = try JSONDecoder().decode(TeacherName.self, from: data)
                completionHandler(teacherName, nil)
            }
            catch {
                completionHandler(nil, error as NSError)
            }
        }
    }
    
    func selectPdfCategories(parameters: [String : AnyObject], completionHandler: @escaping(_ result: PDFCategories?, _ error: NSError?) -> Void) {
        _ = taskForPOSTMethod("select_pdf_categories_ios.php", parameters: parameters, bodyParameters: parameters) {(data, error) in
            if let error = error {
                completionHandler(nil, error)
                return
            }
            
            guard let data = data else {
                let userInfo = [NSLocalizedDescriptionKey : "Couldn't retrive data"]
                completionHandler(nil, NSError(domain: "taskForPOSTMethod", code: 1, userInfo: userInfo))
                return
            }
            
            do {
                let categories = try JSONDecoder().decode(PDFCategories.self, from: data)
                completionHandler(categories, nil)
            }
            catch {
                completionHandler(nil, error as NSError)
            }
        }
    }
    
    func selectPDFs(parameters: [String : AnyObject], completionHandler: @escaping(_ result: PDFs?, _ error: NSError?) -> Void) {
        _ = taskForPOSTMethod("select_pdfs_ios.php", parameters: parameters, bodyParameters: parameters) {(data, error) in
            if let error = error {
                completionHandler(nil, error)
                return
            }
            
            guard let data = data else {
                let userInfo = [NSLocalizedDescriptionKey : "Couldn't retrive data"]
                completionHandler(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
                return
            }
            
            do {
                let pdfs = try JSONDecoder().decode(PDFs.self, from: data)
                completionHandler(pdfs, nil)
            }
            catch {
                completionHandler(nil, error as NSError)
            }
        }
    }
    
    func selectAllChapters(parameters: [String : AnyObject], completionHandler: @escaping(_ result: Chapter?, _ error: NSError?) -> Void) {
        _ = taskForPOSTMethod("select_chapter_ios.php", parameters: parameters, bodyParameters: parameters) {(data, error) in
            if let error = error {
                completionHandler(nil, error)
                return
            }
            
            guard let data = data else {
                let userInfo = [NSLocalizedDescriptionKey : "Couldn't retrive data"]
                completionHandler(nil, NSError(domain: "taskForPOSTMethod", code: 1, userInfo: userInfo))
                return
            }
            
            do {
                let chapters = try JSONDecoder().decode(Chapter.self, from: data)
                completionHandler(chapters, nil)
            }
            catch {
                completionHandler(nil, error as NSError)
            }
        }
    }
    
    func selectStudentAskedQuestions(parameters: [String : AnyObject], completionHandler: @escaping(_ result: Questions?, _ error: NSError?) -> Void) {
        _ = taskForPOSTMethod("select_answered_ask_questions_by_student_ios.php", parameters: [:], bodyParameters: parameters) {(data, error) in
            if let error = error {
                completionHandler(nil, error)
                return
            }
            
            guard let data = data else {
                let userInfo = [NSLocalizedDescriptionKey : "Couldn't retrive data"]
                completionHandler(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
                return
            }
            
            do {
                let questions = try JSONDecoder().decode(Questions.self, from: data)
                completionHandler(questions, nil)
            }
            catch {
                completionHandler(nil, error as NSError)
            }
        }
    }
    
    func selectChapterAskedQuestions(parameters: [String : AnyObject], completionHandler: @escaping(_ result: Questions?, _ error: NSError?) -> Void) {
        _ = taskForPOSTMethod("select_answered_ask_questions_by_chapter_ios.php", parameters: parameters, bodyParameters: parameters) {(data, error) in
            if let error = error {
                completionHandler(nil, error)
                return
            }
            
            guard let data = data else {
                let userInfo = [NSLocalizedDescriptionKey : "Couldn't retrive data"]
                completionHandler(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
                return
            }
            
            do {
                let questions = try JSONDecoder().decode(Questions.self, from: data)
                completionHandler(questions, nil)
            }
            catch {
                completionHandler(nil, error as NSError)
            }
        }
    }
    
 
    
    func selectChaptersInQuestions(pathExtension: String, parameters: [String : AnyObject], completionHandler: @escaping(_ result: Chapter?, _ error: NSError?) -> Void) {
        _ = taskForPOSTMethod(pathExtension, parameters: parameters, bodyParameters: parameters) {(data, error) in
            if let error = error {
                completionHandler(nil, error)
                return
            }
            
            guard let data = data else {
                let userInfo = [NSLocalizedDescriptionKey : "Couldn't retrive data"]
                completionHandler(nil, NSError(domain: "taskForPOSTMethod", code: 1, userInfo: userInfo))
                return
            }
            
            do {
                let chapters = try JSONDecoder().decode(Chapter.self, from: data)
                completionHandler(chapters, nil)
            }
            catch {
                completionHandler(nil, error as NSError)
            }
        }
    }
    
    func selectEssayTypes(parameters: [String : AnyObject], completionHandler: @escaping(_ result: PDFCategories?, _ error: NSError?) -> Void) {
        _ = taskForPOSTMethod("select_all_essay_type_ios.php", parameters: parameters, bodyParameters: parameters) {(data, error) in
            if let error = error {
                completionHandler(nil, error)
                return
            }
            
            guard let data = data else {
                let userInfo = [NSLocalizedDescriptionKey : "Couldn't retrive data"]
                completionHandler(nil, NSError(domain: "taskForPOSTMethod", code: 1, userInfo: userInfo))
                return
            }
            
            do {
                let essayTypes = try JSONDecoder().decode(PDFCategories.self, from: data)
                completionHandler(essayTypes, nil)
            }
            catch {
                completionHandler(nil, error as NSError)
            }
        }
    }
    
    
    func select_countOfAll_questions(completionHandler: @escaping(_ result: QuestionsCount?, _ error: NSError?) -> Void) {
        _ = taskForGETMethod("select_countOfAll_question_from_bank.php", parameters: [:]) {(data, error) in
            if let error = error {
                completionHandler(nil, error)
                return
            }
            
            guard let data = data else {
                let userInfo = [NSLocalizedDescriptionKey : "Couldn't retrive data"]
                completionHandler(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
                return
            }
            
            do {
                let questionsCount = try JSONDecoder().decode(QuestionsCount.self, from: data)
                completionHandler(questionsCount, nil)
            }
            catch {
                completionHandler(nil, error as NSError)
            }
        }

    }
    
    func selectCountOfRightAnswers(parameters: [String : AnyObject], completionHandler: @escaping(_ result: RightAnswers?, _ error: NSError?) -> Void) {
        _ = taskForPOSTMethod("select_count_of_right_answered_type_ios.php", parameters: [:], bodyParameters: parameters) {(data, error) in
            if let error = error {
                completionHandler(nil, error)
                return
            }
            
            guard let data = data else {
                let userInfo = [NSLocalizedDescriptionKey : "Couldn't retrive data"]
                completionHandler(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
                return
            }
            
            do {
                let rightAnswers = try JSONDecoder().decode(RightAnswers.self, from: data)
                completionHandler(rightAnswers, nil)
            }
            catch {
                completionHandler(nil, error as NSError)
            }
            
        }
    }
    
    
    func loginStudent(parameters: [String : AnyObject], completionHandler: @escaping(_ result: StudentLogin?, _ error: NSError?) -> Void) {
        _ = taskForPOSTMethod("student_login.php", parameters: [:], bodyParameters: parameters) {(data, error) in
            if let error = error {
                completionHandler(nil, error)
                return
            }
            
            guard let data = data else {
                let userInfo = [NSLocalizedDescriptionKey : "Couldn't retrive data"]
                completionHandler(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
                return
            }
            
            do {
                let student = try JSONDecoder().decode(StudentLogin.self, from: data)
                completionHandler(student, nil)
            }
            catch {
                completionHandler(nil, error as NSError)
            }
            
        }
    }
    
    func loginAdmin(parameters: [String : AnyObject], completionHandler: @escaping(_ result: AdminLogin?, _ error: NSError?) -> Void) {
        _ = taskForPOSTMethod("select_admins_ios.php", parameters: [:], bodyParameters: parameters) {(data, error) in
            if let error = error {
                completionHandler(nil, error)
                return
            }
        
            guard let data = data else {
                let userInfo = [NSLocalizedDescriptionKey : "Couldn't retrive data"]
                completionHandler(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
                return
            }
        
            do {
                let admin = try JSONDecoder().decode(AdminLogin.self, from: data)
                completionHandler(admin, nil)
            }
            catch {
                completionHandler(nil, error as NSError)
            }
        }
    }
    
    func loginParent(parameters: [String : AnyObject], completionHandler: @escaping(_ result: StudentLogin?, _ error: NSError?) -> Void) {
        _ = taskForPOSTMethod("select_parent_ios.php", parameters: [:], bodyParameters: parameters) {(data, error) in
            if let error = error {
                completionHandler(nil, error)
                return
            }
            
            guard let data = data else {
                let userInfo = [NSLocalizedDescriptionKey : "Couldn't retrive data"]
                completionHandler(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
                return
            }
            
            do {
                let parent = try JSONDecoder().decode(StudentLogin.self, from: data)
                completionHandler(parent, nil)
            }
            catch {
                completionHandler(nil, error as NSError)
            }
        }
    }
    
    func registerUser(method: String, parameters: [String : AnyObject], completionHandler: @escaping(_ result: String?, _ error: NSError?) -> Void) {
        _ = taskForPOSTMethod(method, parameters: [:], bodyParameters: parameters) {(data, error) in
            if let error = error {
                completionHandler(nil, error)
                return
            }
            
            guard let data = data else {
                let userInfo = [NSLocalizedDescriptionKey : "Couldn't retrive data"]
                completionHandler(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
                return
            }
            
            let response = data
            completionHandler(String(data: response, encoding: .utf8), nil)
        }
    }
    
    func insertOrDeleteRequest(method: String, parameters: [String : AnyObject], completionHandler: @escaping(_ result: String?, _ error: NSError?) -> Void) {
        _ = taskForPOSTMethod(method, parameters: [:], bodyParameters: parameters) {(data, error) in
            if let error = error {
                completionHandler(nil, error)
                return
            }
            
            guard let data = data else {
                let userInfo = [NSLocalizedDescriptionKey : "Couldn't retrive data"]
                completionHandler(nil, NSError(domain: "taskForPOSTMethod", code: 1, userInfo: userInfo))
                return
            }
            
            let response = data
            completionHandler(String(data: response, encoding: .utf8), nil)
        }
    }
    
    func selectAllNews(parameters: [String : AnyObject], completionHandler: @escaping(_ result: AllNews?, _ error: NSError?) -> Void) {
        _ = taskForPOSTMethod("select_all_news_ios.php", parameters: [:], bodyParameters: parameters) {(data, error) in
            if let error = error {
                completionHandler(nil, error)
                return
            }
            
            guard let data = data else {
                let userInfo = [NSLocalizedDescriptionKey : "Couldn't retrive data"]
                completionHandler(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
                return
            }
            
            
            do {
                let allNews = try JSONDecoder().decode(AllNews.self, from: data)
                completionHandler(allNews, nil)
            }
            catch {
                completionHandler(nil, error as NSError)
            }
        }
    }
    
    func selectUnexpiredNews(parameters: [String : AnyObject], completionHandler: @escaping(_ result: AllNews?, _ error: NSError?) -> Void) {
        _ = taskForPOSTMethod("select_unexpired_news_ios.php", parameters: [:], bodyParameters: parameters) {(data, error) in
            if let error = error {
                completionHandler(nil, error)
                return
            }
            
            guard let data = data else {
                let userInfo = [NSLocalizedDescriptionKey : "Couldn't retrive data"]
                completionHandler(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
                return
            }
            
            
            do {
                let unexpiredNews = try JSONDecoder().decode(AllNews.self, from: data)
                completionHandler(unexpiredNews, nil)
                
            }
            catch {
                completionHandler(nil, error as NSError)
            }
        }
    }
    //select_teacher.php
    func selectTeacher(parameters: [String : AnyObject], completionHandler: @escaping(_ result: TeacherDrobMenu?, _ error: NSError?) -> Void) {
        _ = taskForPOSTMethod("select_teacher_assistants_ios.php", parameters: [:], bodyParameters: parameters) {(data, error) in
            if let error = error {
                completionHandler(nil, error)
                return
            }
            
            guard let data = data else {
                let userInfo = [NSLocalizedDescriptionKey : "Couldn't retrive data"]
                completionHandler(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
                return
            }
            
            
            do {
                let teacher = try JSONDecoder().decode(TeacherDrobMenu.self, from: data)
                completionHandler(teacher, nil)
                
            }
            catch {
                completionHandler(nil, error as NSError)
            }
        }
    }
    
    func selectAnswerdQuestions(method: String, parameters: [String : AnyObject], completionHandler: @escaping(_ result: FullQuestion?, _ error: NSError?) -> Void) {
        _ = taskForPOSTMethod(method, parameters: [:], bodyParameters: parameters) {(data, error) in
            if let error = error {
                completionHandler(nil, error)
                return
            }
            
            guard let data = data else {
                let userInfo = [NSLocalizedDescriptionKey : "Couldn't retrive data"]
                completionHandler(nil, NSError(domain: "taskForPOSTMethod", code: 1, userInfo: userInfo))
                return
            }
            
            
            do {
                let answerdMcqQuestions = try JSONDecoder().decode(FullQuestion.self, from: data)
                completionHandler(answerdMcqQuestions, nil)
            }
            catch {
                completionHandler(nil, error as NSError)
            }
        }
    }
    
    func selectNotAnsweredQuestion(method: String, parameters: [String : AnyObject], completionHandler: @escaping(_ result: FullQuestion?, _ error: NSError?) -> Void) {
        _ = taskForPOSTMethod(method, parameters: [:], bodyParameters: parameters) {(data, error) in
            if let error = error {
                completionHandler(nil, error)
                return
            }
            
            guard let data = data else {
                let userInfo = [NSLocalizedDescriptionKey : "Couldn't retrive data"]
                completionHandler(nil, NSError(domain: "taskForPOSTMethod", code: 1, userInfo: userInfo))
                return
            }
            
            do {
                let notAnsweredQuestions = try JSONDecoder().decode(FullQuestion.self, from: data)
                completionHandler(notAnsweredQuestions, nil)
            }
            catch {
                print("d5l fl catch")
                completionHandler(nil, error as NSError)
            }
        }
    }
    
    func selectAchievements(parameters: [String : AnyObject], completionHandler: @escaping(_ result: Achievement?, _ error: NSError?) -> Void) {
        _ = taskForPOSTMethod("select_achievements_ios.php", parameters: parameters, bodyParameters: parameters) {(data, error) in
            if let error = error {
                completionHandler(nil, error)
                return
            }
            
            guard let data = data else {
                let userInfo = [NSLocalizedDescriptionKey : "Couldn't retrive data"]
                completionHandler(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
                return
            }
            
            do {
                let achievements = try JSONDecoder().decode(Achievement.self, from: data)
                completionHandler(achievements, nil)
            }
            catch {
                completionHandler(nil, error as NSError)
            }
        }
    }
    
    func selectTeacherInfo(parameters: [String : AnyObject], completionHandler: @escaping(_ result: TeacherInfo?, _ error: NSError?) -> Void) {
        _ = taskForPOSTMethod("select_teacher_info_ios.php", parameters: parameters, bodyParameters: parameters) {(data, error) in
            if let error = error {
                completionHandler(nil, error)
                return
            }
            
            guard let data = data else {
                let userInfo = [NSLocalizedDescriptionKey : "Couldn't retrive data"]
                completionHandler(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
                return
            }
            
            do {
                let teacherInfo = try JSONDecoder().decode(TeacherInfo.self, from: data)
                completionHandler(teacherInfo, nil)
            }
            catch {
                completionHandler(nil, error as NSError)
            }
        }
    }
    
    func selectAllQuestion(method:String, parameters: [String : AnyObject], completionHandler: @escaping(_ result: FullQuestion?, _ error: NSError?) -> Void) {
        _ = taskForPOSTMethod(method, parameters: [:], bodyParameters: parameters) {(data, error) in
            if let error = error {
                completionHandler(nil, error)
                return
            }
            
            guard let data = data else {
                let userInfo = [NSLocalizedDescriptionKey : "Couldn't retrive data"]
                completionHandler(nil, NSError(domain: "taskForPOSTMethod", code: 1, userInfo: userInfo))
                return
            }
            
            do {
                let question = try JSONDecoder().decode(FullQuestion.self, from: data)
                completionHandler(question, nil)
            }
            catch {
                completionHandler(nil, error as NSError)
            }
        }
    }

    func insertAnswerWithType(method: String, parameters: [String : AnyObject], completionHandler: @escaping(_ result: String?, _ error: NSError?) -> Void) {
        _ = taskForPOSTMethod(method, parameters: [:], bodyParameters: parameters) {(data, error) in
            if let error = error {
                completionHandler(nil, error)
                return
            }
            
            guard let data = data else {
                let userInfo = [NSLocalizedDescriptionKey : "Couldn't retrive data"]
                completionHandler(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
                return
            }
            
            let response = data
            completionHandler(String(data: response, encoding: .utf8), nil)

        }
    }
    
    func selectStudentsQuestion(parameters: [String : AnyObject], completionHandler: @escaping(_ result: Questions?, _ error: NSError?) -> Void) {
        _ = taskForPOSTMethod("select_not_answered_ask_questions_ios.php", parameters: [:], bodyParameters: parameters) {(data, error) in
            if let error = error {
                completionHandler(nil, error)
                return
            }
            
            guard let data = data else {
                let userInfo = [NSLocalizedDescriptionKey : "Couldn't retrive data"]
                completionHandler(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
                return
            }
            
            do {
                let questions = try JSONDecoder().decode(Questions.self, from: data)
                completionHandler(questions, nil)
            }
            catch {
                completionHandler(nil, error as NSError)
            }
        }
    }

    
    func updateRequest(method: String, parameters: [String : AnyObject], completionHandler: @escaping(_ result: String?, _ error: NSError?) -> Void) {
        _ = taskForPOSTMethod(method, parameters: [:], bodyParameters: parameters) {(data, error) in
            if let error = error {
                completionHandler(nil, error)
                return
            }
            
            guard let data = data else {
                let userInfo = [NSLocalizedDescriptionKey : "Couldn't retrive data"]
                completionHandler(nil, NSError(domain: "taskForPOSTMethod", code: 1, userInfo: userInfo))
                return
            }
            
            let response = data
            completionHandler(String(data: response, encoding: .utf8), nil)
            
        }
    }
  
    func selectStudentByPhone(parameters: [String : AnyObject], completionHandler: @escaping(_ result: StudentLogin?, _ error: NSError?) -> Void) {
        _ = taskForPOSTMethod("select_student_by_phone.php", parameters: [:], bodyParameters: parameters) {(data, error) in
            if let error = error {
                completionHandler(nil, error)
                return
            }
            
            guard let data = data else {
                let userInfo = [NSLocalizedDescriptionKey : "Couldn't retrive data"]
                completionHandler(nil, NSError(domain: "taskForPOSTMethod", code: 1, userInfo: userInfo))
                return
            }
            
            do {
                let student = try JSONDecoder().decode(StudentLogin.self, from: data)
                completionHandler(student, nil)
            }
            catch {
                completionHandler(nil, error as NSError)
            }
        }
    }
    
    func updateStudentPassword(parameters: [String : AnyObject], completionHandler: @escaping(_ result: String?, _ error: NSError?) -> Void) {
        _ = taskForPOSTMethod("update_student_password.php", parameters: [:], bodyParameters: parameters, completionHandlerForPOST: { (data, error) in
            if let error = error {
                completionHandler(nil, error)
                return
            }
            
            guard let data = data else {
                let userInfo = [NSLocalizedDescriptionKey : "Couldn't retrive data"]
                completionHandler(nil, NSError(domain: "taskForPOSTMethod", code: 1, userInfo: userInfo))
                return
            }
            
            let response = data
            completionHandler(String(data: response, encoding: .utf8), nil)

        })
    }
    
    func getStudentLevels(parameters: [String : AnyObject], completionHandler: @escaping(_ result: StudentLevel?, _ error: NSError?) -> Void) {
        _ = taskForPOSTMethod("select_levels.php", parameters: [:], bodyParameters: parameters, completionHandlerForPOST: { (data, error) in
            if let error = error {
                completionHandler(nil, error)
                return
            }
            
            guard let data = data else {
                let userInfo = [NSLocalizedDescriptionKey : "Couldn't retrive data"]
                completionHandler(nil, NSError(domain: "taskForPOSTMethod", code: 1, userInfo: userInfo))
                return
            }
            
            do {
                let levels = try JSONDecoder().decode(StudentLevel.self, from: data)
                completionHandler(levels, nil)
            }
            catch {
                completionHandler(nil, error as NSError)
            }

        })
    }
    
    func getStudentTeachers(parameters: [String : AnyObject], completionHandler: @escaping(_ result: Teachers?, _ error: NSError?) -> Void) {
        _ = taskForPOSTMethod("select_student_teachers_ios.php", parameters:parameters, bodyParameters: parameters, completionHandlerForPOST: { (data, error) in
            if let error = error {
                completionHandler(nil, error)
                return
            }
            
            guard let data = data else {
                let userInfo = [NSLocalizedDescriptionKey : "Couldn't retrive data"]
                completionHandler(nil, NSError(domain: "taskForPOSTMethod", code: 1, userInfo: userInfo))
                return
            }
            
            do {
                let teachers = try JSONDecoder().decode(Teachers.self, from: data)
                completionHandler(teachers, nil)
            }
            catch {
                completionHandler(nil, error as NSError)
            }

        })
    }

    func getOtherTeachers(parameters: [String : AnyObject], completionHandler: @escaping(_ result: Teachers?, _ error: NSError?) -> Void) {
        _ = taskForPOSTMethod("select_other_teachers_ios.php", parameters:parameters, bodyParameters: parameters, completionHandlerForPOST: { (data, error) in
            if let error = error {
                completionHandler(nil, error)
                return
            }
            
            guard let data = data else {
                let userInfo = [NSLocalizedDescriptionKey : "Couldn't retrive data"]
                completionHandler(nil, NSError(domain: "taskForPOSTMethod", code: 1, userInfo: userInfo))
                return
            }
            
            do {
                let teachers = try JSONDecoder().decode(Teachers.self, from: data)
                completionHandler(teachers, nil)
            }
            catch {
                completionHandler(nil, error as NSError)
            }

        })
    }
    
    func getTeacherCard(parameters: [String : AnyObject], completionHandler: @escaping(_ result: TeacherCard?, _ error: NSError?) -> Void) {
        _ = taskForPOSTMethod("select_teacher_card_ios.php", parameters:[:], bodyParameters: parameters, completionHandlerForPOST: { (data, error) in
            if let error = error {
                completionHandler(nil, error)
                return
            }
            
            guard let data = data else {
                let userInfo = [NSLocalizedDescriptionKey : "Couldn't retrive data"]
                completionHandler(nil, NSError(domain: "taskForPOSTMethod", code: 1, userInfo: userInfo))
                return
            }
            
            do {
                let teacherCard = try JSONDecoder().decode(TeacherCard.self, from: data)
                completionHandler(teacherCard, nil)
            }
            catch {
                completionHandler(nil, error as NSError)
            }

        })
    }
    func selectTeacherCard(parameters: [String : AnyObject], completionHandler: @escaping(_ result: TeacherCard?, _ error: NSError?) -> Void) {
        _ = taskForPOSTMethod("select_teacher_card_ios.php", parameters: [:], bodyParameters: parameters) {(data, error) in
            if let error = error {
                completionHandler(nil, error)
                return
            }
            
            guard let data = data else {
                let userInfo = [NSLocalizedDescriptionKey : "Couldn't retrive data"]
                completionHandler(nil, NSError(domain: "taskForPOSTMethod", code: 1, userInfo: userInfo))
                return
            }
            
            do {
                let teacherCard = try JSONDecoder().decode(TeacherCard.self, from: data)
                completionHandler(teacherCard, nil)
            }
            catch {
                completionHandler(nil, error as NSError)
            }
        }
    }
    
    func selectWeekGrades(parameters: [String : AnyObject], completionHandler: @escaping(_ result: MonthGrades?, _ error: NSError?) -> Void) {
        _ = taskForPOSTMethod("select_week_grades_ios.php", parameters: parameters, bodyParameters: parameters) {(data, error) in
            if let error = error {
                completionHandler(nil, error)
                return
            }
            
            guard let data = data else {
                let userInfo = [NSLocalizedDescriptionKey : "Couldn't retrive data"]
                completionHandler(nil, NSError(domain: "taskForPOSTMethod", code: 1, userInfo: userInfo))
                return
            }
            
            do {
                let monthGrades = try JSONDecoder().decode(MonthGrades.self, from: data)
                completionHandler(monthGrades, nil)
            }
            catch {
                completionHandler(nil, error as NSError)
            }
        }
    }
    
    func selectMonthGrades(parameters: [String : AnyObject], completionHandler: @escaping(_ result: MonthGrades?, _ error: NSError?) -> Void) {
        _ = taskForPOSTMethod("select_month_grades_ios.php", parameters: parameters, bodyParameters: parameters) {(data, error) in
            if let error = error {
                completionHandler(nil, error)
                return
            }
            
            guard let data = data else {
                let userInfo = [NSLocalizedDescriptionKey : "Couldn't retrive data"]
                completionHandler(nil, NSError(domain: "taskForPOSTMethod", code: 1, userInfo: userInfo))
                return
            }
            
            do {
                let monthGrades = try JSONDecoder().decode(MonthGrades.self, from: data)
                completionHandler(monthGrades, nil)
            }
            catch {
                completionHandler(nil, error as NSError)
            }
        }
    }
    
    func selectStudentAttendance(parameters: [String : AnyObject], completionHandler: @escaping(_ result: AttendanceResult?, _ error: NSError?) -> Void) {
        _ = taskForPOSTMethod("select_student_attendance.php", parameters: parameters, bodyParameters: parameters) {(data, error) in
            if let error = error {
                completionHandler(nil, error)
                return
            }
            
            guard let data = data else {
                let userInfo = [NSLocalizedDescriptionKey : "Couldn't retrive data"]
                completionHandler(nil, NSError(domain: "taskForPOSTMethod", code: 1, userInfo: userInfo))
                return
            }
            
            do {
                let attendance = try JSONDecoder().decode(AttendanceResult.self, from: data)
                completionHandler(attendance, nil)
            }
            catch {
                completionHandler(nil, error as NSError)
            }
        }
    }
    
    func selectIfActivatedAccount(parameters: [String : AnyObject], completionHandler: @escaping(_ result: IsActivated?, _ error: NSError?) -> Void) {
        _ = taskForPOSTMethod("select_if_activated_account_ios.php", parameters: parameters, bodyParameters: parameters) {(data, error) in
            if let error = error {
                completionHandler(nil, error)
                return
            }
            
            guard let data = data else {
                let userInfo = [NSLocalizedDescriptionKey : "Couldn't retrive data"]
                completionHandler(nil, NSError(domain: "taskForPOSTMethod", code: 1, userInfo: userInfo))
                return
            }
            
            do {
                let isActivated = try JSONDecoder().decode(IsActivated.self, from: data)
                completionHandler(isActivated, nil)
            }
            catch {
                completionHandler(nil, error as NSError)
            }
        }
    }
    
    func selectAdminMaxId(completionHandler: @escaping(_ result: AdminMaxId?, _ error: NSError?) -> Void) {
        _ = taskForGETMethod("select_admin_max_id.php", parameters: [:]) {(data, error) in
            if let error = error {
                completionHandler(nil, error)
                return
            }
            
            guard let data = data else {
                let userInfo = [NSLocalizedDescriptionKey : "Couldn't retrive data"]
                completionHandler(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
                return
            }
            
            do {
                let maxId = try JSONDecoder().decode(AdminMaxId.self, from: data)
                completionHandler(maxId, nil)
            }
            catch {
                completionHandler(nil, error as NSError)
            }
        }
    }
    
    func selectExternalLinks(parameters: [String : AnyObject], completionHandler: @escaping(_ result: ExternalLink?, _ error: NSError?) -> Void) {
        _ = taskForPOSTMethod("select_links_ios.php", parameters: [:], bodyParameters: parameters) {(data, error) in
            if let error = error {
                completionHandler(nil, error)
                return
            }
            
            guard let data = data else {
                let userInfo = [NSLocalizedDescriptionKey : "Couldn't retrive data"]
                completionHandler(nil, NSError(domain: "taskForPOSTMethod", code: 1, userInfo: userInfo))
                return
            }
            
            do {
                let links = try JSONDecoder().decode(ExternalLink.self, from: data)
                completionHandler(links, nil)
            }
            catch {
                completionHandler(nil, error as NSError)
            }
        }
    }

    func selectStudentsByTeacher(parameters: [String : AnyObject], completionHandler: @escaping(_ result: StudentData?, _ error: NSError?) -> Void) {
        _ = taskForPOSTMethod("select_student_by_teacher_ios.php", parameters: parameters, bodyParameters: parameters) {(data, error) in
            if let error = error {
                completionHandler(nil, error)
                return
            }
            
            guard let data = data else {
                let userInfo = [NSLocalizedDescriptionKey : "Couldn't retrive data"]
                completionHandler(nil, NSError(domain: "taskForPOSTMethod", code: 1, userInfo: userInfo))
                return
            }
            
            do {
                let students = try JSONDecoder().decode(StudentData.self, from: data)
                completionHandler(students, nil)
            }
            catch {
                completionHandler(nil, error as NSError)
            }
        }
    }


}


extension Client {
    
    func taskForGETMethod(
        _ method: String? = nil,
        _ customURL: URL? = nil,
        parameters: [String : AnyObject],
        completionHandlerForGET: @escaping (_ result: Data?, _ error: NSError?) -> Void
        ) -> URLSessionDataTask {
        let request: NSMutableURLRequest
        
        if let customURL = customURL {
            request = NSMutableURLRequest(url: customURL)
        }
        else {
            request = NSMutableURLRequest(url: buildURLFromParameters(parameters, apiScheme: ApiConstants.APIScheme, apiHost: ApiConstants.APIHost, apiPath: ApiConstants.APIPath, withPathExtension: method))
        }
        
        let task = session.dataTask(with: request as URLRequest) {(data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForGET(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            if let error = error {
                if (error as NSError).code == URLError.cancelled.rawValue {
                    completionHandlerForGET(nil, nil)
                }
                else {
                    sendError("There is an error with your request: \(error)")
                }
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returns status code other than 2XX")
                return
            }
            
            guard let data = data else {
                sendError("No data returned by the request")
                return
            }
            
            completionHandlerForGET(data, nil)
        }
        
        task.resume()
        return task
    }
    
    
    func taskForPOSTMethod(_ method: String, parameters: [String : AnyObject], bodyParameters: [String : AnyObject], requestHeaderParameters: [String : AnyObject]? = nil, completionHandlerForPOST: @escaping(_ result: Data?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        var request = URLRequest(url: buildURLFromParameters(parameters, apiScheme: ApiConstants.APIScheme, apiHost: ApiConstants.APIHost, apiPath: ApiConstants.APIPath, withPathExtension: method))
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = bodyParameters.percentEscaped().data(using: .utf8)
        
        if let headerParam = requestHeaderParameters {
            for(key, value) in headerParam {
                request.addValue("\(value)", forHTTPHeaderField: key)
            }
        }
        
        let task = session.dataTask(with: request) {(data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForPOST(nil, NSError(domain: "taskForPOSTMethod", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                sendError("There is an error with your request: \(error!)")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                sendError("Request didn't return a vaild response")
                return
            }
            
            switch (statusCode) {
            case 403:
                sendError("Please check your credentials and try again")
            case 200 ..< 299:
                break
            default:
                sendError("Your request returns status code other than 2XX")
                print(statusCode)
            }
            
            guard let data = data else {
                sendError("No data was returned by the request")
                return
            }
            
            completionHandlerForPOST(data, nil)
        }
        
        task.resume()
        return task
    }
    
    
    private func buildURLFromParameters(_ parameters: [String : AnyObject]?, apiScheme: String, apiHost: String, apiPath: String, withPathExtension: String? = nil) -> URL {
        var components = URLComponents()
        components.scheme = apiScheme
        components.host = apiHost
        components.path = apiPath + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        for(key, value) in parameters! {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems?.append(queryItem)
        }
        
        print("this is url: \(components.url!)")
        return components.url!
    }
}


extension Client {
    struct ApiConstants {
        static let APIScheme = "http"
        static let APIHost = "vmi448785.contaboserver.net"
        static let APIPath = "/~qlearn/khaled/Qlearn_Test_API/"
        static let ImagesPath = "~qlearn/qlearn/"
    }
}

