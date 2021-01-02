//
//  SideMenuTableViewController.swift
//  El-Khateeb
//
//  Created by Eyad Shokry on 9/14/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import UIKit
import MOLH
import SCLAlertView


class SideMenuTableViewController: UITableViewController {
    @IBOutlet var menuTableView: UITableView!
    @IBOutlet weak var singOutButton: UIButton!
    @IBOutlet weak var singOutImage: UIImageView!
    @IBOutlet weak var toChangeLanguage: UILabel!
    @IBOutlet weak var LangaugeButton: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var attendanceStackView: UIStackView!
    @IBOutlet weak var attendanceButton: UIButton!
    @IBOutlet weak var logoutStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        attendanceButton.setTitle("Attendance".localized, for: .normal)
        attendanceStackView.isHidden = UserDefaults.standard.string(forKey: "type") == "student" ? false : true
        menuTableView.separatorColor = .clear
        LangaugeButton.setTitle("LanguageButton".localized, for: .normal)
        toChangeLanguage.text = "To Change Language:".localized
        
        singOutButton.isHidden = UserDefaults.standard.value(forKey: "id") == nil
        singOutImage.isHidden = UserDefaults.standard.value(forKey: "id") == nil
        
        if(UserDefaults.standard.value(forKey: "id") == nil) {
            userNameLabel.text = ""
            
        }
        else if(UserDefaults.standard.string(forKey: "type") == "teacher") {
            userNameLabel.text = (UserDefaults.standard.string(forKey: "admin_name"))
        }
        else if(UserDefaults.standard.string(forKey: "type") == "student") {
            userNameLabel.text = UserDefaults.standard.string(forKey: "student_name")
        }
    }
    
    @IBAction func didPressOnLanguage(_ sender: UIButton) {
        
        let newViewController = storyboard?.instantiateViewController(withIdentifier: "HomeView")
        
        self.dismiss(animated: true) { () -> Void in
            
            UIApplication.shared.keyWindow?.rootViewController = newViewController
            MOLH.setLanguageTo(MOLHLanguage.currentAppleLanguage() == "en" ? "ar" : "en")
            MOLH.reset()
        }
        
    }
    
    @IBAction func onClickSignOutButton(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "id")
        UserDefaults.standard.removeObject(forKey: "student_name")
        UserDefaults.standard.removeObject(forKey: "studnet_phone")
        UserDefaults.standard.removeObject(forKey: "student_level")
        UserDefaults.standard.removeObject(forKey: "student_parent_phone")
        UserDefaults.standard.removeObject(forKey: "admin_name")
        UserDefaults.standard.removeObject(forKey: "sub_id")
        UserDefaults.standard.removeObject(forKey: "admin_phone")
        UserDefaults.standard.removeObject(forKey: "type")
        UserDefaults.standard.synchronize()
        
        let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginNavigationController") as! UINavigationController
        loginVC.modalPresentationStyle = .fullScreen
        self.present(loginVC, animated: true, completion: nil)
    }
    
    @IBAction func onClickAttendanceButton(_ sender: Any) {
        let studentAttendanceVC = self.storyboard?.instantiateViewController(withIdentifier: "StudentAttendanceVC") as! StudentAttendanceViewController
        self.navigationController?.pushViewController(studentAttendanceVC, animated: true)
    }
    
    
}
