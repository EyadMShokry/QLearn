//
//  CheckQuestionViewController.swift
//  El-Khateeb
//
//  Created by Abdalah on 9/23/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import UIKit
import SCLAlertView

class CheckQuestionViewController: UIViewController, DismissManager {
    @IBOutlet weak var questionTextArea: UITextView!
    @IBOutlet weak var radioButton1: SPRadioButton!
    @IBOutlet weak var radioButton2: SPRadioButton!
    @IBOutlet weak var radioButton3: SPRadioButton!
    @IBOutlet weak var radioButton4: SPRadioButton!
    @IBOutlet weak var lable1: UILabel!
    @IBOutlet weak var lable2: UILabel!
    @IBOutlet weak var lable3: UILabel!
    @IBOutlet weak var lable4: UILabel!
    @IBOutlet weak var View1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var mcqStackView: UIStackView!
    @IBOutlet weak var noQuestionsView: UIView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var selectedAnswer = 1
    var selectedChapterId = ""
    var questionsArray: [FullQuestionResult] = []
    
    private func adjustUIForNewQuestion() {
        self.questionTextArea.text = self.questionsArray[0].question
        self.lable1.text = self.questionsArray[0].choice1
        self.lable2.text = self.questionsArray[0].choice2
        self.lable3.text = self.questionsArray[0].choice3
        self.lable4.text = self.questionsArray[0].choice4
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
        
        resetRadioButtons()
        
        self.view.bringSubviewToFront(activityIndicator)
        questionTextArea.layer.borderColor = UIColor.white.cgColor
        questionTextArea.layer.borderWidth = 3
        questionTextArea.layer.cornerRadius = 15

        View1.createsBorderForView(color: UIColor.white, radius: 25)
        view2.createsBorderForView(color: UIColor.white, radius: 25)
        view3.createsBorderForView(color: UIColor.white, radius: 25)
        view4.createsBorderForView(color: UIColor.white, radius: 25)

        let student = Student()
        let parameters = ["chapter_id" : selectedChapterId, "student_id" : UserDefaults.standard.value(forKey: "id")]
        activityIndicator.startAnimating()
        
        student.getNotAnsweredQuestions(method: "select_not_answered_mcq_questions.php", parameters: parameters as [String : AnyObject]) {(questions, error) in
            if let questions = questions {
                for question in questions.RESULT {
                    self.questionsArray.append(question)
                }
                print("not answred array: \(self.questionsArray)")
                student.getAnsweredQuestions(method: "select_answered_mcq_questions.php", parameters: parameters as [String : AnyObject]) {(data, error) in
                    if let questions = data {
                        for question in questions.RESULT {
                            self.questionsArray.append(question)
                        }
                        self.performUIUpdatesOnMain {
                            self.activityIndicator.stopAnimating()
                            self.activityIndicator.isHidden = true
                            if(self.questionsArray.count > 0) {
                                self.adjustUIForNewQuestion()
                            }
                            else {
                                //ui for no questions
                                self.questionTextArea.isHidden = true
                                self.mcqStackView.isHidden = true
                                self.submitButton.isHidden = true
                                self.view.bringSubviewToFront(self.noQuestionsView)
                                self.noQuestionsView.isHidden = false
                            }
                        }

                    }
                    else if let error = error {
                        self.performUIUpdatesOnMain {
                            if error.code == 1001 {
                                self.performUIUpdatesOnMain {
                                    SCLAlertView().showError("Error happened", subTitle: "Please check your internet connection", closeButtonTitle:"Ok".localized)
                                }
                            }
                            else {
                                self.performUIUpdatesOnMain {
                                    SCLAlertView().showError("Error happened", subTitle: "Server error happened. please check your internet connection or contact with application's author", closeButtonTitle:"Ok".localized)
                                }
                            }
                            print(error)
                            self.performUIUpdatesOnMain {
                                self.activityIndicator.stopAnimating()
                                self.activityIndicator.isHidden = true
                            }
                        }
                    }
                }
            }
            else if let error = error {
                self.performUIUpdatesOnMain {
                    if error.code == 1001 {
                        self.performUIUpdatesOnMain {
                            SCLAlertView().showError("Error happened", subTitle: "Please check your internet connection", closeButtonTitle:"Ok".localized)
                        }
                    }
                    else {
                        self.performUIUpdatesOnMain {
                            SCLAlertView().showError("Error happened", subTitle: "Server error happened. please check your internet connection or contact with application's author", closeButtonTitle:"Ok".localized)
                        }
                    }
                    print(error)
                    self.performUIUpdatesOnMain {
                        self.activityIndicator.stopAnimating()
                        self.activityIndicator.isHidden = true
                    }

                }
            }
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
    
    @IBAction func SubmitAction(_ sender: UIButton) {
        if selectedAnswer == Int(questionsArray[0].correct_answer) {
            let student = Student()
            
            var actualAnswer = ""
            if(selectedAnswer == 1) {
                actualAnswer = lable1.text!
                
            }
            else if(selectedAnswer == 2) {
                actualAnswer = lable2.text!
            }
            else if(selectedAnswer == 3) {
                actualAnswer = lable3.text!
            }
            else {
                actualAnswer = lable4.text!
            }
            let parameters = ["actual_answer": actualAnswer,
                              "question_id": questionsArray[0].id,
                              "student_id": UserDefaults.standard.value(forKey: "id"),
                              "type": "mcq",
                              "isCorrect": "1",
                              "chapter_id": selectedChapterId]
            
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            student.insertAnswerWithType(method: "insert_answer_with_type.php", parameters: parameters as [String : AnyObject]) {(data, error) in
                if let response = data {
                    if response.contains("inserted") {
                        self.performUIUpdatesOnMain {
                            self.activityIndicator.stopAnimating()
                            self.activityIndicator.isHidden = true
                        }
                        print("inserted")
                    }
                    else {
                        self.performUIUpdatesOnMain {
                            self.performUIUpdatesOnMain {
                                self.activityIndicator.stopAnimating()
                                self.activityIndicator.isHidden = true
                                SCLAlertView().showError("Error".localized, subTitle: "Server Error, please contact with applications author".localized, closeButtonTitle:"Ok".localized)
                            }
                        }
                    }
                }
                else if let error = error {
                    self.performUIUpdatesOnMain {
                        if error.code == 1001 {
                            self.performUIUpdatesOnMain {
                                SCLAlertView().showError("Error happened", subTitle: "Please check your internet connection", closeButtonTitle:"Ok".localized)
                            }
                        }
                        else {
                            self.performUIUpdatesOnMain {
                                SCLAlertView().showError("Error happened", subTitle: "Server error happened. please check your internet connection or contact with application's author", closeButtonTitle:"Ok".localized)
                            }
                        }
                        self.performUIUpdatesOnMain {
                            self.activityIndicator.stopAnimating()
                            self.activityIndicator.isHidden = true
                        }
                        print(error)
                    }
                }
            }

            let correctAnswerVC = storyboard?.instantiateViewController(withIdentifier: "CorrectAnswer") as! CorrectAnswerViewController
            correctAnswerVC.delegate = self
            correctAnswerVC.modalPresentationStyle = .popover
            correctAnswerVC.popoverPresentationController?.delegate = self
            correctAnswerVC.popoverPresentationController?.permittedArrowDirections = .any
            correctAnswerVC.popoverPresentationController?.sourceView = sender
            correctAnswerVC.popoverPresentationController?.sourceRect = CGRect(x: 50, y: 50, width: 1, height: 1)
            correctAnswerVC.modalPresentationStyle = .overCurrentContext
            correctAnswerVC.modalTransitionStyle = .crossDissolve

            self.present(correctAnswerVC, animated: true)
        }
        else {
            //call api here for not correct mcq answer
            let student = Student()
            
            var actualAnswer = ""
            if(selectedAnswer == 1) {
                actualAnswer = lable1.text!
                
            }
            else if(selectedAnswer == 2) {
                actualAnswer = lable2.text!
            }
            else if(selectedAnswer == 3) {
                actualAnswer = lable3.text!
            }
            else {
                actualAnswer = lable4.text!
            }
            let parameters = ["actual_answer": actualAnswer,
                              "question_id": questionsArray[0].id,
                              "student_id": UserDefaults.standard.value(forKey: "id"),
                              "type": "mcq",
                              "isCorrect": "-1",
                              "chapter_id": selectedChapterId]
            student.insertAnswerWithType(method: "insert_answer_with_type.php", parameters: parameters as [String : AnyObject]) {(data, error) in
                if let response = data {
                    if response.contains("inserted") {
                        print("inserted")
                    }
                    else {
                        self.performUIUpdatesOnMain {
                            SCLAlertView().showError("Error".localized, subTitle: "Server Error, please contact with applications author".localized, closeButtonTitle:"Ok".localized)
                        }
                    }
                }
                else if let error = error {
                    self.performUIUpdatesOnMain {
                        if error.code == 1001 {
                            self.performUIUpdatesOnMain {
                                SCLAlertView().showError("Error happened", subTitle: "Please check your internet connection", closeButtonTitle:"Ok".localized)
                            }
                        }
                        else {
                            self.performUIUpdatesOnMain {
                                SCLAlertView().showError("Error happened", subTitle: "Server error happened. please check your internet connection or contact with application's author", closeButtonTitle:"Ok".localized)
                            }
                        }
                        print(error)
                    }
                }
            }

            
            let evaluateAnswerVC = storyboard?.instantiateViewController(withIdentifier: "EvaluateAnswer") as! EvaluateAnswerViewController
            evaluateAnswerVC.delegate = self
            evaluateAnswerVC.modalPresentationStyle = .popover
            evaluateAnswerVC.popoverPresentationController?.delegate = self
            evaluateAnswerVC.popoverPresentationController?.permittedArrowDirections = .any
            evaluateAnswerVC.popoverPresentationController?.sourceView = sender
            evaluateAnswerVC.popoverPresentationController?.sourceRect = CGRect(x: 50, y: 50, width: 1, height: 1)
            evaluateAnswerVC.modalPresentationStyle = .overCurrentContext
            evaluateAnswerVC.modalTransitionStyle = .crossDissolve
            
            if(questionsArray[0].correct_answer == "1") {
                evaluateAnswerVC.correctAnswer = lable1.text!

            }
            else if(questionsArray[0].correct_answer == "2") {
                evaluateAnswerVC.correctAnswer = lable2.text!
            }
            else if(questionsArray[0].correct_answer == "3") {
                evaluateAnswerVC.correctAnswer = lable3.text!
            }
            else {
                evaluateAnswerVC.correctAnswer = lable4.text!
            }
            
            evaluateAnswerVC.questionType = "mcq"
            self.present(evaluateAnswerVC, animated: true)

        }
    }
    
    func popoverDismiss(isExit: Bool) {
        print("popover dismissed")
        resetRadioButtons()
        if(!isExit) {
            showNewQuestion()
        }
        else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func showNewQuestion() {
        let currentQuestion = questionsArray[0]
        questionsArray.remove(at: 0)
        questionsArray.append(currentQuestion)
        adjustUIForNewQuestion()
    }

}

extension CheckQuestionViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return false
    }
    
}

