//
//  AllNews.swift
//  El-Khateeb
//
//  Created by Abdalah on 10/1/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import Foundation
struct AllNews :Decodable {
    let RESULT:[AllNewsResult]
}
struct AllNewsResult:Decodable {
    let id :String
    let news_text :String
    let expire_date:String
}
