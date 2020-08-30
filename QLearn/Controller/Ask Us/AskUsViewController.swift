//
//  AskUsViewController.swift
//  El-Khateeb
//
//  Created by Eyad Shokry on 9/23/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import UIKit
import SCLAlertView

class AskUsViewController: UIViewController {
    @IBOutlet weak var noQuestionsLabel: UIView!
    @IBOutlet weak var questionsTableView: UITableView!
    var questionsArray: [Question] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.questionsTableView.rowHeight = 100.0
        questionsTableView.dataSource = self
        questionsTableView.delegate = self
        questionsTableView.separatorColor = .clear
        
        questionsArray.append(Question(question: "hello", type: "essay", essayAnswer: "dqwdq", answer1: nil, answer2: nil, answer3: nil, answer4: nil, trueFalseAnswer: nil, reason: nil))
        questionsArray.append(Question(question: "من هو صاحب ثورة ١٩١٩", type: "essay", essayAnswer: "dqwdq", answer1: nil, answer2: nil, answer3: nil, answer4: nil, trueFalseAnswer: nil, reason: nil))
        questionsArray.append(Question(question: "hello", type: "essay", essayAnswer: "dqwdq", answer1: nil, answer2: nil, answer3: nil, answer4: nil, trueFalseAnswer: nil, reason: nil))
        questionsArray.append(Question(question: "من هو صاحب ثورة ١٩١٩", type: "essay", essayAnswer: "dqwdq", answer1: nil, answer2: nil, answer3: nil, answer4: nil, trueFalseAnswer: nil, reason: nil))
        questionsArray.append(Question(question: "hello", type: "essay", essayAnswer: "dqwdq", answer1: nil, answer2: nil, answer3: nil, answer4: nil, trueFalseAnswer: nil, reason: nil))
        questionsArray.append(Question(question: "من هو صاحب ثورة ١٩١٩", type: "essay", essayAnswer: "dqwdq", answer1: nil, answer2: nil, answer3: nil, answer4: nil, trueFalseAnswer: nil, reason: nil))
        questionsArray.append(Question(question: "hello", type: "essay", essayAnswer: "dqwdq", answer1: nil, answer2: nil, answer3: nil, answer4: nil, trueFalseAnswer: nil, reason: nil))
        questionsArray.append(Question(question: "من هو صاحب ثورة ١٩١٩", type: "essay", essayAnswer: "dqwdq", answer1: nil, answer2: nil, answer3: nil, answer4: nil, trueFalseAnswer: nil, reason: nil))
        questionsArray.append(Question(question: "hello", type: "essay", essayAnswer: "dqwdq", answer1: nil, answer2: nil, answer3: nil, answer4: nil, trueFalseAnswer: nil, reason: nil))
        questionsArray.append(Question(question: "من هو صاحب ثورة ١٩١٩", type: "essay", essayAnswer: "dqwdq", answer1: nil, answer2: nil, answer3: nil, answer4: nil, trueFalseAnswer: nil, reason: nil))

    }
    
}


extension AskUsViewController: UITableViewDataSource, UITableViewDelegate {
    
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
        if let indexPath = tableView.indexPathForSelectedRow {
            let selectedCellSourceView = tableView.cellForRow(at: indexPath)
            let selectedCellSourceRect = selectedCellSourceView?.bounds
            
            let answerQuestionVC = storyboard?.instantiateViewController(withIdentifier: "AnswerQuestion") as! AnswerQuestionViewController
            answerQuestionVC.modalPresentationStyle = .popover
            answerQuestionVC.popoverPresentationController?.delegate = self
            answerQuestionVC.popoverPresentationController?.sourceView = selectedCellSourceView
            answerQuestionVC.popoverPresentationController?.sourceRect = selectedCellSourceRect!
            answerQuestionVC.popoverPresentationController?.permittedArrowDirections = .any
            answerQuestionVC.selectedCellRow = indexPath.row
            
            self.present(answerQuestionVC, animated: true)

        }
    }
    
    func deleteQuestionAfterAnswer(row: Int) {
        let selectedQuestion = self.questionsArray[row]
        print("call api and delete this question: \(selectedQuestion)")
        self.questionsArray.remove(at: row)
        self.questionsTableView.reloadData()
    }
    
}


extension AskUsViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
