//
//  PDFTableViewCell.swift
//  El-Khateeb
//
//  Created by Eyad Shokry on 9/19/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import UIKit

class PDFTableViewCell: UITableViewCell {
    
    @IBOutlet weak var downloadStackView: UIStackView!
    @IBOutlet weak var pdfNameLabel: UILabel!
    @IBOutlet weak var downloadButton: UIButton!
    var pdfVC: PDFTypeViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        downloadButton.addTarget(self, action: #selector(handleDownloadPdf), for: .touchUpInside)
    }

    @objc private func handleDownloadPdf() {
        print("clicked")
        pdfVC?.downloadPdf(cell: self)
    }

}
