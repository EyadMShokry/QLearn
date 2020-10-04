//
//  AdminMaxId.swift
//  QLearn
//
//  Created by Eyad Shokry on 10/3/20.
//  Copyright © 2020 Eyad Shokry. All rights reserved.
//

import Foundation

class AdminMaxId: Decodable {
    let RESULT: [MaxId]
}

class MaxId: Decodable {
    let max_id: String
}
