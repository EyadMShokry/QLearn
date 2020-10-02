//
//  SelectLevelViewController.swift
//  QLearn
//
//  Created by Eyad Shokry on 10/1/20.
//  Copyright © 2020 Eyad Shokry. All rights reserved.
//

import UIKit
import iOSDropDown
import SCLAlertView

class SelectLevelViewController: UIViewController {

    @IBOutlet weak var levelsDropDown: DropDown!
    @IBOutlet weak var startButton: UIButton!
    var levels: [String] = []
    var levelsIds : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getStudentLevels()
    }
    
    private func getStudentLevels() {
        var student: Student
        student = Student()
        student.getStudentLevels(parameters: [:]) {(levels, error) in
            if let levels = levels {
                for level in levels.RESULT {
                    self.levels.append(level.levelTitle)
                    self.levelsIds.append(level.id)
                }
                self.performUIUpdatesOnMain {
                    self.levelsDropDown.optionArray.append(contentsOf: self.levels)
                    self.levelsDropDown.selectedIndex = 0
                    self.levelsDropDown.text = levels.RESULT[0].levelTitle
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

    @IBAction func onClickStartButton(_ sender: Any) {
        let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "Login") as! HomeViewController
        homeVC.userType = "admin"
        homeVC.levelId = levelsIds[levelsDropDown.selectedIndex!]
        self.navigationController?.pushViewController(homeVC, animated: true)
    }
    
}
