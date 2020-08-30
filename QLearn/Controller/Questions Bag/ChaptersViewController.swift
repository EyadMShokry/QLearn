//
//  ChaptersViewController.swift
//  El-Khateeb
//
//  Created by Eyad Shokry on 9/20/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import UIKit
import SCLAlertView
import TableFlip

class ChaptersViewController: UIViewController {
    @IBOutlet weak var chaptersTableView: UITableView!
    @IBOutlet weak var addChapterButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var chaptersArray: [ChapterResult] = []
    var rightAnswersArray: [RightAnswersResult] = []
    var chaptersPercent: [String] = []
    var questionType = ""
    let fadeAnimation = TableViewAnimation.Cell.fade(duration: 0.7)
    
    private func setChaptersProgress() {
        for i in (0..<chaptersArray.count) {
            let chapterFullCount = Int(chaptersArray[i].questions_count)!
            
            var chapterRightAnswers = 0
            for m in (0..<rightAnswersArray.count) {
                if(chaptersArray[i].id == rightAnswersArray[m].chapter_id) {
                    chapterRightAnswers = Int(rightAnswersArray[m].right_count)!
                }
            }
            var chapterProgress: Float = 0
            if chapterFullCount != 0 {
                chapterProgress = Float(chapterRightAnswers)/Float(chapterFullCount)*100
                chaptersArray[i].rightAnswersPercent = String(Int(chapterProgress))
            }
            else {
                chaptersArray[i].rightAnswersPercent = "0%"
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.chaptersArray.removeAll()
        var student: Student
        student = Student()
        self.view.bringSubviewToFront(activityIndicator)
        activityIndicator.startAnimating()

        let parameters = ["student_id" : UserDefaults.standard.value(forKey: "id"),
                          "type" : questionType]
        student.getRightAnswersCount(parameters: parameters as [String : AnyObject]) {(rightAnswers, error) in
            if let answers = rightAnswers?.RESULT {
                self.rightAnswersArray = answers
                if(self.questionType == "mcq") {
                    //call select chapters in mcq questions
                    student.getChaptersInQuestions(pathExtension: "select_chapters_in_mcq_questions.php") {(chapters, error) in
                        if let chapters = chapters {
                            self.chaptersArray = chapters.RESULT
                            self.setChaptersProgress()
                            self.performUIUpdatesOnMain {
                                self.activityIndicator.stopAnimating()
                                self.activityIndicator.isHidden = true
                                self.chaptersTableView.reloadData()
                                self.chaptersTableView.animate(animation: self.fadeAnimation)
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
                else if(self.questionType == "essay") {
                    //call select chapters in essay questions
                    student.getChaptersInQuestions(pathExtension: "select_chapters_in_essay_questions.php") {(chapters, error) in
                        if let chapters = chapters {
                            self.chaptersArray = chapters.RESULT
                            self.setChaptersProgress()
                            self.performUIUpdatesOnMain {
                                self.activityIndicator.stopAnimating()
                                self.activityIndicator.isHidden = true
                                self.chaptersTableView.reloadData()
                                self.chaptersTableView.animate(animation: self.fadeAnimation)
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
                else if(self.questionType == "TF") {
                    //call select chapters in true and false questions
                    student.getChaptersInQuestions(pathExtension: "select_chapters_in_trueFalse_questions.php") {(chapters, error) in
                        if let chapters = chapters {
                            self.chaptersArray = chapters.RESULT
                            self.setChaptersProgress()
                            self.performUIUpdatesOnMain {
                                self.activityIndicator.stopAnimating()
                                self.activityIndicator.isHidden = true
                                self.chaptersTableView.reloadData()
                                self.chaptersTableView.animate(animation: self.fadeAnimation)
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
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if(UserDefaults.standard.value(forKey: "admin_name") == nil) {
            addChapterButton.isHidden = true
        }

        self.chaptersTableView?.rowHeight = 250.0

        chaptersTableView.dataSource = self
        chaptersTableView.delegate = self
        chaptersTableView.separatorColor = .clear
        
    
    }
    

    @IBAction func onClickAddChapterButton(_ sender: UIButton) {
        let appearence = SCLAlertView.SCLAppearance(
            showCloseButton: false, showCircularIcon: true
        )
        let addNewChapterAlertView = SCLAlertView(appearance: appearence)
        let newChapterTextField = addNewChapterAlertView.addTextField("Add new chapter".localized)
        newChapterTextField.textAlignment = .center
        
        addNewChapterAlertView.addButton("Add".localized) {
            if(newChapterTextField.text!.isEmpty) {
                SCLAlertView().showError("Error".localized, subTitle:"Some field is empty".localized, closeButtonTitle:"Ok".localized)
            }
            else {
                SCLAlertView().showSuccess("Success".localized, subTitle:"is added successfully".localized, closeButtonTitle:"Ok".localized)
                
                print("call api here to add new chapter")
            }
        }
        addNewChapterAlertView.addButton("Cancal".localized)
 {
            addNewChapterAlertView.dismiss(animated: true, completion: nil)
            
        }
        
        let alertViewIcon = UIImage(named: "book")
        addNewChapterAlertView.showInfo("Add new chapter".localized
, subTitle: "", circleIconImage: alertViewIcon)
    }
    
    func insertNewChapter(){
        let indexPath = IndexPath(row: chaptersArray.count - 1, section: 0)
        chaptersTableView.insertRows(at: [indexPath], with: .left)
        chaptersTableView.reloadData()
    }
    
    
}



extension ChaptersViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chaptersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chapterCell = tableView.dequeueReusableCell(withIdentifier: "ChapterCell") as! ChapterTableViewCell
        chapterCell.chapterLabel.text = chaptersArray[indexPath.row].title
        chapterCell.CalculatesProgress.text = "\(chaptersArray[indexPath.row].rightAnswersPercent!)%"
//        chapterCell.progressBar.setProgress(to: Double(chaptersArray[indexPath.row].rightAnswersPercent)!/100, withAnimation: true)
        chapterCell.progress = Double(chaptersArray[indexPath.row].rightAnswersPercent)!/100
        chapterCell.updateProgress()
        return chapterCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(questionType == "essay") {
            let questionsTypesVC = storyboard?.instantiateViewController(withIdentifier: "AvailableTypes") as! AvailableTypesViewController
            questionsTypesVC.isPdf = false
            questionsTypesVC.chapterName = chaptersArray[indexPath.row].title
            questionsTypesVC.selectedChapterId = chaptersArray[indexPath.row].id
            self.navigationController?.pushViewController(questionsTypesVC, animated: true)

        }
        else if(questionType == "mcq") {
            //in teacher case
            
//            let createMcqQuestionVC = storyboard?.instantiateViewController(withIdentifier: "CreateMCQQuestion")
//            createMcqQuestionVC?.title = chaptersArray[indexPath.row]
//            self.navigationController?.pushViewController(createMcqQuestionVC!, animated: true)
            let answerMcqVC = storyboard?.instantiateViewController(withIdentifier: "CheckQuestionStudent") as! CheckQuestionViewController
            answerMcqVC.title = chaptersArray[indexPath.row].title
            answerMcqVC.selectedChapterId = chaptersArray[indexPath.row].id
            
            self.navigationController?.pushViewController(answerMcqVC, animated: true)

        }
        else if(questionType == "TF") {
//            let createTrueFalseVC = storyboard?.instantiateViewController(withIdentifier: "TrueFalseQuestion")
//            createTrueFalseVC?.title = chaptersArray[indexPath.row]
//            self.navigationController?.pushViewController(createTrueFalseVC!, animated: true)
            let answerTrueFalseVC = storyboard?.instantiateViewController(withIdentifier: "TrueFalseQuestionStudent") as! TrueFalseQuestionStudentViewController
            answerTrueFalseVC.title = chaptersArray[indexPath.row].title
            answerTrueFalseVC.selectedChapterId = chaptersArray[indexPath.row].id
            self.navigationController?.pushViewController(answerTrueFalseVC, animated: true)

        }
    }
}
