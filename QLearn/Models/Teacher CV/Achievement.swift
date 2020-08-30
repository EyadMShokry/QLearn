//
//  Achievement.swift
//  El-Khateeb
//
//  Created by Eyad Shokry on 9/27/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import Foundation

struct Achievement: Decodable {
    let RESULT: [AchievementResult]
}

struct AchievementResult: Decodable {
    let achievement_id: String
    let achievement: String
    let teacher_id: String
}