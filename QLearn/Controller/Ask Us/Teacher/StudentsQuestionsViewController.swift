//
//  StudentsQuestionsViewController.swift
//  El-Khateeb
//
//  Created by Eyad Shokry on 10/10/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import UIKit
import TableFlip
import SCLAlertView

class StudentsQuestionsViewController: UIViewController {
    @IBOutlet weak var noQuestionsView: UIView!
    @IBOutlet weak var questionsTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var questionsArray: [QuestionResult] = []
    let fadeAnimation = TableViewAnimation.Cell.fade(duration: 0.7)
    var selectedLevel = ""

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let admin = Admin()
        let parameters = ["level" : selectedLevel,
                          "teacher_id" : UserDefaults.standard.string(forKey: "id")]
        print(parameters)
        admin.getStudentsQuestion(parameters: parameters as [String : AnyObject]) { (questions, error) in
            if let questions = questions {
                self.questionsArray = questions.RESULT
                self.performUIUpdatesOnMain {
                    if(self.questionsArray.count == 0) {
                        self.noQuestionsView.isHidden = false
                    }
                    else {
                        self.noQuestionsView.isHidden = true
                    }
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    self.questionsTableView.reloadData()
                    self.questionsTableView.animate(animation: self.fadeAnimation)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        questionsTableView.rowHeight = 100
        questionsTableView.dataSource = self
    
        questionsTableView.delegate = self
        questionsTableView.separatorColor = .clear
    }
    

    

}


extension StudentsQuestionsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let questionCell = tableView.dequeueReusableCell(withIdentifier: "AskUsCell") as! AskUsTableViewCell
        questionCell.questionLabel.text = questionsArray[indexPath.row].question
        
        return questionCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let answerQuestionVC = storyboard?.instantiateViewController(withIdentifier: "AnswerQuestion") as! AnswerQuestionViewController
        answerQuestionVC.selectedQuestionId = questionsArray[indexPath.row].id
        answerQuestionVC.selectedLevel = self.selectedLevel
        self.navigationController?.pushViewController(answerQuestionVC, animated: true)
    }
}
