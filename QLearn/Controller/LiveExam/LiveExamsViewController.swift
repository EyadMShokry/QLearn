//
//  LiveExamsViewController.swift
//  QLearn
//
//  Created by Eyad Shokry on 1/2/21.
//  Copyright © 2021 Eyad Shokry. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import SCLAlertView

class LiveExamsViewController: UIViewController {
    @IBOutlet weak var examsTableView: UITableView!
    @IBOutlet weak var addExamButton: UIButton!
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    var teacherId = ""
    var examsArray: [Exam] = []
    var rightAnswersCountArray: [RightAnswersCountExam] = []
    var rightAnswersCountFullArray: [String] = []
    var notAnsweredMcqQuestionsArray: [NotAnsweredMcqQuestion] = []
    
    fileprivate func adjustActivityIndicator() {
        self.view.bringSubviewToFront(activityIndicator)
        activityIndicator.type = .ballScaleRipple
        activityIndicator.color = UIColor(displayP3Red: 196/255, green: 137/255, blue: 191/255, alpha: 1)
    }
    
    fileprivate func getOnGoingExams() {
        NetworkingService.shared.provider.request(.selectOnGoingExamsLE(teacher_id: self.teacherId, level: UserDefaults.standard.string(forKey: "student_level")!)) {[weak self] (result) in
            switch result {
            case .success(let response) :
                do {
                    let exams = try JSONDecoder().decode(ExamResult.self, from: response.data)
                    self?.examsArray = exams.response.exams
                    self?.performUIUpdatesOnMain {
                        self?.examsTableView.reloadData()
                    }
                }
                catch {
                    print(error)
                }
            case .failure(let err) :
                print(err)
            }
        }
    }
    
    fileprivate func getCountOfRightAnsweredQuestionsLE() {
        NetworkingService.shared.provider.request(.selectCountOfRightAnsweredTypeLE(studentID: UserDefaults.standard.string(forKey: "id")!, questionType: "mcq")) {[weak self] (result) in
            switch result {
            case .success(let response) :
                do {
                    let rightAnswersCount = try JSONDecoder().decode(RightAnswersCountLE.self, from: response.data)
                    self?.rightAnswersCountArray = rightAnswersCount.response.exams
                    var isFound = false
                    for exam in self!.examsArray {
                        for rightCount in self!.rightAnswersCountArray {
                            if(exam.id == rightCount.exam_id) {
                                self!.rightAnswersCountFullArray.append(rightCount.right_count)
                                isFound = true
                            }
                        }
                        if(!isFound) {
                            self!.rightAnswersCountFullArray.append("0")
                        }
                    }
                    print("Right count:")
                    print(self!.rightAnswersCountFullArray)
                    self?.performUIUpdatesOnMain {
                        self?.examsTableView.reloadData()
                    }
                }
                catch {
                    print(error)
                }
                
            case .failure(let err) :
                print(err)
            }
        }
    }
    
    fileprivate func getNotAnsweredMCQQuestions(examId: String, finished: @escaping (_ success : Bool) -> Void) {
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        NetworkingService.shared.provider.request(.selectNotAnswerdMcqQuestionsLE(exam_id: examId, teacher_id: self.teacherId, student_id: UserDefaults.standard.string(forKey: "id")!, level: UserDefaults.standard.string(forKey: "student_level")!)) {[weak self] (result) in
            var success = false
            switch result {
            case .success(let response) :
                do {
                    let questions = try JSONDecoder().decode(NotAnsweredMCQQuestions.self, from: response.data)
                    self?.notAnsweredMcqQuestionsArray = questions.response.questions
                    success = true
                }
                catch {
                    print(error)
                    success = false
                    self?.performUIUpdatesOnMain {
                        SCLAlertView().showError("Error happened", subTitle: "Server error happened. please check your internet connection or contact with application's author", closeButtonTitle:"Ok".localized)
                    }
                }
            case .failure(let err) :
                print(err)
                success = false
                self?.performUIUpdatesOnMain {
                    SCLAlertView().showError("Error happened", subTitle: "Server error happened. please check your internet connection or contact with application's author", closeButtonTitle:"Ok".localized)
                }
                self?.performUIUpdatesOnMain {
                    self?.activityIndicator.isHidden = true
                    self?.activityIndicator.stopAnimating()
                }
            }
            finished(success)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        examsTableView.dataSource = self
        examsTableView.delegate = self
        examsTableView.rowHeight = 250
        adjustActivityIndicator()
        
        if(UserDefaults.standard.string(forKey: "type") == "student") {
            self.addExamButton.isHidden = true
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            let dispatchGroup = DispatchGroup()
            
            dispatchGroup.enter()
            self.getOnGoingExams()
            dispatchGroup.leave()
            
            dispatchGroup.enter()
            self.getCountOfRightAnsweredQuestionsLE()
            dispatchGroup.leave()
            
            dispatchGroup.notify(queue: .main) {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
            }
        }
        else {
            addExamButton.isHidden = false
            //call get all exams for teacher
        }
    }
    
    @IBAction func onClickAddExamButton(_ sender: UIButton) {
        
    }
    
    
}


extension LiveExamsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rightAnswersCountFullArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let examCell = tableView.dequeueReusableCell(withIdentifier: "ChapterCell") as! ChapterTableViewCell
        examCell.chapterLabel.text = examsArray[indexPath.row].title
        examCell.examTimeLabel.text = examsArray[indexPath.row].examduration + ":00"
        examCell.CalculatesProgress.text = String( (Double(rightAnswersCountFullArray[indexPath.row])! / Double(examsArray[indexPath.row].no_of_questions)) * 100 ) + "%"
        print( String( (Int(rightAnswersCountFullArray[indexPath.row])! / Int(examsArray[indexPath.row].no_of_questions)) * 100 ))
        examCell.questionsNumberLabel.text = "(" + rightAnswersCountFullArray[indexPath.row] + "/" + "\(String(examsArray[indexPath.row].no_of_questions))" + ")"
        examCell.progress = (Double(rightAnswersCountFullArray[indexPath.row])! / Double(examsArray[indexPath.row].no_of_questions))
        examCell.updateProgress()
        return examCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        getNotAnsweredMCQQuestions(examId: examsArray[indexPath.row].id) { (success) -> Void in
            if success {
                let solveMcqVC = self.storyboard?.instantiateViewController(withIdentifier: "SolveMCQ") as! SolveMCQViewController
                print(self.notAnsweredMcqQuestionsArray)
                solveMcqVC.notAnsweredMcqQuestionsArray = self.notAnsweredMcqQuestionsArray
                self.navigationController?.pushViewController(solveMcqVC, animated: true)
            }
        }
    }
    
    
}
