//
//  Parent.swift
//  El-Khateeb
//
//  Created by Eyad Shokry on 10/1/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import Foundation

class Parent {
    
    func login(parameters: [String : AnyObject], completion: @escaping(_ result: StudentLogin?, _ error: NSError?) -> Void) {
        Client.shared().loginParent(parameters: parameters) {(data, error) in
            if let parent = data {
                completion(parent, nil)
            }
            else if let error = error {
                completion(nil, error)
            }
        }
    }
    
}
