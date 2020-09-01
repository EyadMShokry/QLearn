//
//  SchoolUser.swift
//  El-Khateeb
//
//  Created by Eyad Shokry on 9/29/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import Foundation

class SchoolUser: User {
    
    func getEssayTypes(completion: @escaping(_ result: PDFCategories?, _ error: NSError?) -> Void) {
        Client.shared().selectEssayTypes() {(data, error) in
            if let essayTypes = data {
                completion(essayTypes, nil)
            }
            else if let error = error {
                completion(nil, error)
            }
        }
    }
    
    func getChaptersInQuestions(pathExtension: String, parameters: [String : AnyObject], completion: @escaping(_ result: Chapter?, _ error: NSError?) -> Void) {
        Client.shared().selectChaptersInQuestions(pathExtension: pathExtension, parameters: parameters) {(data, error) in
            if let chapters = data {
                completion(chapters, nil)
            }
            else if let error = error {
                completion(nil, error)
            }
        }
    }
    
    func getAllChapters(completion: @escaping(_ result: Chapter?, _ error: NSError?) -> Void) {
        Client.shared().selectAllChapters() {(data, error) in
            if let chapters = data {
                completion(chapters, nil)
            }
            else if let error = error {
                completion(nil, error)
            }
        }
    }
    
}
