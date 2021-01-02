//
//  ChapterTableViewCell.swift
//  El-Khateeb
//
//  Created by Eyad Shokry on 9/20/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import UIKit

class ChapterTableViewCell: UITableViewCell {

    @IBOutlet weak var CalculatesProgress: UILabel!
    @IBOutlet weak var chapterLabel: UILabel!
    @IBOutlet weak var ViewLable: UIView!
    @IBOutlet weak var progressBar: CircularProgressBar!
    @IBOutlet weak var questionsNumberLabel: UILabel!
    @IBOutlet weak var examTimeLabel: UILabel!
    var progress : Double = 0

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        ViewLable.layer.cornerRadius = ViewLable.frame.size.width/2
        ViewLable.clipsToBounds = true
        self.selectionStyle = .none
        perform(#selector(startUpload), with: nil, afterDelay: 1.0)
    }

   // MARK: - Start uploading
    @objc func startUpload() {
        progressBar.setProgress(to: progress, withAnimation: true)
    }
    
    @objc func updateProgress() {
        progressBar.setProgress(to: progress, withAnimation: true)
    }
 
    
}

