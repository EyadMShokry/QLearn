//
//  SideMenuTableViewController.swift
//  El-Khateeb
//
//  Created by Eyad Shokry on 9/14/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import UIKit
import MOLH


class SideMenuTableViewController: UITableViewController {
    @IBOutlet var menuTableView: UITableView!
    @IBOutlet weak var singOutButton: UIButton!
    @IBOutlet weak var singOutImage: UIImageView!
    @IBOutlet weak var toChangeLanguage: UILabel!
    @IBOutlet weak var LangaugeButton: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        menuTableView.dataSource = self
        menuTableView.delegate = self
        menuTableView.separatorColor = .clear
        LangaugeButton.setTitle("LanguageButton".localized, for: .normal)
        toChangeLanguage.text = "To Change Language:".localized
        
        singOutButton.isHidden = UserDefaults.standard.value(forKey: "id") == nil
        singOutImage.isHidden = UserDefaults.standard.value(forKey: "id") == nil
        
        if(UserDefaults.standard.value(forKey: "id") == nil) {
            userNameLabel.text = ""
            
        }
        else if(UserDefaults.standard.string(forKey: "type") == "admin") {
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
        UserDefaults.standard.removeObject(forKey: "admin_phone")
        UserDefaults.standard.removeObject(forKey: "type")
        UserDefaults.standard.synchronize()
        
        let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginNavigationController") as! UINavigationController
        loginVC.modalPresentationStyle = .fullScreen
        self.present(loginVC, animated: true, completion: nil)
    }
    
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 40))
        footerView.backgroundColor = .cyan
        
        return footerView
    }
}
