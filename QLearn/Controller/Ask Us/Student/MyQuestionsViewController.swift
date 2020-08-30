//
//  MyQuestionsViewController.swift
//  El-Khateeb
//
//  Created by Eyad Shokry on 9/25/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import UIKit
import SCLAlertView
import TableFlip

class MyQuestionsViewController: UIViewController {
    @IBOutlet weak var myQuestionsTableView: UITableView!
    @IBOutlet weak var questionView: UIView!
    @IBOutlet weak var askButton: UIButton!
    @IBOutlet weak var chapterLabel: UILabel!
    @IBOutlet weak var noQuestionsView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var myQuestionsArray: [QuestionResult] = []
    var isMyQuestion = true
    var selectedChapterId = ""
    var selectedChapterName = ""
    let fadeAnimation = TableViewAnimation.Cell.fade(duration: 0.7)

    override func viewDidLoad() {
        super.viewDidLoad()
         askButton.setTitle("ASK!".localized, for: .normal)
        var student: Student
        student = Student()

        // Do any additional setup after loading the view.
        myQuestionsTableView.dataSource = self
        myQuestionsTableView.delegate = self
        
        questionView.layer.cornerRadius = questionView.frame.size.width/2
        questionView.clipsToBounds = true
        questionView.layer.borderWidth = 1
        questionView.layer.borderColor = UIColor(displayP3Red: 39/255, green: 170/255, blue: 225/255, alpha: 1).cgColor
        
        askButton.layer.borderColor = UIColor(displayP3Red: 39/255, green: 170/255, blue: 225/255, alpha: 1).cgColor
        askButton.layer.borderWidth = 1
        askButton.layer.cornerRadius = 15
        
        if(isMyQuestion) {
            //fire as2lt el talb
            self.chapterLabel.text = "My Questions"
            let parameters = ["student_id" : UserDefaults.standard.value(forKey: "id")]
            student.getStudentQuestions(parameters: parameters as [String : AnyObject]) {(data, error) in
                if let questions = data {
                    self.myQuestionsArray = questions.RESULT
                    if(self.myQuestionsArray.count > 0) {
                        self.performUIUpdatesOnMain {
                            self.activityIndicator.stopAnimating()
                            self.activityIndicator.isHidden = true
                            self.myQuestionsTableView.reloadData()
                            self.myQuestionsTableView.animate(animation: self.fadeAnimation)
                        }
                    }
                    else {
                        self.performUIUpdatesOnMain {
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
                        self.activityIndicator.stopAnimating()
                        self.activityIndicator.isHidden = true
                    }
                }

            }
        }
        else {
            //fire as2lt el chapter da le kol el tolab
            self.chapterLabel.text = selectedChapterName
            let parameters = ["chapter_id" : selectedChapterId]
            student.getChapterAskedQuestions(parameters: parameters as [String : AnyObject]) {(data, error) in
                if let questions = data {
                    self.myQuestionsArray = questions.RESULT
                    if(self.myQuestionsArray.count > 0) {
                        self.performUIUpdatesOnMain {
                            self.activityIndicator.stopAnimating()
                            self.activityIndicator.isHidden = true
                            self.myQuestionsTableView.reloadData()
                            self.myQuestionsTableView.animate(animation: self.fadeAnimation)
                        }
                    }
                    else {
                        self.performUIUpdatesOnMain {
                            self.view.bringSubviewToFront(self.noQuestionsView)
                            self.noQuestionsView.isHidden = false
                        }
                    }
                }
                else if let error = error {
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
    

}


extension MyQuestionsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myQuestionsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myQuestionCell = tableView.dequeueReusableCell(withIdentifier: "MyQuestionCell") as! MyQuestionsTableViewCell
        myQuestionCell.cellView.text = myQuestionsArray[indexPath.row].question
        
        return myQuestionCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let questionAnswerVC = storyboard?.instantiateViewController(withIdentifier: "GoQusetionAnswer") as! GoQusetionAnswerViewController
        questionAnswerVC.questionText = myQuestionsArray[indexPath.row].question
        questionAnswerVC.answerText = myQuestionsArray[indexPath.row].answer
        
        navigationController?.pushViewController(questionAnswerVC, animated: true)
    }
}
