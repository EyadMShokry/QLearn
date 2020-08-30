
//
//  CreateTrueFalseQuestionViewController.swift
//  El-Khateeb
//
//  Created by Eyad Shokry on 9/21/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import UIKit
import SCLAlertView

class CreateTrueFalseQuestionViewController: UIViewController {
  
    @IBOutlet weak var questionTextArea: UITextView!
    @IBOutlet weak var reasonTextArea: UITextView!
    @IBOutlet weak var falseButton: UIButton!
    @IBOutlet weak var trueButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var isEdit = false
    var editQuestionText: String?
    var editReasonText: String?
    var previousAnswer: Bool = true
    var selectedChapterId = ""
    var selectedMark = 0
    var selectedQuestionId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        questionTextArea.layer.borderColor = UIColor.white.cgColor
        questionTextArea.layer.borderWidth = 2
        questionTextArea.layer.cornerRadius = 10
        questionTextArea.text = "Enter The Question ...".localized

        questionTextArea.textColor = .darkGray
        questionTextArea.delegate = self
        
        reasonTextArea.layer.borderColor = UIColor.white.cgColor
        reasonTextArea.layer.borderWidth = 2
        reasonTextArea.layer.cornerRadius = 10
        reasonTextArea.text =  "The Reasoning ...".localized

        reasonTextArea.textColor = .darkGray
        reasonTextArea.delegate = self
        
        activityIndicator.isHidden = true
        
        if(isEdit) {
            questionTextArea.text = editQuestionText
            reasonTextArea.text = editReasonText
            questionTextArea.textColor = .black
            reasonTextArea.textColor = .black
            if previousAnswer {
                self.trueButton.setImage(UIImage(named: "check-1"), for: .normal)
                self.falseButton.setImage(UIImage(named: "wrong-white"), for: .normal)
            }
            else {
                self.falseButton.setImage(UIImage(named: "wrong"), for: .normal)
                self.trueButton.setImage(UIImage(named: "check-mark"), for: .normal)
            }
        }

    }
    
    @IBAction func onClickTrueFalseButtons(_ sender: UIButton) {
        if sender == trueButton {
            selectedMark = 1
            if sender.currentImage == UIImage(named: "check-1") {
                return
            }
            sender.setImage(UIImage(named: "check-1"), for: .normal)
            print("true changed to selected image")
        }
        else if sender == falseButton {
            selectedMark = 0
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
    
    @IBAction func onClickCreateQuestionButton(_ sender: Any) {
        if(questionTextArea.text.isEmpty || questionTextArea.textColor == .darkGray || reasonTextArea.text.isEmpty || reasonTextArea.textColor == .darkGray || (trueButton.currentImage == UIImage(named: "check-mark") && falseButton.currentImage == UIImage(named: "wrong-white"))) {
            SCLAlertView().showError("Error".localized, subTitle:"Some field is empty".localized, closeButtonTitle:"Ok".localized)
        }
        else {
            let admin = Admin()
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            
            if(!isEdit) {
                let parameters = [  "question" : questionTextArea.text!,
                                    "correct_mark" : "\(selectedMark)",
                                    "chapter_id" : selectedChapterId,
                                    "explanation" : reasonTextArea.text!]
                
                admin.insertTFQuestion(parameters: parameters as [String : AnyObject]) {(data, error) in
                    if let response = data {
                        print(response)
                        if response.contains("inserted") {
                            self.performUIUpdatesOnMain {
                                SCLAlertView().showSuccess("Success".localized, subTitle:"Your question is added successfully".localized, closeButtonTitle:"Ok".localized)
                                self.questionTextArea.text = ""
                                self.reasonTextArea.text = ""
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
                //call edit tf question here
                let parameters = ["question" : questionTextArea.text!,
                                  "correct_mark" : "\(selectedMark)",
                                  "explanation" : reasonTextArea.text!,
                                  "id" : selectedQuestionId]
                admin.updataTrueFalseQuestions(parameters: parameters as [String : AnyObject]) { (response, error) in
                    if let response = response {
                        print(response)
                        if response.contains("inserted") {
                            self.performUIUpdatesOnMain {
                                SCLAlertView().showSuccess("Success".localized, subTitle: "question is updated successfully".localized, closeButtonTitle:"Ok".localized)
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

extension CreateTrueFalseQuestionViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.darkGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            if textView == questionTextArea {
                textView.text = "Enter The Question ...".localized
                textView.textColor = .darkGray
            }
            else if textView == reasonTextArea {
                textView.textColor = .darkGray
                textView.text = "The Reasoning ...".localized

            }
        }
    }
}
