//
//  AnswerQuestionViewController.swift
//  El-Khateeb
//
//  Created by Eyad Shokry on 9/23/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import UIKit
import SCLAlertView

class AnswerQuestionViewController: UIViewController {
    @IBOutlet weak var chaptersPickerView: UIPickerView!
    @IBOutlet weak var answerTextArea: UITextView!
    @IBOutlet weak var sendAnswerButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var chaptersArray: [ChapterResult] = []
    var selectedChapter: String = ""
    var selectedChapterId = ""
    var selectedCellRow: Int = 0
    var selectedQuestionId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        answerTextArea.layer.borderColor = UIColor.white.cgColor
        answerTextArea.layer.borderWidth = 2
        answerTextArea.layer.cornerRadius = 10
        answerTextArea.text = "The correct answer ..".localized
        answerTextArea.textColor = .darkGray
        answerTextArea.delegate = self
        
        chaptersPickerView.dataSource = self
        chaptersPickerView.delegate = self
        
        let admin = Admin()
        admin.getAllChapters { (chapters, error) in
            if let chapters = chapters {
                print(chapters)
                self.chaptersArray = chapters.RESULT
                self.performUIUpdatesOnMain {
                    self.selectedChapter = self.chaptersArray.count > 0 ? self.chaptersArray[0].title : ""
                    self.selectedChapterId = self.chaptersArray.count > 0 ? self.chaptersArray[0].id : ""
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    self.chaptersPickerView.reloadAllComponents()
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
            }        }
    }
    

    @IBAction func onClickSendAnswerButton(_ sender: UIButton) {
        if(answerTextArea.text.isEmpty || answerTextArea.textColor == .darkGray) {
            SCLAlertView().showError("Error".localized, subTitle:"Some field is empty".localized, closeButtonTitle:"Ok".localized)
        }
        else {
            let parameters = ["question_id" : selectedQuestionId,
                              "chapter_id" : selectedChapterId,
                              "answer" : answerTextArea.text!]
            let admin = Admin()
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            admin.insertQuestionAnswer(parameters: parameters as [String : AnyObject]) { (response, error) in
                if let response = response {
                    if response.contains("inserted") {
                        self.performUIUpdatesOnMain {
                            self.activityIndicator.stopAnimating()
                            self.activityIndicator.isHidden = true
                            
                            let appearance = SCLAlertView.SCLAppearance(
                                showCloseButton: false
                            )
                            let successAlertView = SCLAlertView(appearance: appearance)
                            successAlertView.addButton("Ok".localized, action: {
                                successAlertView.dismiss(animated: true, completion: nil)
                            self.navigationController?.popViewController(animated: true)
                            })
                            successAlertView.showSuccess("Success".localized, subTitle: "Question is answered successfully".localized)
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


extension AnswerQuestionViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.darkGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
                textView.text = "The correct answer ..".localized
                textView.textColor = .darkGray

        }
    }
}

extension AnswerQuestionViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return chaptersArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return chaptersArray[row].title
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedChapter = chaptersArray[row].title
        selectedChapterId = chaptersArray[row].id
    }
}
