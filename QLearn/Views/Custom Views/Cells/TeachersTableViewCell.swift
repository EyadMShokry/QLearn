//
//  TeachersTableViewCell.swift
//  QLearn
//
//  Created by Eyad Shokry on 8/31/20.
//  Copyright © 2020 Eyad Shokry. All rights reserved.
//

import UIKit

class TeachersTableViewCell: UITableViewCell {
    @IBOutlet weak var teacherNameLabel: UILabel!
    @IBOutlet weak var teacherSubjectLabel: UILabel!
    @IBOutlet weak var cellView: UIView!
    
    func setupCell(teacher: Teacher) {
        self.teacherNameLabel.text = "مدرس: \(teacher.subject)"
        self.teacherSubjectLabel.text = "استاذ: \(teacher.name)"
        cellView.layer.cornerRadius = 15
    }

}
