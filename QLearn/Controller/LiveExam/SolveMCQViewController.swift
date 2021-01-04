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
    var notAnsweredMcqQuestionsArray: [NotAnsweredMcqQuestion] = []
    var answeredMcqQuestionsArray: [AnswerdMCQQuestion] = []
    var isSolveRequest = false
    var examDuration = ""
    var currentQuestionIndex = 0
    
    private func adjustUIForNewQuestion(questionIndex: Int) {
        self.questionTextView.text = self.notAnsweredMcqQuestionsArray[questionIndex].question
        self.label1.text = self.notAnsweredMcqQuestionsArray[questionIndex].choice1
        self.label2.text = self.notAnsweredMcqQuestionsArray[questionIndex].choice2
        self.label3.text = self.notAnsweredMcqQuestionsArray[questionIndex].choice3
        self.label4.text = self.notAnsweredMcqQuestionsArray[questionIndex].choice4
        self.radioButton1.isOn = true
    }
    
    private func resetRadioButtons() {
        radioButton1.isOn = true
        radioButton2.isOn = false
        radioButton3.isOn = false
        radioButton4.isOn = false
    }

    
    fileprivate func adjustQuestionView() {
        questionTextView.layer.borderColor = UIColor.white.cgColor
        questionTextView.layer.borderWidth = 3
        questionTextView.layer.cornerRadius = 15
        
        view1.createsBorderForView(color: UIColor(displayP3Red: 194/255, green: 139/255, blue: 188/255, alpha: 1.0), radius: 25)
        view2.createsBorderForView(color: UIColor(displayP3Red: 194/255, green: 139/255, blue: 188/255, alpha: 1.0), radius: 25)
        view3.createsBorderForView(color: UIColor(displayP3Red: 194/255, green: 139/255, blue: 188/255, alpha: 1.0), radius: 25)
        view4.createsBorderForView(color: UIColor(displayP3Red: 194/255, green: 139/255, blue: 188/255, alpha: 1.0), radius: 25)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        resetRadioButtons()
        print("Hy5osh ymt7n? : \(isSolveRequest)")
        print("as2lt el emt7an: \(notAnsweredMcqQuestionsArray)")
        print("as2la et7lt abl kda: \(answeredMcqQuestionsArray)")
        
        adjustQuestionView()
        
        countDownLabel.setCountDownTime(minutes: TimeInterval(Double(self.examDuration)!) * 60)
        countDownLabel.timeFormat = "mm:ss"
        countDownLabel.animationType = .Evaporate
        countDownLabel.countdownDelegate = self
        
        if isSolveRequest {
            countDownLabel.start()
            adjustUIForNewQuestion(questionIndex: currentQuestionIndex)
        }
        else {
            // show questions only (no answering)
            
        }

    }
        
    @IBAction func onClickRadioButton(_ sender: SPRadioButton) {
        switch sender {
        case self.radioButton1:
            radioButton2.isOn = false
            radioButton3.isOn = false
            radioButton4.isOn = false
            selectedAnswer = 1
            
        case self.radioButton2:
            radioButton1.isOn = false
            radioButton3.isOn = false
            radioButton4.isOn = false
            selectedAnswer = 2
            
        case self.radioButton3:
            radioButton1.isOn = false
            radioButton2.isOn = false
            radioButton4.isOn = false
            selectedAnswer = 3
            
        case self.radioButton4:
            radioButton1.isOn = false
            radioButton2.isOn = false
            radioButton3.isOn = false
            selectedAnswer = 4
            
        default:
            return
        }
        print("selected answer: \(selectedAnswer)")
    }

    @IBAction func onClickNextButton(_ sender: UIButton) {
        if(nextButton.currentTitle == "Finish") {
            print("call submit exam api")
        }
        
        if(self.currentQuestionIndex+1 == self.notAnsweredMcqQuestionsArray.count-1) {
            self.nextButton.setTitle("Finish", for: .normal)
            //7ot fl array bta3t el answers le a5r mra
        }
        if(self.currentQuestionIndex+1 <= self.notAnsweredMcqQuestionsArray.count-1) {
            //7ot fl array bta3t el answers
            
            //show new question
            self.currentQuestionIndex = self.currentQuestionIndex + 1
        }
        adjustUIForNewQuestion(questionIndex: self.currentQuestionIndex)
    }
    
    @IBAction func onClickPreviousButton(_ sender: UIButton) {
        if(currentQuestionIndex == self.notAnsweredMcqQuestionsArray.count-1) {
            self.nextButton.setTitle("Next", for: .normal)
        }
        if(currentQuestionIndex-1 < 0) {
            return
        }
        else {
            self.currentQuestionIndex = self.currentQuestionIndex - 1
        }
        adjustUIForNewQuestion(questionIndex: self.currentQuestionIndex)
    }
    
}


extension SolveMCQViewController: CountdownLabelDelegate {
    
    func countingAt(timeCounted: TimeInterval, timeRemaining: TimeInterval) {
        switch timeRemaining {
        case 15:
            self.countDownLabel.textColor = .red
        default:
            break
        }
    }
    
    func countdownFinished() {
        //Anyway.. submit the exam
            print("10 seconds remaining!")
        print("Countdown is done")

    }

}
