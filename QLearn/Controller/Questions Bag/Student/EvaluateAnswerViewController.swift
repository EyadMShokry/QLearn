//
//  EvaluateAnswerViewController.swift
//  El-Khateeb
//
//  Created by Eyad Shokry on 10/2/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import UIKit
import SCLAlertView

class EvaluateAnswerViewController: UIViewController {
    @IBOutlet weak var rightAnswerTextView: UITextView!
    @IBOutlet weak var isRightAnswerLabel: UILabel!
    @IBOutlet weak var tfEvaluationLabel: UILabel!
    @IBOutlet weak var idealAnswerLabel: UILabel!
    @IBOutlet weak var nextLabel: UILabel!
    @IBOutlet weak var exitLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var exitButton: UIButton!
    var correctAnswer = ""
    var questionType = ""
    var questionId = ""
    var chapterId = ""
    var isTFCorrect = true
    var delegate: DismissManager?
    var studentAnswer = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.definesPresentationContext = true
        rightAnswerTextView.layer.borderColor = UIColor.black.cgColor
        rightAnswerTextView.layer.borderWidth = 1
        rightAnswerTextView.layer.cornerRadius = 10

        self.rightAnswerTextView.text = correctAnswer
        if(questionType == "essay") {
            tfEvaluationLabel.text = nil
            idealAnswerLabel.text = "Typical answer".localized
            isRightAnswerLabel.text = "Is this answer similar to your answer?".localized
            nextLabel.text = "YES".localized
            exitLabel.text = "NO".localized

        }
        else if(questionType == "mcq") {
            tfEvaluationLabel.text = nil
            isRightAnswerLabel.text = nil
            idealAnswerLabel.text = "Typical answer".localized
            nextLabel.text = "NEXT".localized
            exitLabel.text = "EXIT".localized
        }
        else {
           
            tfEvaluationLabel.text = isTFCorrect ? "answer is correct".localized : "The answer is wrong".localized
            tfEvaluationLabel.textColor = isTFCorrect ? UIColor(displayP3Red: 13/255, green: 123/255, blue: 29/255, alpha: 1.0) : .red
            idealAnswerLabel.text = "Model explanation".localized
            if(isTFCorrect) {
                isRightAnswerLabel.text = "Is this answer similar to your answer?".localized
                nextLabel.text = "YES".localized
                exitLabel.text = "NO".localized
            }
             
            else {
                isRightAnswerLabel.isHidden = true
                nextLabel.text = "NEXT".localized
                exitLabel.isHidden = true
                exitButton.isHidden = true
            }
        }
    }
    
    @IBAction func onClickNextButton(_ sender: Any) {
        //call api here for right answer
        if(questionType == "essay") {
            //call insert correct essay answer
            let parameters = ["actual_answer": studentAnswer,
                              "question_id": questionId,
                              "student_id": UserDefaults.standard.value(forKey: "id"),
                              "type": questionType,
                              "isCorrect": "1",
                              "chapter_id": chapterId]
            let student = Student()
            student.insertAnswerWithType(method: "insert_answer.php", parameters: parameters as [String : AnyObject]) {(data, error) in
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
            
        }
        else if questionType == "TF" {
            //call insert correct TF answer
            var isCorrectParameter = ""
            if(self.nextLabel.text == "YES".localized) {
                isCorrectParameter = "1"
            }
            else {
                isCorrectParameter = "-1"
            }
            let parameters = ["actual_answer": studentAnswer,
                              "question_id": questionId,
                              "student_id": UserDefaults.standard.value(forKey: "id"),
                              "type": questionType,
                              "isCorrect": isCorrectParameter,
                              "chapter_id": chapterId]
            let student = Student()
            student.insertAnswerWithType(method: "insert_answer.php", parameters: parameters as [String : AnyObject]) {(data, error) in
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
        }
        
        
        delegate?.popoverDismiss(isExit: false)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onClickExitButton(_ sender: Any) {
        //call api here for wrong answer
        if(questionType == "essay") {
            //call insert wrong essay answer
            let parameters = ["actual_answer": studentAnswer,
                              "question_id": questionId,
                              "student_id": UserDefaults.standard.value(forKey: "id"),
                              "type": questionType,
                              "isCorrect": "-1",
                              "chapter_id": chapterId]
            let student = Student()
            student.insertAnswerWithType(method: "insert_answer.php", parameters: parameters as [String : AnyObject]) {(data, error) in
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
        }
        else if questionType == "TF"{
            //call insert wrong TF answer
            let parameters = ["actual_answer": studentAnswer,
                              "question_id": questionId,
                              "student_id": UserDefaults.standard.value(forKey: "id"),
                              "type": questionType,
                              "isCorrect": "-1",
                              "chapter_id": chapterId]
            let student = Student()
            student.insertAnswerWithType(method: "insert_answer.php", parameters: parameters as [String : AnyObject]) {(data, error) in
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
        }
        
        delegate?.popoverDismiss(isExit: true)
        self.dismiss(animated: true, completion: nil)
    }
    
}
