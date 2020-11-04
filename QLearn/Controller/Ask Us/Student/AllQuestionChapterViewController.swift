//
//  AllQuestionChapterTableView.swift
//  El-Khateeb
//
//  Created by Abdalah on 9/27/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import UIKit
import SCLAlertView
import TableFlip

class AllQuestionChapterViewController: UIViewController {
    @IBOutlet var TableQuestion: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var chaptersArray: [ChapterResult] = []
    var isAskQuestion = true
    var questionType = ""
    let fadeAnimation = TableViewAnimation.Cell.fade(duration: 0.7)
    var teacherId = ""
    var selectedLevel = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(UserDefaults.standard.string(forKey: "type") != "teacher") {
            headerView.isHidden = true
        }
        
        TableQuestion.rowHeight = 148.0
        self.view.bringSubviewToFront(activityIndicator)
        
        //        if(isAskQuestion) {
        var user: SchoolUser
        user = SchoolUser()
        var parameters = ["":""]
        if(UserDefaults.standard.string(forKey: "type") == "student") {
            parameters = ["level" : UserDefaults.standard.string(forKey: "student_level")!,
                          "teacherID" : self.teacherId]
        }
        else {
            parameters = ["level" : selectedLevel, "teacherID" : UserDefaults.standard.string(forKey: "id")!]
        }
        activityIndicator.startAnimating()
        user.getAllChapters(parameters: parameters as [String : AnyObject]) {(data, error) in
            if let chapters = data {
                self.chaptersArray = chapters.RESULT
                self.performUIUpdatesOnMain {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    self.TableQuestion.reloadData()
                    self.TableQuestion.animate(animation: self.fadeAnimation)
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
    
    
    @IBAction func onClickAddNewChapterButton(_ sender: UIButton) {
        let appearence = SCLAlertView.SCLAppearance(
            showCloseButton: false, showCircularIcon: true
        )
        let addNewChapterAlertView = SCLAlertView(appearance: appearence)
        let newChapterTextField = addNewChapterAlertView.addTextField("Add New Chapter")
        
        newChapterTextField.textAlignment = .center
        
        addNewChapterAlertView.addButton("Add".localized) {
            if(newChapterTextField.text!.isEmpty) {
                SCLAlertView().showError("Error".localized, subTitle:"Some field is empty".localized, closeButtonTitle:"Ok".localized)
            }
            else {
                let parameters = ["title" : newChapterTextField.text!, "level" : self.selectedLevel, "teacherID" : UserDefaults.standard.string(forKey: "id")!] as [String : Any]
                let admin = Admin()
                self.chaptersArray.removeAll()
                
                self.activityIndicator.isHidden = false
                self.activityIndicator.startAnimating()
                admin.insertChapter(parameters: parameters as [String : AnyObject]) {(data, error) in
                    if let response = data{
                        if response.contains("inserted"){
                            self.performUIUpdatesOnMain {
                                let parameters = ["level" : self.selectedLevel, "teacherID" : UserDefaults.standard.string(forKey: "id")!]
                                admin.getAllChapters(parameters: parameters as [String : AnyObject]) {(data, error) in
                                    if let chapters = data {
                                        self.chaptersArray = chapters.RESULT
                                        self.performUIUpdatesOnMain {
                                            SCLAlertView().showSuccess("Success".localized, subTitle:"New chapter is added successfully", closeButtonTitle:"Ok".localized)
                                            
                                            self.TableQuestion.reloadData()
                                            self.activityIndicator.stopAnimating()
                                            self.activityIndicator
                                                .isHidden = true
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
                                            self.activityIndicator
                                                .isHidden = true
                                        }
                                    }
                                }
                            }
                        }
                        else{
                            self.performUIUpdatesOnMain {
                                SCLAlertView().showError("Error".localized, subTitle: "Server Error, please contact with applications author".localized, closeButtonTitle:"Ok".localized)
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
                        self.performUIUpdatesOnMain {
                            self.activityIndicator.stopAnimating()
                            self.activityIndicator.isHidden = true
                        }
                        print(error)
                    }
                }
            }
        }
        addNewChapterAlertView.addButton("Cancal".localized) {
            addNewChapterAlertView.dismiss(animated: true, completion: nil)
            
        }
        
        let alertViewIcon: UIImage
        alertViewIcon = UIImage(named: "book")!
        addNewChapterAlertView.showInfo("Add New Chapter", subTitle: "", circleIconImage: alertViewIcon)
    }
    
}
//
extension AllQuestionChapterViewController:UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return chaptersArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllQuestionChapterCell") as! AllQuestionChapterCell
        cell.QuestionLable.text = chaptersArray[indexPath.row].title
        if(UserDefaults.standard.value(forKey: "admin_name") != nil) {
            let holdToEditGestureRecognizer = LongPressGesture(target: self, action: #selector(AllQuestionChapterViewController.updateChapter))
            holdToEditGestureRecognizer.minimumPressDuration = 1.00
            holdToEditGestureRecognizer.title = chaptersArray[indexPath.row].title
            holdToEditGestureRecognizer.selectedId = chaptersArray[indexPath.row].id
            cell.addGestureRecognizer(holdToEditGestureRecognizer)
        }
        
        return cell
    }
    
    @objc func updateChapter(sender: LongPressGesture) {
        if(sender.state == .ended) {
            print("long tap is done")
            let appearence = SCLAlertView.SCLAppearance(
                showCloseButton: false, showCircularIcon: true
            )
            
            let editChapterAlertView = SCLAlertView(appearance: appearence)
            let chapterTextField = editChapterAlertView.addTextField(NSLocalizedString("Chapter name", comment: ""))
            chapterTextField.textAlignment = .center
            chapterTextField.text = sender.title
            
            editChapterAlertView.addButton("Edit".localized) {
                if(chapterTextField.text!.isEmpty) {
                    SCLAlertView().showError("Error".localized, subTitle:"Some field is empty".localized, closeButtonTitle:"Ok".localized)
                }
                else {
                    //                    let admin = Admin()
                    //                    let parameters = ["id" : sender.selectedId,
                    //                                      "phone" : chapterTextField.text!]
                    //
                    //                    self.activityIndicator.isHidden = false
                    //                    self.activityIndicator.startAnimating()
                    
                    //call edit chapter api here
                }
            }
            
            editChapterAlertView.addButton("Cancal".localized) {
                editChapterAlertView.dismiss(animated: true, completion: nil)
            }
            
            let alertViewIcon = UIImage(named: "book")
            editChapterAlertView.showInfo(
                "Chapters".localized, subTitle: "Edit chapter name".localized, circleIconImage: alertViewIcon)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (isAskQuestion) {
            let questionsVC = storyboard?.instantiateViewController(withIdentifier: "MyQuestions") as! MyQuestionsViewController
            questionsVC.isMyQuestion = false
            questionsVC.selectedChapterId = chaptersArray[indexPath.row].id
            questionsVC.selectedChapterName = chaptersArray[indexPath.row].title
            questionsVC.teacherId = self.teacherId
            self.navigationController?.pushViewController(questionsVC, animated: true)
        }
            
            //lma yb2a question bag as teacher elly da5l
        else {
            if(questionType == "mcq") {
                let askMcqQuestionVC = storyboard?.instantiateViewController(withIdentifier: "CreateMCQQuestion") as! CreateMcqQuestionViewController
                askMcqQuestionVC.selectedChapterId = chaptersArray[indexPath.row].id
                askMcqQuestionVC.selectedLevel = self.selectedLevel
                navigationController?.pushViewController(askMcqQuestionVC, animated: true)
                
            }
            else if(questionType == "essay") {
                let essayTypesVC = storyboard?.instantiateViewController(withIdentifier: "AvailableTypes") as! AvailableTypesViewController
                essayTypesVC.isPdf = false
                essayTypesVC.selectedChapterId = chaptersArray[indexPath.row].id
                essayTypesVC.selectedLevel = self.selectedLevel
                navigationController?.pushViewController(essayTypesVC, animated: true)
                
            }
            else {
                let askTFQuestionVC = storyboard?.instantiateViewController(withIdentifier: "TrueFalseQuestion") as! CreateTrueFalseQuestionViewController
                askTFQuestionVC.selectedChapterId = chaptersArray[indexPath.row].id
                askTFQuestionVC.selectedLevel = self.selectedLevel
                navigationController?.pushViewController(askTFQuestionVC, animated: true)
            }
        }
    }
}

