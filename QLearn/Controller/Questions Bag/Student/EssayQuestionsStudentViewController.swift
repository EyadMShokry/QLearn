//
//  EssayQuestionsStudentViewController.swift
//  El-Khateeb
//
//  Created by Abdalah on 9/24/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import UIKit
import  SCLAlertView

protocol DismissManager {
    func popoverDismiss(isExit: Bool)
}

class EssayQuestionsStudentViewController: UIViewController, DismissManager {
 
    @IBOutlet weak var noQuestionsView: UIView!
    @IBOutlet weak var questionTypeLabel: UILabel!
    @IBOutlet weak var questionTextView: UITextView!
    @IBOutlet weak var answerTextView: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var questionType = ""
    var selectedChapterId = ""
    var selectedTypeId = ""
    var editQuestionText: String?
    var editAnswerText: String?
    var questionsArray: [FullQuestionResult] = []
    var teacherId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.bringSubviewToFront(activityIndicator)
        questionTextView.layer.borderColor = UIColor.white.cgColor
        questionTextView.layer.borderWidth = 2
        questionTextView.layer.cornerRadius = 10
        questionTypeLabel.text = "show cause".localized
        questionTextView.delegate = self
        
        answerTextView.layer.borderColor = UIColor.white.cgColor
        answerTextView.layer.borderWidth = 2
        answerTextView.layer.cornerRadius = 10
        answerTextView.text = "Enter The Answer ...".localized
        answerTextView.textColor = .lightGray
        answerTextView.delegate = self
        
        questionTypeLabel.text = questionType
        
        let student = Student()
        let parameters = ["chapter_id" : selectedChapterId,
                          "student_id" : UserDefaults.standard.string(forKey: "id")!,
                          "essay_type" : selectedTypeId,
                          "teacher_id" : self.teacherId,
                          "level": UserDefaults.standard.string(forKey: "student_level")]
        print(parameters)
        activityIndicator.startAnimating()
        
        student.getNotAnsweredQuestions(method: "select_not_answered_essay_question_ios.php", parameters: parameters as [String : AnyObject]) {(questions, error) in
            if let questions = questions {
                for question in questions.RESULT {
                    self.questionsArray.append(question)
                }
                student.getAnsweredQuestions(method: "select_answered_essay_question_ios.php", parameters: parameters as [String : AnyObject]) {(data, error) in
                    if let questions = data {
                        for question in questions.RESULT {
                            self.questionsArray.append(question)
                        }
                        self.performUIUpdatesOnMain {
                            self.activityIndicator.stopAnimating()
                            self.activityIndicator.isHidden = true
                            if(self.questionsArray.count > 0) {
                                self.questionTextView.text = self.questionsArray[0].question
                            }
                            else {
                                //ui for no questions
                                self.view.bringSubviewToFront(self.noQuestionsView)
                                self.noQuestionsView.isHidden = false
                                self.questionTextView.isHidden = true
                                self.answerTextView.isHidden = true
                                self.submitButton.isHidden = true
                                self.questionTypeLabel.isHidden = true
                            }
                        }
                    }
                    else if let error = error {
                        print(error)
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
    }
    
    @IBAction func SaveAction(_ sender: UIButton) {
        
        if(answerTextView.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty || answerTextView.text == "Enter The Answer ...".localized) {
            SCLAlertView().showError("Error".localized, subTitle:"Some field is empty".localized, closeButtonTitle:"Ok".localized)
        }
        else {
            let evaluateAnswerVC = storyboard?.instantiateViewController(withIdentifier: "EvaluateAnswer") as! EvaluateAnswerViewController
            evaluateAnswerVC.delegate = self
            evaluateAnswerVC.modalPresentationStyle = .popover
            evaluateAnswerVC.popoverPresentationController?.delegate = self
            evaluateAnswerVC.popoverPresentationController?.permittedArrowDirections = .any
            evaluateAnswerVC.popoverPresentationController?.sourceView = sender
            evaluateAnswerVC.popoverPresentationController?.sourceRect = CGRect(x: 50, y: 50, width: 1, height: 1)
            evaluateAnswerVC.modalPresentationStyle = .overCurrentContext
            evaluateAnswerVC.modalTransitionStyle = .crossDissolve
            evaluateAnswerVC.correctAnswer = questionsArray[0].correct_answer
            evaluateAnswerVC.questionType = "essay"
            evaluateAnswerVC.studentAnswer = answerTextView.text
            evaluateAnswerVC.questionId = questionsArray[0].id
            evaluateAnswerVC.chapterId = questionsArray[0].chapter_id
            
            self.present(evaluateAnswerVC, animated: true, completion: nil)
        }
        
    }
    
    func validate(textView: UITextView) -> Bool {
        guard let text = textView.text,
            !text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty else {
                return false
        }
        
        return true
        
    }

    func popoverDismiss(isExit: Bool) {
        print("popover dismissed")
        showNewQuestion()
    }
    
    private func showNewQuestion() {
        let currentQuestion = questionsArray[0]
        questionsArray.remove(at: 0)
        questionsArray.append(currentQuestion)
        
        questionTextView.text = questionsArray[0].question
        answerTextView.text = ""
    }
}

extension EssayQuestionsStudentViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if answerTextView.text.isEmpty {
            textView.text = nil
                textView.textColor = .black
                textView.text = "Enter The Answer ...".localized
          
    
        }
    }
}


extension EssayQuestionsStudentViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return false
    }
    
}

