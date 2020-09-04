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
    
    func setupCell(teacher: Teacher, isMyTeacher: Bool) {
        self.teacherNameLabel.text = "مدرس: \(teacher.subject)"
        self.teacherSubjectLabel.text = "استاذ: \(teacher.name)"
        cellView.layer.cornerRadius = 15
        if(!isMyTeacher) {
            cellView.layer.backgroundColor = UIColor(displayP3Red: 36/255, green: 102/255, blue: 66/255, alpha: 1).cgColor
        }
        else {
            cellView.layer.backgroundColor = UIColor(displayP3Red: 0/255, green: 41/255, blue: 59/255, alpha: 1).cgColor
        }
    }

}
