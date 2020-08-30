//
//  SearchQuestionsTableViewCell.swift
//  El-Khateeb
//
//  Created by Eyad Shokry on 9/22/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import UIKit

class SearchQuestionsTableViewCell: UITableViewCell {
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    var searchQuestionsVC: SearchQuestionsViewController?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //remove the following line to allow the delete button
        deleteButton.isHidden = true
        deleteButton.addTarget(self, action: #selector(handleDeleteQuestion), for: .touchUpInside)
        editButton.addTarget(self, action: #selector(handleEditQuestion), for: .touchUpInside)
        self.selectionStyle = .none
    }
    
    @objc private func handleDeleteQuestion() {
        searchQuestionsVC?.deleteQuestion(cell: self)
    }
    
    @objc private func handleEditQuestion() {
        searchQuestionsVC?.editQuestion(cell: self)
    }
    
}
