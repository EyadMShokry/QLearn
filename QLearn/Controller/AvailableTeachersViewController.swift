//
//  AvailableTeachersViewController.swift
//  QLearn
//
//  Created by Eyad Shokry on 8/31/20.
//  Copyright © 2020 Eyad Shokry. All rights reserved.
//

import UIKit
import SCLAlertView
import NVActivityIndicatorView
import Kingfisher

class AvailableTeachersViewController: UIViewController {
    
    @IBOutlet weak var teachersTableView: UITableView!
    @IBOutlet weak var addOtherTeachersButton: UIButton!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    
    var allTeachers = [[Teacher]]()
    var isActivated : [Activated] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        teachersTableView.dataSource = self
        teachersTableView.delegate = self
        teachersTableView.register(UINib(nibName: "TeachersTableViewCell", bundle: nil), forCellReuseIdentifier: "TeacherCell")
        teachersTableView.separatorStyle = .none
        addOtherTeachersButton.isHidden = true
        activityIndicator.type = .circleStrokeSpin
        activityIndicator.color = .cyan
        
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        getStudentTeachers()
        dispatchGroup.leave()
        
        dispatchGroup.enter()
        getIfActivated()
        dispatchGroup.leave()
        
        dispatchGroup.notify(queue: .main) {
            print("is activated: \(self.isActivated)")
        }
    }
    
    private func getStudentTeachers() {
        var student: Student
        student = Student()
        let parameters = ["student_id" : UserDefaults.standard.string(forKey: "id")]
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        student.getStudentTeachers(parameters: parameters as [String : AnyObject]){ (data, error) in
            if let teachers = data {
                print(teachers)
                self.allTeachers.append(teachers.RESULT)
                self.performUIUpdatesOnMain {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    self.addOtherTeachersButton.isHidden = false
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
    
    private func getOtherTeachers() {
        addOtherTeachersButton.isHidden = true
        var student: Student
        student = Student()
        let parameters = ["student_id" : UserDefaults.standard.string(forKey: "id")]
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        student.getOtherTeachers(parameters: parameters as [String : AnyObject]) { (data, error) in
            if let teachers = data {
                self.allTeachers.append(teachers.RESULT)
                self.performUIUpdatesOnMain {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    self.footerView.isHidden = true
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
    
    func getIfActivated() {
        let student = Student()
        let parameters = ["stuID" : UserDefaults.standard.string(forKey: "id")]
        student.getIfActivatedAccount(parameters: parameters as [String : AnyObject]){ (data, error) in
            if let isActivated = data {
                for active in isActivated.RESULT {
                    print("Activated: \(active)")
                    self.isActivated.append(active)
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
    
    
    @IBAction func onClickAddOtherTeachersButton(_ sender: UIButton) {
        getOtherTeachers()
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
        let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginNavigationController") as! UINavigationController
        loginVC.modalPresentationStyle = .fullScreen
        self.present(loginVC, animated: true, completion: nil)
    }
    
}


extension AvailableTeachersViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return allTeachers.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allTeachers[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeacherCell") as! TeachersTableViewCell
        if(indexPath.section == 0) {
            cell.setupCell(teacher: allTeachers[indexPath.section][indexPath.row], isMyTeacher: true)
            cell.joinRequestButton.isHidden = true
        }
        else if(indexPath.section == 1) {
            cell.joinRequestButton.isHidden = false
            cell.setupCell(teacher: allTeachers[indexPath.section][indexPath.row], isMyTeacher: false)
            if(allTeachers[indexPath.section][indexPath.row].requested == "True") {
                cell.joinRequestButton.isEnabled = false
                cell.joinRequestButton.setTitle("A request is sent".localized, for: .normal)
                cell.joinRequestButton.backgroundColor = UIColor.lightGray
            }
        }
        //Handle join requests
        cell.joinRequestPressed  = { [weak self] sender in
            NetworkingService.shared.provider.request(.insertStudentTeacherRequest(stuID: UserDefaults.standard.string(forKey: "id")!, teacher_id: self!.allTeachers[indexPath.section][indexPath.row].id)) {[weak self] (result) in
                switch result {
                case .success(let response):
                    let responseString = String(decoding: response.data, as: UTF8.self)
                    print(responseString)
                    if(responseString == "inserted") {
                        self?.performUIUpdatesOnMain {
                            cell.joinRequestButton.isEnabled = false
                            cell.joinRequestButton.setTitle("A request is sent".localized, for: .normal)
                            cell.joinRequestButton.backgroundColor = UIColor.lightGray
                        }
                    }
                    else {
                        self?.performUIUpdatesOnMain {
                            SCLAlertView().showError("Error happened", subTitle: "Server error happened. please check your internet connection or contact with application's author", closeButtonTitle:"Ok".localized)
                        }
                    }
                case .failure(let err):
                    print(err)
                    SCLAlertView().showError("Error happened", subTitle: "Server error happened. please check your internet connection or contact with application's author", closeButtonTitle:"Ok".localized)
                }
            }
        }
        //Download and show teachers' images
        var url: URL!
        if let imageUrl = allTeachers[indexPath.section][indexPath.row].photo_url {
            url = URL(string: Client.ApiConstants.APIScheme + "://" + Client.ApiConstants.APIHost + "/" + Client.ApiConstants.ImagesPath + imageUrl)
        }
        else {
            url = nil
        }
        cell.teacherImage.kf.indicatorType = .activity
        cell.teacherImage.kf.setImage(with: url, placeholder: UIImage(named: "adminicon"), options: [KingfisherOptionsInfoItem.transition(.fade(0.4))])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(isActivated[0].activated == "True") {
            let homeVC = storyboard?.instantiateViewController(withIdentifier: "Login") as! HomeViewController
            homeVC.teacherId = self.allTeachers[indexPath.section][indexPath.row].id
            homeVC.userType = "student"
            if(indexPath.section == 0) {
                homeVC.isMyTeacher = true
            }
            else if(indexPath.section == 1) {
                homeVC.isMyTeacher = false
            }
            print("is my teacher: \(homeVC.isMyTeacher)")
            navigationController?.pushViewController(homeVC, animated: true)
        }
        else {
            let goForPayVC = storyboard?.instantiateViewController(withIdentifier: "GoForPayVC")
            navigationController?.pushViewController(goForPayVC!, animated: true)
        }
    }
    
    
}
