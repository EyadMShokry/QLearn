//
//  TrueFalseQuestionStudentViewController.swift
//  El-Khateeb
//
//  Created by Abdalah on 9/23/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import UIKit
import SCLAlertView
class TrueFalseQuestionStudentViewController: UIViewController, DismissManager {
    @IBOutlet weak var questionTextArea: UITextView!
    @IBOutlet weak var reasonTextArea: UITextView!
    @IBOutlet weak var falseButton: UIButton!
    @IBOutlet weak var trueButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var noQuestionsView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var selectedChapterId = ""
    var questionsArray: [FullQuestionResult] = []
    var selectedAnswer = ""
    var teacherId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.bringSubviewToFront(activityIndicator)
        questionTextArea.layer.borderColor = UIColor.white.cgColor
        questionTextArea.layer.borderWidth = 2
        questionTextArea.layer.cornerRadius = 10
        questionTextArea.delegate = self
        
        reasonTextArea.layer.borderColor = UIColor.white.cgColor
        reasonTextArea.layer.borderWidth = 2
        reasonTextArea.layer.cornerRadius = 10
        reasonTextArea.text =  "The Reasoning ...".localized
        
        reasonTextArea.textColor = .lightGray
        reasonTextArea.delegate = self
        
        
        let student = Student()
        let parameters = ["chapter_id" : selectedChapterId, "student_id" : UserDefaults.standard.string(forKey: "id"), "level" : UserDefaults.standard.string(forKey: "student_level"), "teacher_id" : self.teacherId]
        activityIndicator.startAnimating()
        
        student.getNotAnsweredQuestions(method: "select_not_answered_tf_questions_ios.php", parameters: parameters as [String : AnyObject]) {(questions, error) in
            if let questions = questions {
                for question in questions.RESULT {
                    self.questionsArray.append(question)
                }
                print("not answred array: \(self.questionsArray)")
                student.getAnsweredQuestions(method: "select_answered_tf_questions_ios.php", parameters: parameters as [String : AnyObject]) {(data, error) in
                    if let questions = data {
                        for question in questions.RESULT {
                            self.questionsArray.append(question)
                        }
                        self.performUIUpdatesOnMain {
                            self.activityIndicator.stopAnimating()
                            self.activityIndicator.isHidden = true
                            if(self.questionsArray.count > 0) {
                                self.questionTextArea.text = self.questionsArray[0].question
                            }
                            else {
                                //ui for no questions
                                self.questionTextArea.isHidden = true
                                self.reasonTextArea.isHidden = true
                                self.trueButton.isHidden = true
                                self.falseButton.isHidden = true
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
    
    @IBAction func onClickTrueFalseButtons(_ sender: UIButton) {
        if sender == trueButton {
            selectedAnswer = "true"
            if sender.currentImage == UIImage(named: "check-1") {
                return
            }
            sender.setImage(UIImage(named: "check-1"), for: .normal)
            print("true changed to selected image")
        }
        else if sender == falseButton {
            selectedAnswer = "false"
            if sender.currentImage == UIImage(named: "wrong") {
                return
            }
            sender.setImage(UIImage(named: "wrong"), for: .normal)
            print("false changed to selected")
            
        }
        
        switch sender {
        case self.trueButton:
            self.falseButton.setImage(UIImage(named: "wrong-white"), for: .normal)
            print("wrong back to white")
            
        case self.falseButton:
            self.trueButton.setImage(UIImage(named: "check-mark"), for: .normal)
            print("true back to white")
            
        default:
            return
        }
    }
    
    
    @IBAction func SubmitAction(_ sender: UIButton) {
        
        if (reasonTextArea.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty || reasonTextArea.text == "The Reasoning ...".localized || selectedAnswer == "") {
            SCLAlertView().showError("Error".localized, subTitle:"Some field is empty".localized, closeButtonTitle:"Ok".localized)

        } else {
            let evaluateAnswerVC = storyboard?.instantiateViewController(withIdentifier: "EvaluateAnswer") as! EvaluateAnswerViewController
            evaluateAnswerVC.delegate = self
            evaluateAnswerVC.modalPresentationStyle = .popover
            evaluateAnswerVC.popoverPresentationController?.delegate = self
            evaluateAnswerVC.popoverPresentationController?.permittedArrowDirections = .any
            evaluateAnswerVC.popoverPresentationController?.sourceView = sender
            evaluateAnswerVC.popoverPresentationController?.sourceRect = CGRect(x: 50, y: 50, width: 1, height: 1)
            evaluateAnswerVC.modalPresentationStyle = .overCurrentContext
            evaluateAnswerVC.modalTransitionStyle = .crossDissolve
            evaluateAnswerVC.correctAnswer = questionsArray[0].explanation
            evaluateAnswerVC.questionType = "TF"
            evaluateAnswerVC.questionId = questionsArray[0].id
            evaluateAnswerVC.chapterId = selectedChapterId
            evaluateAnswerVC.studentAnswer = reasonTextArea.text
            
            if((questionsArray[0].correct_mark == "1" && selectedAnswer == "true") || (questionsArray[0].correct_mark == "0" && selectedAnswer == "false")) {
                evaluateAnswerVC.isTFCorrect = true
            }
            else {
                evaluateAnswerVC.isTFCorrect = false
            }
            
            self.present(evaluateAnswerVC, animated: true, completion: nil)
        }
        
    }
    
    func popoverDismiss(isExit: Bool) {
        print("popover dismissed")
        showNewQuestion()

    }
    
    private func showNewQuestion() {
        let currentQuestion = questionsArray[0]
        questionsArray.remove(at: 0)
        questionsArray.append(currentQuestion)
        
        questionTextArea.text = questionsArray[0].question
        reasonTextArea.text = ""
    }
}


extension  TrueFalseQuestionStudentViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            if textView == questionTextArea {
                textView.text = "The Question ...".localized
                textView.textColor = .lightGray
            }
            else if textView == reasonTextArea {
                textView.textColor = .lightGray
                textView.text = "The Reasoning ...".localized
                
            }
        }
    }

}


extension TrueFalseQuestionStudentViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return false
    }
    
}
