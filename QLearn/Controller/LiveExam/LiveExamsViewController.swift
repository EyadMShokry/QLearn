//
//  LiveExamsViewController.swift
//  QLearn
//
//  Created by Eyad Shokry on 1/2/21.
//  Copyright © 2021 Eyad Shokry. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class LiveExamsViewController: UIViewController {
    @IBOutlet weak var examsTableView: UITableView!
    @IBOutlet weak var addExamButton: UIButton!
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    var teacherId = ""
    var examsArray: [Exam] = []
    
    fileprivate func adjustActivityIndicator() {
        self.view.bringSubviewToFront(activityIndicator)
        activityIndicator.type = .ballScaleRipple
        activityIndicator.color = UIColor(displayP3Red: 196/255, green: 137/255, blue: 191/255, alpha: 1)
    }
    
    
    fileprivate func getOnGoingExams() {
        self.activityIndicator.startAnimating()
        NetworkingService.shared.provider.request(.selectOnGoingExamsLE(teacher_id: self.teacherId, level: UserDefaults.standard.string(forKey: "student_level")!)) {[weak self] (result) in
            switch result {
            case .success(let response) :
                do {
                    let exams = try JSONDecoder().decode(ExamResult.self, from: response.data)
                    print(exams)
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
            self?.performUIUpdatesOnMain {
                self?.activityIndicator.stopAnimating()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        examsTableView.dataSource = self
        examsTableView.delegate = self
        examsTableView.rowHeight = 250

        if(UserDefaults.standard.string(forKey: "type") == "student") {
            self.addExamButton.isHidden = true
            self.getOnGoingExams()
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
        return examsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let examCell = tableView.dequeueReusableCell(withIdentifier: "ChapterCell") as! ChapterTableViewCell
        examCell.chapterLabel.text = examsArray[indexPath.row].title
        examCell.examTimeLabel.text = examsArray[indexPath.row].examduration + ":00"
        examCell.CalculatesProgress.text = "100%"
//        examCell.progress = Double(chaptersArray[indexPath.row].rightAnswersPercent)!/100
        examCell.updateProgress()
        //if not solved exam:
        //examCell.progressBar.isHidden = true
        return examCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
}
