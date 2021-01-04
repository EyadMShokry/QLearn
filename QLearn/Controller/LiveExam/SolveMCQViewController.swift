//
//  SolveMCQViewController.swift
//  QLearn
//
//  Created by Eyad Shokry on 1/3/21.
//  Copyright © 2021 Eyad Shokry. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import CountdownLabel

class SolveMCQViewController: UIViewController {
    @IBOutlet weak var questionTextView: UITextView!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    @IBOutlet weak var radioButton1: SPRadioButton!
    @IBOutlet weak var radioButton2: SPRadioButton!
    @IBOutlet weak var radioButton3: SPRadioButton!
    @IBOutlet weak var radioButton4: SPRadioButton!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var mcqStackView: UIStackView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    @IBOutlet weak var countDownLabel: CountdownLabel!
    var selectedAnswer = 1
    var questionsArray: [String] = []
    var notAnsweredMcqQuestionsArray: [NotAnsweredMcqQuestion] = []
    var answeredMcqQuestionsArray: [AnswerdMCQQuestion] = []
    var isSolveRequest = false
    
    private func adjustUIForNewQuestion() {
        self.questionTextView.text = self.questionsArray[0]
        self.label1.text = self.questionsArray[0]
        self.label2.text = self.questionsArray[0]
        self.label3.text = self.questionsArray[0]
        self.label4.text = self.questionsArray[0]
        self.radioButton1.isOn = true
    }
    
    private func resetRadioButtons() {
        radioButton1.isOn = true
        radioButton2.isOn = false
        radioButton3.isOn = false
        radioButton4.isOn = false
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("Hy5osh ymt7n? : \(isSolveRequest)")
        resetRadioButtons()
        print("as2lt el emt7an: \(notAnsweredMcqQuestionsArray)")
        print("as2la et7lt abl kda: \(answeredMcqQuestionsArray)")
    }
    

    @IBAction func onClickNextButton(_ sender: UIButton) {
        
    }
    
    @IBAction func onClickPreviousButton(_ sender: UIButton) {
        
    }
    
}
