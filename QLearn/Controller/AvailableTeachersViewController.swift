//
//  AvailableTeachersViewController.swift
//  QLearn
//
//  Created by Eyad Shokry on 8/31/20.
//  Copyright © 2020 Eyad Shokry. All rights reserved.
//

import UIKit
import SCLAlertView

class AvailableTeachersViewController: UIViewController {

    @IBOutlet weak var teachersTableView: UITableView!
    var teachers = [Teacher]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        teachersTableView.dataSource = self
        teachersTableView.delegate = self
        teachersTableView.register(UINib(nibName: "TeachersTableViewCell", bundle: nil), forCellReuseIdentifier: "TeacherCell")
        teachersTableView.separatorStyle = .none
        
        getStudentTeachers()
    }
    
    private func getStudentTeachers() {
        var student: Student
        student = Student()
        let parameters = ["student_id" : UserDefaults.standard.string(forKey: "id")]
        student.getStudentTeachers(parameters: parameters as [String : AnyObject]){ (data, error) in
            if let teachers = data {
                print(teachers)
                for teacher in teachers.RESULT{
                    self.teachers.append(teacher)
                }
                self.performUIUpdatesOnMain {
                    self.teachersTableView.reloadData()
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

    @IBAction func onClickLogoutButton(_ sender: UIBarButtonItem) {
        UserDefaults.standard.removeObject(forKey: "id")
        UserDefaults.standard.removeObject(forKey: "student_name")
        UserDefaults.standard.removeObject(forKey: "studnet_phone")
        UserDefaults.standard.removeObject(forKey: "student_level")
        UserDefaults.standard.removeObject(forKey: "student_parent_phone")
        UserDefaults.standard.removeObject(forKey: "admin_name")
        UserDefaults.standard.removeObject(forKey: "admin_phone")
        UserDefaults.standard.removeObject(forKey: "type")
        UserDefaults.standard.synchronize()
//        self.dismiss(animated: true, completion: nil)
        let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
        loginVC.modalPresentationStyle = .fullScreen
        self.present(loginVC, animated: true, completion: nil)
    }
    
    @IBAction func onClickProfileButton(_ sender: Any) {
        
    }
    
}


extension AvailableTeachersViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teachers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeacherCell") as! TeachersTableViewCell
        cell.setupCell(teacher: teachers[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    
}