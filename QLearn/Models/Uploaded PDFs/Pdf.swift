//
//  Pdf.swift
//  El-Khateeb
//
//  Created by Eyad Shokry on 9/27/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import Foundation

struct PDFs: Decodable {
    let RESULT: [PdfResult]
}

struct PdfResult: Decodable {
    let id: String
    let url: String
    let title: String
    let category_id: String
}
