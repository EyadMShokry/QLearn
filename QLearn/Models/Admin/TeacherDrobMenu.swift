//
//  TeacherDrobMenu.swift
//  El-Khateeb
//
//  Created by Abdalah on 10/1/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import Foundation

struct TeacherDrobMenu :Decodable {
    let RESULT:[AllTeacherResult]
}
struct AllTeacherResult:Decodable {
    let id :String
    let phone :String
    let name:String
    let pass:String

}
