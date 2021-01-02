//
//  QuestionsTypeViewController.swift
//  QLearn
//
//  Created by Eyad Shokry on 1/2/21.
//  Copyright © 2021 Eyad Shokry. All rights reserved.
//

import UIKit

class QuestionsTypeViewController: UIViewController {
    let userType = UserDefaults.standard.string(forKey: "type")
    var teacherId = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }

    @IBAction func onClickMCQButton(_ sender: UIButton) {
        if(userType == "student") {
            let examsVC = self.storyboard?.instantiateViewController(withIdentifier: "LiveExamsVC") as! LiveExamsViewController
            examsVC.teacherId = self.teacherId
            self.navigationController?.pushViewController(examsVC, animated: true)
        }
        else {
            
        }
    }
    
}
