//
//  CreateEssayQuestionViewController.swift
//  El-Khateeb
//
//  Created by Eyad Shokry on 9/20/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import UIKit
import SCLAlertView

class CreateEssayQuestionViewController: UIViewController {
    @IBOutlet weak var questionTypeLabel: UILabel!
    @IBOutlet weak var questionTextView: UITextView!
    @IBOutlet weak var answerTextView: UITextView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var questionType = ""
    var questionTypeId = ""
    var isEdit = false
    var editQuestionText: String?
    var editAnswerText: String?
    var selectedChapterId = ""
    var selectedQuestionId = ""
    var selectedLevel = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        activityIndicator.isHidden = true
        
        questionTextView.layer.borderColor = UIColor.white.cgColor
        questionTextView.layer.borderWidth = 2
        questionTextView.layer.cornerRadius = 10
        questionTextView.text = "Enter The Question ...".localized
        questionTextView.textColor = .darkGray
        questionTextView.delegate = self
        
        answerTextView.layer.borderColor = UIColor.white.cgColor
        answerTextView.layer.borderWidth = 2
        answerTextView.layer.cornerRadius = 10
        answerTextView.text = "Enter The Answer ...".localized
        answerTextView.textColor = .darkGray
        answerTextView.delegate = self
        
        questionTypeLabel.text = questionType
        
        if(isEdit) {
            questionTextView.text = editQuestionText
            answerTextView.text = editAnswerText
            questionTextView.textColor = .black
            answerTextView.textColor = .black
        }
    }
    

    @IBAction func onClickAddQuestionButton(_ sender: Any) {
        if(questionTextView.text.isEmpty || questionTextView.textColor == .darkGray
            || answerTextView.text.isEmpty || answerTextView.textColor == .darkGray) {
            SCLAlertView().showError("Error".localized, subTitle:"Some field is empty".localized, closeButtonTitle:"Ok".localized)
        }
        else {
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            let admin = Admin()

            if(!isEdit) {
                let parameter = ["question":questionTextView.text!,
                                 "correct_answer":answerTextView.text!,
                                 "essay_type":questionTypeId,
                                 "chapter_id":selectedChapterId,
                                 "level" : selectedLevel,
                                 "teacher_id" : UserDefaults.standard.string(forKey: "id")]
                print(parameter)
                admin.insertEssayQuestion(parameters: parameter as [String : AnyObject]) {(response, error) in
                    if let response = response{
                        if response.contains("inserted"){
                            self.performUIUpdatesOnMain {
                                SCLAlertView().showSuccess("Success".localized, subTitle:"Is Added Successfully".localized, closeButtonTitle:"Ok".localized)
                                self.questionTextView.text = ""
                                self.answerTextView.text = ""
                                self.activityIndicator.stopAnimating()
                                self.activityIndicator.isHidden = true
                            }
                        }
                        else{
                            self.performUIUpdatesOnMain {
                                SCLAlertView().showError("Error".localized, subTitle: "Server Error, please contact with applications author".localized, closeButtonTitle:"Ok".localized)
                                self.activityIndicator.stopAnimating()
                                self.activityIndicator.isHidden = true
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
                            self.activityIndicator.stopAnimating()
                            self.activityIndicator.isHidden = true
                        }
                    }
                }
            }
            else {
                // edit essay question here
                let parameters = ["question" : questionTextView.text!,
                                  "correct_answer" : answerTextView.text!,
                                  "id" : selectedQuestionId]
                admin.updateEssayQuestions(parameters: parameters as [String : AnyObject]) { (response, error) in
                    if let response = response {
                        if response.contains("inserted") {
                            self.performUIUpdatesOnMain {
                                SCLAlertView().showSuccess("Success".localized, subTitle:"question is updated successfully".localized, closeButtonTitle:"Ok".localized)
                                self.activityIndicator.stopAnimating()
                                self.activityIndicator.isHidden = true
                            }
                        }
                        else {
                            self.performUIUpdatesOnMain {
                                SCLAlertView().showError("Error".localized, subTitle: "Server Error, please contact with applications author".localized, closeButtonTitle:"Ok".localized)
                                self.activityIndicator.stopAnimating()
                                self.activityIndicator.isHidden = true
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
                            self.activityIndicator.stopAnimating()
                            self.activityIndicator.isHidden = true
                        }
                    }
                }
            }
        }
    }
    
}



extension CreateEssayQuestionViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.darkGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            if textView == questionTextView {
                textView.text = "Enter The Question ...".localized
                textView.textColor = .darkGray
            }
            else if textView == answerTextView{
                textView.textColor = .darkGray
                textView.text = "Enter The Answer ...".localized
            }
        }
    }
}
