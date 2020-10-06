//
//  ExternalLink.swift
//  QLearn
//
//  Created by Eyad Shokry on 10/5/20.
//  Copyright © 2020 Eyad Shokry. All rights reserved.
//

import Foundation

struct ExternalLink :Decodable {
    let RESULT:[Link]
}
struct Link:Decodable {
    let id: String
    let title: String
    let description: String
    let URL: String
    let level: String
    let teacherID: String
}
