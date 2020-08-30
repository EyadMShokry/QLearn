//
//  AllQuestionChapterCell.swift
//  El-Khateeb
//
//  Created by Abdalah on 9/27/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import UIKit

class AllQuestionChapterCell: UITableViewCell {

    @IBOutlet weak var QuestionLable: UILabel!
    @IBOutlet weak var questionView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        questionView.layer.cornerRadius = QuestionLable.frame.size.width/2
        questionView.clipsToBounds = true
        self.selectionStyle = .none
    }

}
