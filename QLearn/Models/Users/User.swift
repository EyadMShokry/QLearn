//
//  User.swift
//  El-Khateeb
//
//  Created by Eyad Shokry on 9/17/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import Foundation

class User {
    
    func getLessionDates(parameters: [String : AnyObject], completion: @escaping(_ result: LessonDate?, _ error: NSError?) -> Void) {
        Client.shared().selectLessonDates(parameters: parameters) {(data, error) in
            if let dates = data {
              completion(dates, nil)
            }
            else if let error = error {
                completion(nil, error)
            }
        }
    }
    
    func getAddresses(parameters: [String : AnyObject], completion: @escaping(_ result: Address?, _ error: NSError?) -> Void) {
        Client.shared().selectAddresses(parameters: parameters) {(data, error) in
            if let addresses = data {
                completion(addresses, nil)
            }
            else if let error = error {
                completion(nil, error)
            }
        }
    }
    
    func getPhoneNumbers(parameters: [String : AnyObject], completion: @escaping(_ result: Phone?, _ error: NSError?) -> Void) {
        Client.shared().selectPhoneNumbers(parameters: parameters) {(data, error) in
            if let phones = data {
                completion(phones, nil)
            }
            else if let error = error {
                completion(nil, error)
            }
        }
    }
    
    func getTeacherFullName(completion: @escaping(_ result: TeacherName?, _ error: NSError?) -> Void) {
        Client.shared().selectTeacherFullName() {(data, error) in
            if let teacherName = data {
                completion(teacherName, nil)
            }
            else if let error = error {
                completion(nil, error)
            }
        }
    }
   
    
    func getUnexpiredNews(parameters: [String : AnyObject], completion: @escaping(_ result: AllNews?, _ error: NSError?) -> Void) {
        Client.shared().selectUnexpiredNews(parameters: parameters) {(data, error) in
            if let unexpiredNews = data {
                completion(unexpiredNews, nil)
            }
            else if let error = error {
                completion(nil, error)
            }
        }
    }
    
    func getAchievements(parameters: [String : AnyObject], completion: @escaping(_ result: Achievement?, _ error: NSError?) -> Void) {
        Client.shared().selectAchievements(parameters: parameters) {(data, error) in
            if let achievements = data {
                completion(achievements, nil)
            }
            else if let error = error {
                completion(nil, error)
            }
        }
    }
    
    func getTeacherInfo(parameters: [String : AnyObject], completion: @escaping(_ result: TeacherInfo?, _ error: NSError?) -> Void) {
        Client.shared().selectTeacherInfo(parameters: parameters) {(data, error) in
            if let teacherInfo = data {
                completion(teacherInfo, nil)
            }
            else if let error = error {
                completion(nil, error)
            }
        }
    }
    
    func register(method: String, parameters: [String : AnyObject], completion: @escaping(_ result: String?, _ error: NSError?) -> Void) {
        Client.shared().registerUser(method: method, parameters: parameters) { (data, error) in
            if let response = data {
                completion(response, nil)
            }
            else if let error = error {
                completion(nil, error)
            }
        }
    }
    
    func getExternalLinks(parameters: [String : AnyObject], completion: @escaping(_ result: ExternalLink?, _ error: NSError?) -> Void) {
        Client.shared().selectExternalLinks(parameters: parameters) {(data, error) in
            if let links = data {
              completion(links, nil)
            }
            else if let error = error {
                completion(nil, error)
            }
        }
    }

   
}
