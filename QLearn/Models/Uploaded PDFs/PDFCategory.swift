//
//  PDFCategory.swift
//  El-Khateeb
//
//  Created by Eyad Shokry on 9/27/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import Foundation

struct PDFCategories: Decodable {
    let RESULT: [CategoryResult]
}

struct CategoryResult: Decodable {
    let id: String
    let title: String
}
