//
//  StudentLevel.swift
//  QLearn
//
//  Created by Eyad Shokry on 8/30/20.
//  Copyright © 2020 Eyad Shokry. All rights reserved.
//

import Foundation

struct StudentLevel: Decodable {
    let RESULT: [Level]
}

struct Level: Decodable {
        let id: String
        let levelTitle: String
}
