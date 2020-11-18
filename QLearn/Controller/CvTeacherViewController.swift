//
//  CVViewController.swift
//  El-Khateeb
//
//  Created by Abdalah on 9/15/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import UIKit
import SCLAlertView
import Kingfisher

class CvTeacherViewController: UIViewController {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var editInformation: UIButton!
    @IBOutlet weak var NameTeacherLable: UILabel!
    @IBOutlet weak var informationTableView: UITableView!
    @IBOutlet weak var achievementsTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var addAchievementButton: UIButton!
    
    var inforamtionTableLabels = ["Job".localized,"Specialist".localized,"Working at".localized,"Date of Birth".localized]
    var informationTableValues: [String] = ["", "", "", ""]
    var achievementsData: [AchievementResult] = []
    var teacherId = ""
    var getInfoParameters = ["teacher_id" : ""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getInfoParameters = ["teacher_id" : teacherId]
        if(UserDefaults.standard.string(forKey: "type") != "teacher") {
            editInformation.isHidden = true
            addAchievementButton.isHidden = true
        }
        else {
            getInfoParameters = ["teacher_id" : UserDefaults.standard.string(forKey: "id")!]
        }
        
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2
        self.profileImageView.clipsToBounds = true
        informationTableView.isScrollEnabled = false
        achievementsTableView.isScrollEnabled = false
        self.informationTableView?.rowHeight = 40.0
        self.achievementsTableView?.rowHeight = 40.0
        self.informationTableView.separatorColor = .darkGray
        self.achievementsTableView.separatorColor = .darkGray
        self.achievementsTableView.tableFooterView = UIView()
        self.view.bringSubviewToFront(activityIndicator)
        
        let user = User()
        self.activityIndicator.startAnimating()
        
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        user.getTeacherInfo(parameters: getInfoParameters as [String : AnyObject]) {(info, error) in
            if let teacherInfo = info {
                print(teacherInfo)
                if(!teacherInfo.RESULT.isEmpty) {
                    self.informationTableValues[0] = teacherInfo.RESULT[0].job
                    self.informationTableValues[1] = teacherInfo.RESULT[0].speciality
                    self.informationTableValues[2] = teacherInfo.RESULT[0].school
                    self.informationTableValues[3] = teacherInfo.RESULT[0].DOB
                    print("Teacher Info: \(teacherInfo.RESULT[0])")
                    self.performUIUpdatesOnMain {
                        self.NameTeacherLable.text = teacherInfo.RESULT[0].fullName
                        self.informationTableView.reloadData()
                        let url = URL(string: Client.ApiConstants.APIScheme + "://" + Client.ApiConstants.APIHost + "/" + Client.ApiConstants.ImagesPath + teacherInfo.RESULT[0].photo_url)
                        self.profileImageView.kf.indicatorType = .activity
                        self.profileImageView.kf.setImage(with: url, placeholder: UIImage(named: "adminicon"), options: [KingfisherOptionsInfoItem.transition(.fade(0.4))])
                    }
                }
                else {
                    self.informationTableValues[0] = "---"
                    self.informationTableValues[1] = "---"
                    self.informationTableValues[2] = "---"
                    self.informationTableValues[3] = "---"
                    self.performUIUpdatesOnMain {
                        self.NameTeacherLable.text = "---"
                        self.informationTableView.reloadData()
                    }
                    
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
                self.performUIUpdatesOnMain {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                }
                
            }
            self.performUIUpdatesOnMain {
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.enter()
        var parameters = ["teacher_id" : self.teacherId]
        if(UserDefaults.standard.string(forKey: "type") == "teacher") {
            parameters = ["teacher_id" : UserDefaults.standard.string(forKey: "id")!]
        }
        user.getAchievements(parameters: parameters as [String : AnyObject]) {(data, error) in
            if let achievements = data {
                self.achievementsData = achievements.RESULT
                print("achievements: \(self.achievementsData)")
                self.performUIUpdatesOnMain {
                    self.achievementsTableView.reloadData()
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
                self.performUIUpdatesOnMain {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                }
            }
            self.performUIUpdatesOnMain {
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main) {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
    }
    
    @IBAction func editButtonAction(_ sender: Any) {
        if(UserDefaults.standard.string(forKey: "id") != UserDefaults.standard.string(forKey: "sub_id")) {
            SCLAlertView().showError("Access denied".localized, subTitle: "Only Super Admins can access this content".localized)
        }
        else {
            let appearance = SCLAlertView.SCLAppearance(
                showCloseButton: false
            )
            let editCVAlertView = SCLAlertView(appearance: appearance)
            
            let teacherNameTextField = editCVAlertView.addTextField("Speciality".localized)
            teacherNameTextField.text = self.NameTeacherLable.text
            teacherNameTextField.textAlignment = .center
            
            let jobTextField = editCVAlertView.addTextField("Job".localized)
            jobTextField.text = self.informationTableValues[0]
            jobTextField.textAlignment = .center
            let specialityTextField = editCVAlertView.addTextField("Speciality".localized)
            specialityTextField.text = self.informationTableValues[1]
            specialityTextField.textAlignment = .center
            let workingAtTextField = editCVAlertView.addTextField("Working at".localized)
            workingAtTextField.text = self.informationTableValues[2]
            workingAtTextField.textAlignment = .center
            
            let dateOfBirthTextField = editCVAlertView.addTextField("Date of birth".localized)
            dateOfBirthTextField.text = self.informationTableValues[3]
            dateOfBirthTextField.textAlignment = .center
            
            editCVAlertView.addButton("Save".localized)
            {
                if(teacherNameTextField.text!.isEmpty || jobTextField.text!.isEmpty || specialityTextField.text!.isEmpty || workingAtTextField.text!.isEmpty || dateOfBirthTextField.text!.isEmpty) {
                    SCLAlertView().showError("Error".localized, subTitle:"Some field is empty".localized, closeButtonTitle:"Ok".localized)
                }
                else {
                    let admin = Admin()
                    let parameters = [
                        "fullName" : teacherNameTextField.text!,
                        "job" : jobTextField.text!,
                        "speciality" : specialityTextField.text!,
                        "DOB" : dateOfBirthTextField.text!,
                        "school" : workingAtTextField.text!,
                        "id" : UserDefaults.standard.string(forKey: "id"),
                        "teacher_id" : UserDefaults.standard.string(forKey: "id"),
                        "photo_url" : "",
                        "cover_url" : ""]
                    
                    self.activityIndicator.isHidden = false
                    self.activityIndicator.startAnimating()
                    admin.updateTeacherInfo(parameters: parameters as [String : AnyObject], completion: { (response, error) in
                        if let response = response {
                            if response.contains("inserted") {
                                self.performUIUpdatesOnMain {
                                    SCLAlertView().showSuccess("Success".localized, subTitle:"is added successfully".localized, closeButtonTitle:"Ok".localized)
                                    admin.getTeacherInfo(parameters: self.getInfoParameters as [String : AnyObject], completion: { (teacherInfo, error) in
                                        if let teacherInfo = teacherInfo {
                                            self.informationTableValues[0] = teacherInfo.RESULT[0].job
                                            self.informationTableValues[1] = teacherInfo.RESULT[0].speciality
                                            self.informationTableValues[2] = teacherInfo.RESULT[0].school
                                            self.informationTableValues[3] = teacherInfo.RESULT[0].DOB
                                            self.performUIUpdatesOnMain {
                                                self.NameTeacherLable.text = teacherInfo.RESULT[0].fullName
                                                self.activityIndicator.stopAnimating()
                                                self.activityIndicator.isHidden = true
                                                self.informationTableView.reloadData()
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
                                            self.performUIUpdatesOnMain {
                                                self.activityIndicator.stopAnimating()
                                                self.activityIndicator.isHidden = true
                                            }
                                            
                                        }
                                    })
                                }
                            }
                            else {
                                self.performUIUpdatesOnMain {
                                    SCLAlertView().showError("Error".localized, subTitle: "Server Error, please contact with applications author".localized, closeButtonTitle:"Ok".localized)
                                    self.activityIndicator.stopAnimating()
                                    self.activityIndicator.isHidden = true
                                }
                            }
                        }
                        else if let error = error {
                            self.performUIUpdatesOnMain {
                                self.activityIndicator.stopAnimating()
                                self.activityIndicator.isHidden = true
                            }
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
                    })
                }
            }
            
            editCVAlertView.addButton("Cancal".localized) {
                editCVAlertView.dismiss(animated: true, completion: nil)
            }
            editCVAlertView.showEdit(NSLocalizedString("Edit CV", comment: "")
                ,subTitle: NSLocalizedString("Update Your Cv Details", comment: "")
            )
            
        }
        
    }
    
    @IBAction func addButtonAction(_ sender: Any) {
        if(UserDefaults.standard.string(forKey: "id") != UserDefaults.standard.string(forKey: "sub_id")) {
            SCLAlertView().showError("Access denied".localized, subTitle: "Only Super Admins can access this content".localized)
        }
        else {
            let appearence = SCLAlertView.SCLAppearance(
                showCloseButton: false, showCircularIcon: true
            )
            
            let addAchievmentAlertView = SCLAlertView(appearance: appearence)
            let achievmentTextField = addAchievmentAlertView.addTextField(
                NSLocalizedString("Achievment", comment: ""))
            achievmentTextField.textAlignment = .center
            
            addAchievmentAlertView.addButton("Add".localized) {
                if(achievmentTextField.text!.isEmpty) {
                    SCLAlertView().showError("Error".localized, subTitle:"Some field is empty".localized, closeButtonTitle:"Ok".localized)
                }
                else {
                    let parameters = ["achievement" : achievmentTextField.text,
                                      "teacher_id" : UserDefaults.standard.string(forKey: "id")]
                    let admin = Admin()
                    self.achievementsData.removeAll()
                    
                    self.activityIndicator.isHidden = false
                    self.activityIndicator.startAnimating()
                    admin.insertAchievement(parameters: parameters as [String : AnyObject]) {(data, error) in
                        if let response = data{
                            if response.contains("inserted"){
                                self.performUIUpdatesOnMain {
                                    SCLAlertView().showSuccess("Success".localized, subTitle:"Achievement added successfully".localized, closeButtonTitle:"Ok".localized)
                                    
                                    let parameters = ["teacher_id" : UserDefaults.standard.string(forKey: "id")]
                                    admin.getAchievements(parameters: parameters as [String : AnyObject]) {(data, error) in
                                        if let achievements = data {
                                            self.achievementsData = achievements.RESULT
                                            self.performUIUpdatesOnMain {
                                                self.activityIndicator.stopAnimating()
                                                self.activityIndicator.isHidden = true
                                                self.achievementsTableView.reloadData()
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
                                            self.performUIUpdatesOnMain {
                                                self.activityIndicator.stopAnimating()
                                                self.activityIndicator.isHidden = true
                                            }
                                            print(error)
                                        }
                                    }
                                }
                            }
                            else{
                                self.performUIUpdatesOnMain {
                                    SCLAlertView().showError("Error".localized, subTitle: "Server Error, please contact with applications author".localized, closeButtonTitle:"Ok".localized)
                                    self.activityIndicator.stopAnimating()
                                    self.activityIndicator.isHidden = true
                                }
                            }
                        }
                        else if let error = error {
                            self.performUIUpdatesOnMain {
                                self.activityIndicator.stopAnimating()
                                self.activityIndicator.isHidden = true
                            }
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
            }
            addAchievmentAlertView.addButton("Cancal".localized) {
                addAchievmentAlertView.dismiss(animated: true, completion: nil)
            }
            
            let alertViewIcon = UIImage(named: "star")
            addAchievmentAlertView.showInfo(
                "Achievements".localized, subTitle:"Add New Achievment".localized, circleIconImage: alertViewIcon)
        }
    }
    
    func inserNewIndexachievements(){
        let indexPath = IndexPath(row: achievementsData.count - 1, section: 0)
        achievementsTableView.insertRows(at: [indexPath], with: .left)
        achievementsTableView.reloadData()
    }
}


// mark->  extension all tableview
extension CvTeacherViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == informationTableView
        {
            return inforamtionTableLabels.count
        }
        else{
            return achievementsData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == informationTableView
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CvTeacherCell") as! CvTeacherTableViewCell
            cell.informationLable.text = inforamtionTableLabels[indexPath.row]
            cell.dataLable.text = informationTableValues[indexPath.row]
            
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "AchievementsCell") as! AchievementsTableViewCell
            cell.AchievementLable.text = achievementsData[indexPath.row].achievement
            cell.AchievementImage.image = UIImage(named: "star")
            
            if(UserDefaults.standard.value(forKey: "admin_name") != nil) {
                let holdToEditGestureRecognizer = LongPressGesture(target: self, action: #selector(CvTeacherViewController.updateAchievement))
                holdToEditGestureRecognizer.minimumPressDuration = 1.00
                holdToEditGestureRecognizer.title = achievementsData[indexPath.row].achievement
                holdToEditGestureRecognizer.selectedId = achievementsData[indexPath.row].achievementID
                cell.addGestureRecognizer(holdToEditGestureRecognizer)
            }
            
            return cell
        }
        
    }
    
    @objc func updateAchievement(sender: LongPressGesture) {
        if(sender.state == .ended) {
            print("long tap is done")
            let appearence = SCLAlertView.SCLAppearance(
                showCloseButton: false, showCircularIcon: true
            )
            
            let editAchievmentAlertView = SCLAlertView(appearance: appearence)
            let achievmentTextField = editAchievmentAlertView.addTextField(NSLocalizedString("Achievment", comment: ""))
            achievmentTextField.textAlignment = .center
            achievmentTextField.text = sender.title
            
            editAchievmentAlertView.addButton("Edit".localized) {
                if(achievmentTextField.text!.isEmpty) {
                    SCLAlertView().showError("Error".localized, subTitle:"Some field is empty".localized, closeButtonTitle:"Ok".localized)
                }
                else {
                    let admin = Admin()
                    let parameters = ["id" : sender.selectedId,
                                      "achievement" : achievmentTextField.text!]
                    
                    self.activityIndicator.isHidden = false
                    self.activityIndicator.startAnimating()
                    admin.updateAchievement(parameters: parameters as [String : AnyObject], completion: { (response, error) in
                        if let response = response {
                            if response.contains("inserted") {
                                self.performUIUpdatesOnMain {
                                    SCLAlertView().showSuccess("Success".localized, subTitle: "Achievement edited successfully".localized, closeButtonTitle:"Ok".localized)
                                    
                                    let parameters = ["teacher_id" : UserDefaults.standard.string(forKey: "id")]
                                    admin.getAchievements(parameters: parameters as [String : AnyObject]) {(data, error) in
                                        if let achievements = data {
                                            self.achievementsData = achievements.RESULT
                                            print("achievements: \(self.achievementsData)")
                                            self.performUIUpdatesOnMain {
                                                self.activityIndicator.stopAnimating()
                                                self.activityIndicator.isHidden = true
                                                self.achievementsTableView.reloadData()
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
                                            self.performUIUpdatesOnMain {
                                                self.activityIndicator.stopAnimating()
                                                self.activityIndicator.isHidden = true
                                            }
                                            print(error)
                                        }
                                    }
                                }
                            }
                            else {
                                self.performUIUpdatesOnMain {
                                    SCLAlertView().showError("Error".localized, subTitle: "Server Error, please contact with applications author".localized, closeButtonTitle:"Ok".localized)
                                    self.activityIndicator.stopAnimating()
                                    self.activityIndicator.isHidden = true
                                }
                            }
                        }
                        else if let error = error {
                            self.performUIUpdatesOnMain {
                                self.activityIndicator.stopAnimating()
                                self.activityIndicator.isHidden = true
                            }
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
                    })
                }
            }
            
            editAchievmentAlertView.addButton("Cancal".localized) {
                editAchievmentAlertView.dismiss(animated: true, completion: nil)
            }
            
            let alertViewIcon = UIImage(named: "star")
            editAchievmentAlertView.showInfo(
                "Achievements".localized, subTitle: "Edit Achievment".localized, circleIconImage: alertViewIcon)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if tableView == achievementsTableView{
            return true
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if(UserDefaults.standard.value(forKey: "admin_name") != nil) {
            return .delete
        }
        else {
            return .none
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if tableView == achievementsTableView {
            if editingStyle == .delete {
                let admin = Admin()
                let achievementId = achievementsData[indexPath.row].achievementID
                let parameters = ["id" : achievementId]
                
                admin.deleteAchievement(parameters: parameters as [String : AnyObject]) { (response, error) in
                    if let response = response{
                        if response.contains("inserted"){
                            self.performUIUpdatesOnMain {
                                SCLAlertView().showSuccess("Success".localized, subTitle:"Achievement Deleted successfully".localized, closeButtonTitle:"Ok".localized)
                                self.achievementsTableView.reloadData()
                            }
                        }else{
                            self.performUIUpdatesOnMain {
                                SCLAlertView().showError("Error".localized, subTitle: "Server Error, please contact with applications author".localized, closeButtonTitle:"Ok".localized)                         }
                        }
                    }
                }
                
                achievementsData.remove(at: indexPath.row)
                tableView.beginUpdates()
                tableView.deleteRows(at: [indexPath], with: .automatic)
                tableView.endUpdates()
            }
        }
        
    }
    
}



