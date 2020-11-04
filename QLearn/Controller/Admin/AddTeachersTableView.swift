//
//  Add TeachersTableView.swift
//  El-Khateeb
//
//  Created by Abdalah on 9/19/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import UIKit
import SCLAlertView
import TableFlip

class AddTeachersTableView: UITableViewController {
    
    @IBOutlet var TheTeachersAdmin: UITableView!
    var teacherNameArray = [AllTeacherResult]()
    let loadingView = UIView()
    let spinner = UIActivityIndicatorView()
    let loadingLabel = UILabel()
    let fadeAnimation = TableViewAnimation.Cell.fade(duration: 0.7)
    
    // Set the activity indicator into the main view
    private func setLoadingScreen() {
        
        // Sets the view which contains the loading text and the spinner
        let width: CGFloat = 120
        let height: CGFloat = 30
        let x = (tableView.frame.width / 2) - (width / 2)
        let y = (tableView.frame.height / 2) - (height / 2) - (navigationController?.navigationBar.frame.height)!
        loadingView.frame = CGRect(x: x, y: y, width: width, height: height)
        
        // Sets loading text
        loadingLabel.textColor = .gray
        loadingLabel.textAlignment = .center
        loadingLabel.text = "Loading..."
        loadingLabel.frame = CGRect(x: 0, y: 0, width: 140, height: 30)
        
        // Sets spinner
        spinner.style = .gray
        spinner.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        spinner.startAnimating()
        
        // Adds text and spinner to the view
        loadingView.addSubview(spinner)
        loadingView.addSubview(loadingLabel)
        
        tableView.addSubview(loadingView)
        
    }
    
    // Remove the activity indicator from the main view
    private func removeLoadingScreen() {
        
        // Hides and stops the text and the spinner
        spinner.stopAnimating()
        spinner.isHidden = true
        loadingLabel.isHidden = true
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.TheTeachersAdmin?.rowHeight = 50.0
        
        
        let admin = Admin()
        setLoadingScreen()
        let parameters = ["teacher_id" : UserDefaults.standard.string(forKey: "id")]
        admin.getTeacher(parameters: parameters as [String : AnyObject]) { (data, error) in
            if let teachers = data {
                self.teacherNameArray = teachers.RESULT
                self.performUIUpdatesOnMain {
                    self.removeLoadingScreen()
                    self.TheTeachersAdmin.reloadData()
                    self.TheTeachersAdmin.animate(animation: self.fadeAnimation)
                }
            }
                
            else if let error = error {
                if error.code == 1001 {
                    self.performUIUpdatesOnMain {
                        self.removeLoadingScreen()
                        SCLAlertView().showError("Error happened", subTitle: "Please check your internet connection", closeButtonTitle:"Ok".localized)
                    }
                }
                else {
                    self.performUIUpdatesOnMain {
                        self.removeLoadingScreen()
                        SCLAlertView().showError("Error happened", subTitle: "Server error happened. please check your internet connection or contact with application's author", closeButtonTitle:"Ok".localized)
                    }
                }
                print(error)
            }
        }
    }
    //adminuser
    //AddTeachersTableViewCell
    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return teacherNameArray.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddTeachersTableViewCell") as! AddTeachersTableViewCell
        cell.NameTeacherLable.text = teacherNameArray[indexPath.row].name
        cell.ImageTeacher.image = UIImage(named: "adminuser")
        
        return cell
    }
    
    override  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if(teacherNameArray[indexPath.row].id == UserDefaults.standard.string(forKey: "id")) {
            SCLAlertView().showError("Error".localized, subTitle: "You can't delete super admin".localized, closeButtonTitle:"Ok".localized)
            
        }
        else {
            if editingStyle == .delete {
                let admin = Admin()
                let teacher = teacherNameArray[indexPath.row].id
                let parameters = ["id" : teacher]
                setLoadingScreen()
                admin.deleteTeacher(parameters: parameters as [String : AnyObject]) { (response, error) in
                    if let response = response{
                        if response.contains("inserted"){
                            self.performUIUpdatesOnMain {
                                self.removeLoadingScreen()
                                SCLAlertView().showSuccess("Success".localized, subTitle:"Admin Deleted successfully".localized, closeButtonTitle:"Ok".localized)
                                self.TheTeachersAdmin.reloadData()
                            }
                        }
                        else{
                            self.performUIUpdatesOnMain {
                                SCLAlertView().showError("Error".localized, subTitle: "Server Error, please contact with applications author".localized, closeButtonTitle:"Ok".localized)
                                self.removeLoadingScreen()
                            }
                        }
                    }
                }
                
                teacherNameArray.remove(at: indexPath.row)
                tableView.beginUpdates()
                tableView.deleteRows(at: [indexPath], with: .automatic)
                tableView.endUpdates()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedAdmin = teacherNameArray[indexPath.row]
        
        let appearence = SCLAlertView.SCLAppearance(
            showCloseButton: false, showCircularIcon: true
        )
        let addAdminAlertView = SCLAlertView(appearance: appearence)
        let NameAdminTextField = addAdminAlertView.addTextField("Add name Admin".localized)
        let phoneNumberAdminTextField = addAdminAlertView.addTextField("Add Phone Admin".localized)
        
        let PaaswordTextField = addAdminAlertView.addTextField("Add Password Admin".localized)
        PaaswordTextField.isSecureTextEntry = true
        
        NameAdminTextField.textAlignment = .center
        phoneNumberAdminTextField.textAlignment = .center
        PaaswordTextField.textAlignment = .center
        
        NameAdminTextField.text = selectedAdmin.name
        phoneNumberAdminTextField.text = selectedAdmin.phone
        PaaswordTextField.text = selectedAdmin.pass
        
        addAdminAlertView.addButton("Edit") {
            if(NameAdminTextField.text!.isEmpty || phoneNumberAdminTextField.text!.isEmpty || PaaswordTextField.text!.isEmpty ) {
                SCLAlertView().showError("Error".localized, subTitle:"Some field is empty".localized, closeButtonTitle:"Ok".localized)
            }
            else {
                let admin = Admin()
                let parameters = ["id" : selectedAdmin.id,
                                  "phone" : phoneNumberAdminTextField.text!,
                                  "name" : NameAdminTextField.text!,
                                  "pass" : PaaswordTextField.text!]
                self.teacherNameArray.removeAll()
                self.setLoadingScreen()
                admin.updateTeacher(parameters: parameters as [String : AnyObject], completion: {(data, error) in
                    if let data = data {
                        if data.contains("inserted"){
                            self.performUIUpdatesOnMain {
                                let parameters = ["teacher_id" : UserDefaults.standard.string(forKey: "id")]
                                admin.getTeacher(parameters: parameters as [String : AnyObject]) { (data, error) in
                                    if let teachers = data {
                                        self.teacherNameArray = teachers.RESULT
                                        self.performUIUpdatesOnMain {
                                            SCLAlertView().showSuccess("Success".localized, subTitle:"Admin is updated successfully", closeButtonTitle:"Ok".localized)
                                            self.removeLoadingScreen()
                                            if selectedAdmin.id == UserDefaults.standard.string(forKey:"id"){
                                                UserDefaults.standard.set(NameAdminTextField.text!, forKey: "admin_name")
                                            }
                                            self.TheTeachersAdmin.reloadData()
                                        }
                                    }
                                    else if let error = error {
                                        if error.code == 1001 {
                                            self.performUIUpdatesOnMain {
                                                self.removeLoadingScreen()
                                                SCLAlertView().showError("Error happened", subTitle: "Please check your internet connection", closeButtonTitle:"Ok".localized)
                                            }
                                        }
                                        else {
                                            self.performUIUpdatesOnMain {
                                                self.removeLoadingScreen()
                                                SCLAlertView().showError("Error happened", subTitle: "Server error happened. please check your internet connection or contact with application's author", closeButtonTitle:"Ok".localized)
                                            }
                                        }
                                        print(error)
                                    }
                                }
                            }
                        }
                        else {
                            self.performUIUpdatesOnMain {
                                self.removeLoadingScreen()
                                SCLAlertView().showError("Error".localized, subTitle: "Server Error, please contact with applications author".localized, closeButtonTitle:"Ok".localized)
                                self.TheTeachersAdmin.reloadData()
                                
                            }
                        }
                    }
                    else if let error = error {
                        self.performUIUpdatesOnMain {
                            if error.code == 1001 {
                                self.performUIUpdatesOnMain {
                                    self.removeLoadingScreen()
                                    SCLAlertView().showError("Error happened", subTitle: "Please check your internet connection", closeButtonTitle:"Ok".localized)
                                }
                            }
                            else {
                                self.performUIUpdatesOnMain {
                                    self.removeLoadingScreen()
                                    SCLAlertView().showError("Error happened", subTitle: "Server error happened. please check your internet connection or contact with application's author", closeButtonTitle:"Ok".localized)
                                }
                            }
                            print(error)
                        }
                    }
                })
            }
        }
        addAdminAlertView.addButton("Cancal".localized) {
            addAdminAlertView.dismiss(animated: true, completion: nil)
        }
        let alertViewIcon = UIImage(named: "adminuser")
        addAdminAlertView.showInfo("Edit Admin", subTitle: "", circleIconImage: alertViewIcon)
    }
    
    @IBAction func AddTeacherAction(_ sender: Any) {
        let appearence = SCLAlertView.SCLAppearance(
            showCloseButton: false, showCircularIcon: true
        )
        let addAdminAlertView = SCLAlertView(appearance: appearence)
        let NameAdminTextField = addAdminAlertView.addTextField("Add name Admin".localized)
        let phoneNumberAdminTextField = addAdminAlertView.addTextField("Add Phone Admin".localized)
        
        let PaaswordTextField = addAdminAlertView.addTextField("Add Password Admin".localized)
        PaaswordTextField.isSecureTextEntry = true
        
        NameAdminTextField.textAlignment = .center
        phoneNumberAdminTextField.textAlignment = .center
        PaaswordTextField.textAlignment = .center
        
        addAdminAlertView.addButton("Add".localized) {
            if(NameAdminTextField.text!.isEmpty || phoneNumberAdminTextField.text!.isEmpty || PaaswordTextField.text!.isEmpty ) {
                SCLAlertView().showError("Error".localized, subTitle:"Some field is empty".localized, closeButtonTitle:"Ok".localized)
            }
            else {
                let admin = Admin()
                let parameters = ["phone" : phoneNumberAdminTextField.text,
                                  "name" : NameAdminTextField.text,
                                  "pass" : PaaswordTextField.text,
                                  "teacher_id" : UserDefaults.standard.string(forKey: "id")]
                self.teacherNameArray.removeAll()
                self.setLoadingScreen()
                admin.insertTeacher(parameters: parameters as [String : AnyObject], completion: {(data, error) in
                    if let data = data {
                        if data.contains("inserted"){
                            self.performUIUpdatesOnMain {
                                let parameters = ["teacher_id" : UserDefaults.standard.string(forKey: "id")]
                                admin.getTeacher(parameters: parameters as [String : AnyObject]) { (data, error) in
                                    if let teachers = data {
                                        self.teacherNameArray = teachers.RESULT
                                        self.performUIUpdatesOnMain {
                                            self.removeLoadingScreen()
                                            SCLAlertView().showSuccess("Success".localized, subTitle:"is added successfully".localized, closeButtonTitle:"Ok".localized)
                                            self.TheTeachersAdmin.reloadData()
                                        }
                                    }
                                    else if let error = error {
                                        if error.code == 1001 {
                                            self.performUIUpdatesOnMain {
                                                self.removeLoadingScreen()
                                                SCLAlertView().showError("Error happened", subTitle: "Please check your internet connection", closeButtonTitle:"Ok".localized)
                                            }
                                        }
                                        else {
                                            self.performUIUpdatesOnMain {
                                                self.removeLoadingScreen()
                                                SCLAlertView().showError("Error happened", subTitle: "Server error happened. please check your internet connection or contact with application's author", closeButtonTitle:"Ok".localized)
                                            }
                                        }
                                        print(error)
                                    }
                                }
                                self.TheTeachersAdmin.reloadData()
                            }
                        }
                        else {
                            self.performUIUpdatesOnMain {
                                self.removeLoadingScreen()
                                SCLAlertView().showError("Error".localized, subTitle: "Server Error, please contact with applications author".localized, closeButtonTitle:"Ok".localized)
                                self.TheTeachersAdmin.reloadData()
                                
                            }
                        }
                    }
                    else if let error = error {
                        self.performUIUpdatesOnMain {
                            if error.code == 1001 {
                                self.performUIUpdatesOnMain {
                                    self.removeLoadingScreen()
                                    SCLAlertView().showError("Error happened", subTitle: "Please check your internet connection", closeButtonTitle:"Ok".localized)
                                }
                            }
                            else {
                                self.performUIUpdatesOnMain {
                                    self.removeLoadingScreen()
                                    SCLAlertView().showError("Error happened", subTitle: "Server error happened. please check your internet connection or contact with application's author", closeButtonTitle:"Ok".localized)
                                }
                            }
                            print(error)
                        }
                    }
                })
            }
        }
        addAdminAlertView.addButton("Cancal".localized) {
            addAdminAlertView.dismiss(animated: true, completion: nil)
        }
        let alertViewIcon = UIImage(named: "adminuser")
        addAdminAlertView.showInfo("Add Admin".localized, subTitle: "", circleIconImage: alertViewIcon)
        
    }
    
    func inserNewIndexNameAdmin(){
        
        let indexPath = IndexPath(row: teacherNameArray.count - 1, section: 0)
        TheTeachersAdmin.insertRows(at: [indexPath], with: .left)
        TheTeachersAdmin.reloadData()
        
    }
    
    
}
