//
//  AnswerQuestionsViewController.swift
//  El-Khateeb
//
//  Created by Abdalah on 9/29/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import UIKit

class GoQusetionAnswerViewController: UIViewController {

    @IBOutlet weak var AskTextView: UITextView!
    @IBOutlet weak var AnswerTextView: UITextView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var questionText = ""
    var answerText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        AskTextView.layer.borderColor = UIColor.white.cgColor
        AnswerTextView.layer.borderColor = UIColor.white.cgColor
        AskTextView.layer.borderWidth = 3
        AskTextView.layer.cornerRadius = 15
        AnswerTextView.layer.borderWidth = 3
        AnswerTextView.layer.cornerRadius = 15
        AskTextView.text = questionText
        AnswerTextView.text = answerText
    }
    
}
