//
//  IsActivated.swift
//  QLearn
//
//  Created by Eyad Shokry on 9/3/20.
//  Copyright © 2020 Eyad Shokry. All rights reserved.
//

import Foundation

class IsActivated: Decodable {
    let RESULT: [Activated]
}

class Activated: Decodable {
    let activated: String
}
