//
//  QuestionsBagViewController.swift
//  El-Khateeb
//
//  Created by Eyad Shokry on 9/19/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import UIKit

class QuestionsBagViewController: UIViewController {
    @IBOutlet weak var searchMcqButton: UIButton!
    @IBOutlet weak var searchEssayButton: UIButton!
    @IBOutlet weak var searchTFButton: UIButton!
    var teacherId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if(UserDefaults.standard.value(forKey: "admin_name") == nil) {
            searchMcqButton.isHidden = true
            searchEssayButton.isHidden = true
            searchTFButton.isHidden = true
        }
    }

    @IBAction func onClickMCQQeustionsButton(_ sender: Any) {
        if UserDefaults.standard.value(forKey: "admin_name") != nil {
            navigateToChaptersVC(questionType: "mcq", userType: "teacher")
        }
        else {
            navigateToChaptersVC(questionType: "mcq", userType: "student")
        }
    }
    
    @IBAction func onClickSearchMCQButton(_ sender: Any) {
        let searchQuestionsVC = storyboard?.instantiateViewController(withIdentifier: "SeachQuestions") as! SearchQuestionsViewController
        searchQuestionsVC.questionsType = "mcq"
        self.navigationController?.pushViewController(searchQuestionsVC, animated: true)
    }
    
    @IBAction func onClickEssayQuestionsButton(_ sender: Any) {
        if UserDefaults.standard.value(forKey: "admin_name") != nil {
            navigateToChaptersVC(questionType: "essay", userType: "teacher")
        }
        else {
            navigateToChaptersVC(questionType: "essay", userType: "student")
        }
    }
    
    @IBAction func onClickSearchEssayButton(_ sender: Any) {
        let searchQuestionsVC = storyboard?.instantiateViewController(withIdentifier: "SeachQuestions") as! SearchQuestionsViewController
        searchQuestionsVC.questionsType = "essay"
        self.navigationController?.pushViewController(searchQuestionsVC, animated: true)
    }
    
    
    @IBAction func onClickTrueFalseQuestionsButton(_ sender: Any) {
        if UserDefaults.standard.string(forKey: "type") == "admin" {
            navigateToChaptersVC(questionType: "TF", userType: "teacher")
        }
        else {
            navigateToChaptersVC(questionType: "TF", userType: "student")
        }
    }
    
    @IBAction func onClickSearchTrueFalseButton(_ sender: Any) {
        let searchQuestionsVC = storyboard?.instantiateViewController(withIdentifier: "SeachQuestions") as! SearchQuestionsViewController
        searchQuestionsVC.questionsType = "TF"
        self.navigationController?.pushViewController(searchQuestionsVC, animated: true)
    }
    
    private func navigateToChaptersVC(questionType: String, userType: String) {
        if userType == "teacher" {
            let chaptersVC = storyboard?.instantiateViewController(withIdentifier: "AllQuestion") as! AllQuestionChapterViewController
            chaptersVC.isAskQuestion = false
            chaptersVC.questionType = questionType
            self.navigationController?.pushViewController(chaptersVC, animated: true)
        }
        else if userType == "student" {
            let chaptersVC = storyboard?.instantiateViewController(withIdentifier: "ChaptersVC") as! ChaptersViewController
            chaptersVC.questionType = questionType
            chaptersVC.teacherId = self.teacherId
            self.navigationController?.pushViewController(chaptersVC, animated: true)
        }
    }
    
}
