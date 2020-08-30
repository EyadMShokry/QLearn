//
//  CreateMcqQuestionViewController.swift
//  El-Khateeb
//
//  Created by Abdalah on 9/21/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import UIKit
import SCLAlertView

class CreateMcqQuestionViewController: UIViewController {
 @IBOutlet weak var questionTextView: UITextView!
    @IBOutlet weak var AnswerOneTextField: UITextField!
    @IBOutlet weak var AnswerTwoTextField: UITextField!
    @IBOutlet weak var AnswerThreeTextField: UITextField!
    @IBOutlet weak var AnswerFourTextField: UITextField!
    @IBOutlet weak var radioButton1: SPRadioButton!
    @IBOutlet weak var radioButton2: SPRadioButton!
    @IBOutlet weak var radioButton3: SPRadioButton!
    @IBOutlet weak var radioButton4: SPRadioButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var selectedAnswer = 1
    var isEdit = false
    var editQuestionText: String?
    var editAnswer1Text: String?
    var editAnswer2Text: String?
    var editAnswer3Text: String?
    var editAnswer4Text: String?
    var selectedChapterId = ""
    var selectedQuestionId = ""

    
//    @IBOutlet var CollectionRadioButton: [UIButton]!
    //check-box
    override func viewDidLoad() {
        super.viewDidLoad()
        questionTextView.layer.borderColor = UIColor.white.cgColor
        questionTextView.layer.borderWidth = 2
        questionTextView.layer.cornerRadius = 10
        questionTextView.text = "The Question ...".localized
        questionTextView.textColor = .darkGray
        questionTextView.delegate = self
        radioButton1.isOn = true
        activityIndicator.isHidden = true
        
        if(isEdit) {
            questionTextView.text = editQuestionText
            questionTextView.textColor = .black
            AnswerOneTextField.text = editAnswer1Text
            AnswerTwoTextField.text = editAnswer2Text
            AnswerThreeTextField.text = editAnswer3Text
            AnswerFourTextField.text = editAnswer4Text
            
            if(selectedAnswer == 1) {
                radioButton1.isOn = true
                radioButton2.isOn = false
                radioButton3.isOn = false
                radioButton4.isOn = false
            }
            else if (selectedAnswer == 2) {
                radioButton1.isOn = false
                radioButton2.isOn = true
                radioButton3.isOn = false
                radioButton4.isOn = false
            }
            else if (selectedAnswer == 3) {
                radioButton1.isOn = false
                radioButton2.isOn = false
                radioButton3.isOn = true
                radioButton4.isOn = false
            }
            else {
                radioButton1.isOn = false
                radioButton2.isOn = false
                radioButton3.isOn = false
                radioButton4.isOn = true
            }
        }

    }

    @IBAction func onClickCreateButton(_ sender: Any) {
        if(questionTextView.text.isEmpty || questionTextView.textColor == .darkGray || AnswerOneTextField.text!.isEmpty || AnswerTwoTextField.text!.isEmpty || AnswerThreeTextField.text!.isEmpty || AnswerFourTextField.text!.isEmpty) {
            SCLAlertView().showError("Error".localized, subTitle:"Some field is empty".localized, closeButtonTitle:"Ok".localized)
        }
        else {
            let admin = Admin()
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()

            if(!isEdit) {
                let parameter = ["question" : questionTextView.text!,
                                 "choice1" : AnswerOneTextField.text!,
                                 "choice2" : AnswerTwoTextField.text!,
                                 "choice3" : AnswerThreeTextField.text!,
                                 "choice4" : AnswerFourTextField.text!,
                                 "correct_answer" : "\(selectedAnswer)",
                                 "chapter_id" : selectedChapterId]
                
                admin.insertMcqQuestion(parameters: parameter as [String : AnyObject]) {(data, error) in
                    if let response = data {
                        if response.contains("inserted") {
                            self.performUIUpdatesOnMain {
                                SCLAlertView().showSuccess("Success".localized, subTitle:"Your question is added successfully".localized, closeButtonTitle:"Ok".localized)
                                self.questionTextView.text = ""
                                self.AnswerOneTextField.text = ""
                                self.AnswerTwoTextField.text = ""
                                self.AnswerThreeTextField.text = ""
                                self.AnswerFourTextField.text = ""
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
            else {
                //edit mcq question
                let parameters = ["question" : questionTextView.text!,
                                "choice1" : AnswerOneTextField.text!,
                                "choice2" : AnswerTwoTextField.text!,
                                "choice3" : AnswerThreeTextField.text!,
                                "choice4" : AnswerFourTextField.text!,
                                "correct_answer" : "\(selectedAnswer)",
                                "id" : selectedQuestionId]
                admin.updateMcqQuestions(parameters: parameters as [String : AnyObject]) {(response, error) in
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
    
}


extension CreateMcqQuestionViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.darkGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
                textView.text = "Enter The Question ...".localized
                textView.textColor = .darkGray
        }
    }
    
}
