//
//  AskTeacherViewController.swift
//  El-Khateeb
//
//  Created by Eyad Shokry on 9/25/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import UIKit

class AskTeacherViewController: UIViewController {

    @IBOutlet weak var myQuestionsView: UIView!
    @IBOutlet weak var chapterQuestionsView: UIView!
    @IBOutlet weak var askButton: UIButton!
    @IBOutlet weak var allAskButton: UIButton!
    var teacherId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        myQuestionsView.layer.cornerRadius = myQuestionsView.frame.size.width/2
        myQuestionsView.clipsToBounds = true
        myQuestionsView.layer.borderWidth = 1.5
        myQuestionsView.layer.borderColor = UIColor(displayP3Red: 194/255, green: 139/255, blue: 188/255, alpha: 1).cgColor
        
        chapterQuestionsView.layer.cornerRadius = myQuestionsView.frame.size.width/2
        chapterQuestionsView.clipsToBounds = true
        
     askButton.setTitle("My questions".localized, for: .normal)
    allAskButton.setTitle("All questions".localized, for: .normal)
    }
    
    @IBAction func onClickMyQuestionsButton(_ sender: UIButton) {
        let questionsVC = storyboard?.instantiateViewController(withIdentifier: "MyQuestions") as! MyQuestionsViewController
        questionsVC.isMyQuestion = true
        questionsVC.teacherId = self.teacherId
        self.navigationController?.pushViewController(questionsVC, animated: true)
    }
    
    @IBAction func onClickAllChaptersQuestionsButton(_ sender: UIButton) {
        let chaptersVC = storyboard?.instantiateViewController(withIdentifier: "AllQuestion") as! AllQuestionChapterViewController
        chaptersVC.isAskQuestion = true
        chaptersVC.teacherId = self.teacherId
        self.navigationController?.pushViewController(chaptersVC, animated: true)
    }
    
}
