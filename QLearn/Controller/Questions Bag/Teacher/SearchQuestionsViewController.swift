//
//  SearchQuestionsViewController.swift
//  El-Khateeb
//
//  Created by Eyad Shokry on 9/22/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import UIKit
import SCLAlertView
import TableFlip

class SearchQuestionsViewController: UIViewController {
    @IBOutlet weak var questionsSearchBar: UISearchBar!
    @IBOutlet weak var questionsTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var noDataView: UIView!
    var questionsType = ""
    var questionsArray: [FullQuestionResult] = []
    var filteredQuestions: [FullQuestionResult] = []
    let fadeAnimation = TableViewAnimation.Cell.fade(duration: 0.7)
    var selectedLevel = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        let admin = Admin()
        if(questionsType == "mcq") {
            let parameters = ["q_type" : "mcq",
                              "teacher_id" : UserDefaults.standard.string(forKey: "id"),
                              "level" : selectedLevel]
            admin.selectAllQuestions(parameters: parameters as [String : AnyObject]) {(data, error) in
                if let questions = data {
                    self.questionsArray = questions.RESULT
                    self.filteredQuestions = self.questionsArray
                    self.performUIUpdatesOnMain {
                        if(self.questionsArray.count > 0) {
                            self.activityIndicator.stopAnimating()
                            self.activityIndicator.isHidden = true
                            self.questionsTableView.reloadData()
                            self.questionsTableView.animate(animation: self.fadeAnimation)
                        }
                        else {
                            //show no questions view
                            self.activityIndicator.stopAnimating()
                            self.activityIndicator.isHidden = true
                            self.noDataView.isHidden = false
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
        else if(questionsType == "essay") {
            let parameters = ["q_type" : "essay",
                              "teacher_id" : UserDefaults.standard.string(forKey: "id"),
                              "level" : selectedLevel]
            admin.selectAllQuestions(parameters: parameters as [String : AnyObject]) {(data, error) in
                if let questions = data {
                    self.questionsArray = questions.RESULT
                    self.filteredQuestions = self.questionsArray
                    self.performUIUpdatesOnMain {
                        if(self.questionsArray.count > 0) {
                            self.activityIndicator.stopAnimating()
                            self.activityIndicator.isHidden = true
                            self.questionsTableView.reloadData()
                            self.questionsTableView.animate(animation: self.fadeAnimation)
                        }
                        else {
                            //show no questions view
                            self.activityIndicator.stopAnimating()
                            self.activityIndicator.isHidden = true
                            self.noDataView.isHidden = false
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
            
        else {
            let parameters = ["q_type" : "tf",
                              "teacher_id" : UserDefaults.standard.string(forKey: "id"),
                              "level" : selectedLevel]
            admin.selectAllQuestions(parameters: parameters as [String : AnyObject]) {(data, error) in
                if let questions = data {
                    self.questionsArray = questions.RESULT
                    self.filteredQuestions = self.questionsArray
                    self.performUIUpdatesOnMain {
                        if(self.questionsArray.count > 0) {
                            self.activityIndicator.stopAnimating()
                            self.activityIndicator.isHidden = true
                            self.questionsTableView.reloadData()
                            self.questionsTableView.animate(animation: self.fadeAnimation)
                        }
                        else {
                            //show no questions view
                            self.activityIndicator.stopAnimating()
                            self.activityIndicator.isHidden = true
                            self.noDataView.isHidden = false
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        questionsTableView.dataSource = self
        questionsTableView.delegate = self
        questionsSearchBar.delegate = self
    
    }
   
    func deleteQuestion(cell: SearchQuestionsTableViewCell) {
        print("delete")
        let appearence = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        let deleteAlertView = SCLAlertView(appearance: appearence)
        
        deleteAlertView.addButton("Delete".localized) {
            let indexPathTapped = self.questionsTableView.indexPath(for: cell)
            let selectedQuestion = self.filteredQuestions[(indexPathTapped?.row)!]
            
            let admin = Admin()
            let parameters = ["id" : selectedQuestion.id]
            
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            admin.deleteMcqQuestions(parameters: parameters as [String : AnyObject], completion: { (response, error) in
                if let response = response {
                    if response.contains("inserted") {
                        self.performUIUpdatesOnMain {
                            self.activityIndicator.stopAnimating()
                            self.activityIndicator.isHidden = true
                            SCLAlertView().showSuccess("Success".localized, subTitle: "Question is deleted successfully".localized)
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
            })
            
            self.filteredQuestions.remove(at: indexPathTapped!.row)
            self.questionsTableView.deleteRows(at: [indexPathTapped!], with: .fade)
        }
        deleteAlertView.addButton("Cancal".localized) {
            deleteAlertView.dismiss(animated: true, completion: nil)
        }
        deleteAlertView.showWarning("Delete Question".localized, subTitle: "Are you sure, you want to delete this question?".localized)
    }
    
    func editQuestion(cell: SearchQuestionsTableViewCell) {
        print("edit")
        let indexPathTapped = self.questionsTableView.indexPath(for: cell)
        let selectedQuestion = self.filteredQuestions[(indexPathTapped?.row)!]

        if(questionsType == "mcq") {
            print("mcq")
            let editQuestionVC = storyboard?.instantiateViewController(withIdentifier: "CreateMCQQuestion") as! CreateMcqQuestionViewController
            editQuestionVC.isEdit = true
            editQuestionVC.editQuestionText = selectedQuestion.question
            editQuestionVC.editAnswer1Text = selectedQuestion.choice1
            editQuestionVC.editAnswer2Text = selectedQuestion.choice2
            editQuestionVC.editAnswer3Text = selectedQuestion.choice3
            editQuestionVC.editAnswer4Text = selectedQuestion.choice4
            editQuestionVC.selectedAnswer = Int(selectedQuestion.correct_answer)!
            editQuestionVC.selectedQuestionId = selectedQuestion.id
            editQuestionVC.selectedLevel = self.selectedLevel
            
            self.navigationController?.pushViewController(editQuestionVC, animated: true)
        }
        else if(questionsType == "essay") {
            print("essay")
            let editQuestionVC = storyboard?.instantiateViewController(withIdentifier: "EssayQuestion") as! CreateEssayQuestionViewController
            editQuestionVC.isEdit = true
            editQuestionVC.editQuestionText = selectedQuestion.question
            editQuestionVC.editAnswerText = selectedQuestion.correct_answer
            editQuestionVC.selectedQuestionId = selectedQuestion.id

            self.navigationController?.pushViewController(editQuestionVC, animated: true)
        }
        else if(questionsType == "TF") {
            print("true & false")
            let editQuestionVC = storyboard?.instantiateViewController(withIdentifier: "TrueFalseQuestion") as! CreateTrueFalseQuestionViewController
            editQuestionVC.isEdit = true
            editQuestionVC.editQuestionText = selectedQuestion.question
            editQuestionVC.editReasonText = selectedQuestion.explanation
            editQuestionVC.previousAnswer = selectedQuestion.correct_mark == "0" ? false : true
            editQuestionVC.selectedQuestionId = selectedQuestion.id
            
            self.navigationController?.pushViewController(editQuestionVC, animated: true)
        }
    }

}


extension SearchQuestionsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredQuestions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let questionCell = tableView.dequeueReusableCell(withIdentifier: "SearchQuestionCell") as! SearchQuestionsTableViewCell
        questionCell.searchQuestionsVC = self
        questionCell.questionLabel.text = filteredQuestions[indexPath.row].question
        
        return questionCell
    }
    
}


extension SearchQuestionsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredQuestions = searchText.isEmpty ? questionsArray : questionsArray.filter {
            
            $0.question.contains(searchText)
            
        }
        questionsTableView.reloadData()
        
        if searchBar.text?.count == 0{
      
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
       
    }
    
}
