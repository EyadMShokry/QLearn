
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
    var selectedLevel = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        questionTextArea.layer.borderColor = UIColor.white.cgColor
        questionTextArea.layer.borderWidth = 2
        questionTextArea.layer.cornerRadius = 10
        questionTextArea.text = "Enter The Question ...".localized

        questionTextArea.textColor = .darkGray
        questionTextArea.delegate = self
                
        activityIndicator.isHidden = true
        
        if(isEdit) {
            questionTextArea.text = editQuestionText
            questionTextArea.textColor = .black
            if previousAnswer {
                self.trueButton.setImage(UIImage(named: "check-1"), for: .normal)
                self.trueButton.tag = 1
                self.falseButton.setImage(UIImage(named: "wrong-white"), for: .normal)
                self.falseButton.tag = 0
            }
            else {
                self.falseButton.setImage(UIImage(named: "wrong"), for: .normal)
                self.falseButton.tag = 1
                self.trueButton.setImage(UIImage(named: "check-mark"), for: .normal)
                self.trueButton.tag = 0
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
            self.trueButton.tag = 1
        }
        else if sender == falseButton {
            selectedMark = 0
            if sender.currentImage == UIImage(named: "wrong") {
                return
            }
            sender.setImage(UIImage(named: "wrong"), for: .normal)
            print("false changed to selected")
            self.falseButton.tag = 1
        }
        
        switch sender {
        case self.trueButton:
            self.falseButton.setImage(UIImage(named: "wrong-white"), for: .normal)
            print("wrong back to white")
            self.falseButton.tag = 0
            
        case self.falseButton:
            self.trueButton.setImage(UIImage(named: "check-mark"), for: .normal)
            print("true back to white")
            self.trueButton.tag = 0
            
        default:
            return
        }
    }
    
    @IBAction func onClickCreateQuestionButton(_ sender: Any) {
        if(questionTextArea.text.isEmpty || questionTextArea.textColor == .darkGray) {
            SCLAlertView().showError("Error".localized, subTitle:"Some field is empty".localized, closeButtonTitle:"Ok".localized)
        }
        else if(trueButton.tag == 0 && falseButton.tag == 0)  {
            SCLAlertView().showError("Error".localized, subTitle: "Choose true or false".localized)
        }
        else {
            let admin = Admin()
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            
            if(!isEdit) {
                let parameters = [  "question" : questionTextArea.text!,
                                    "correct_mark" : "\(selectedMark)",
                                    "chapter_id" : selectedChapterId,
                                    "explanation" : "",
                                    "level" : selectedLevel,
                                    "teacher_id" : UserDefaults.standard.string(forKey: "id")]
                
                admin.insertTFQuestion(parameters: parameters as [String : AnyObject]) {(data, error) in
                    if let response = data {
                        print(response)
                        if response.contains("inserted") {
                            self.performUIUpdatesOnMain {
                                SCLAlertView().showSuccess("Success".localized, subTitle:"Your question is added successfully".localized, closeButtonTitle:"Ok".localized)
                                self.questionTextArea.text = ""
                                self.activityIndicator.stopAnimating()
                                self.activityIndicator.isHidden = true
                                self.falseButton.setImage(UIImage(named: "wrong-white"), for: .normal)
                                self.trueButton.setImage(UIImage(named: "check-mark"), for: .normal)
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
                                  "explanation" : "",
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
        }
    }
}
