//
//  GoAskQusetionViewController.swift
//  El-Khateeb
//
//  Created by Abdalah on 9/29/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import UIKit
import SCLAlertView

class GoAskQusetionViewController: UIViewController {

    @IBOutlet weak var AskTextView: UITextView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        AskTextView.layer.borderColor = UIColor.white.cgColor
        AskTextView.layer.borderWidth = 3
        AskTextView.layer.cornerRadius = 15
        
        self.view.bringSubviewToFront(activityIndicator)
        activityIndicator.isHidden = true
    }
    
    @IBAction func SendAction(_ sender: Any) {
        if validate(textView: AskTextView) {
            var student: Student
            student = Student()
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            
            let parameters = ["student_id" : UserDefaults.standard.value(forKey: "id"),
                              "question" : AskTextView.text!]
            student.postAskQuestion(parameters: parameters as [String : AnyObject]) {(response, error) in
                if let response = response {
                    if response.contains("inserted") {
                        self.performUIUpdatesOnMain {
                            SCLAlertView().showSuccess("Success".localized, subTitle:"Your question is added successfully".localized, closeButtonTitle:"Ok".localized)
                            self.activityIndicator.stopAnimating()
                            self.activityIndicator.isHidden = true
                            self.AskTextView.text = ""
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
            self.performUIUpdatesOnMain {
                SCLAlertView().showError("Error".localized, subTitle:"Some field is empty".localized, closeButtonTitle:"Ok".localized)
            }
        }
    }
    
    func validate(textView: UITextView) -> Bool {
        guard let text = textView.text,
            !text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty else {
                return false
        }
        
        return true
        
    }

}
