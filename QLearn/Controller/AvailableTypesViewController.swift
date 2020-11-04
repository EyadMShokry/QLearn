//
//  AvailableTypesViewController.swift
//  El-Khateeb
//
//  Created by Eyad Shokry on 9/19/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import UIKit
import SCLAlertView
import TableFlip

class AvailableTypesViewController: UIViewController {

    @IBOutlet weak var pdfTypesTableView: UITableView!
    @IBOutlet weak var addNewTypeButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var headerView: UIView!

    var typesArray: [CategoryResult] = []
    var isPdf = true
    var chapterName = ""
    var selectedChapterId = ""
    let fadeAnimation = TableViewAnimation.Cell.fade(duration: 0.7)
    var teacherId = ""
    var selectedLevel = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(UserDefaults.standard.string(forKey: "type") != "teacher") {
            headerView.isHidden = true
            UserDefaults.standard.string(forKey: "student_level")
        }

        self.view.bringSubviewToFront(activityIndicator)
        var student: Student
        student = Student()
        if(isPdf) {
            if(UserDefaults.standard.string(forKey: "type") == "teacher") {
                self.teacherId = UserDefaults.standard.string(forKey: "id")!
            }
            else {
                self.selectedLevel = UserDefaults.standard.string(forKey: "student_level")!
            }
            let parameters = ["teacher_id" : teacherId, "level" : selectedLevel]
            activityIndicator.startAnimating()
            student.getPdfCategories(parameters: parameters as [String : AnyObject]) {(categories, error) in
                if let categories = categories {
                    self.typesArray = categories.RESULT
                    self.performUIUpdatesOnMain {
                        self.activityIndicator.stopAnimating()
                        self.activityIndicator.isHidden = true
                        self.pdfTypesTableView.reloadData()
                        self.pdfTypesTableView.animate(animation: self.fadeAnimation)
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
            }
        }
        else {
            //call essay types api here
            var parameters = ["teacher_id" : UserDefaults.standard.string(forKey: "id"), "level" : selectedLevel]
            if(UserDefaults.standard.string(forKey: "type") == "student") {
                parameters = ["teacher_id" : teacherId, "level" : UserDefaults.standard.string(forKey: "student_level")!]
            }
            student.getEssayTypes(parameters: parameters as [String : AnyObject]) {(essayTypes, error) in
                if let essayTypes = essayTypes {
                    self.typesArray = essayTypes.RESULT
                    self.performUIUpdatesOnMain {
                        self.activityIndicator.stopAnimating()
                        self.activityIndicator.isHidden = true
                        self.pdfTypesTableView.reloadData()
                        self.pdfTypesTableView.animate(animation: self.fadeAnimation)
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
            }
        }

        // Do any additional setup after loading the view.
        pdfTypesTableView.dataSource = self
        pdfTypesTableView.delegate = self
        pdfTypesTableView.separatorColor = .clear
        
        
    }
   
    @IBAction func onClickAddNewTypeButton(_ sender: Any) {
        let appearence = SCLAlertView.SCLAppearance(
            showCloseButton: false, showCircularIcon: true
        )
        let addNewTypeAlertView = SCLAlertView(appearance: appearence)
        let newTypeTextField = addNewTypeAlertView.addTextField("Add New Type".localized)

        newTypeTextField.textAlignment = .center
        
        addNewTypeAlertView.addButton("Add".localized) {
            if(newTypeTextField.text!.isEmpty) {
                SCLAlertView().showError("Error".localized, subTitle:"Some field is empty".localized, closeButtonTitle:"Ok".localized)
            }
            else {
                if(self.isPdf) {
                    let parameters = ["title" : newTypeTextField.text!,
                                      "teacher_id" : UserDefaults.standard.string(forKey: "id"),
                                      "level" : self.selectedLevel]
                    let admin = Admin()
                    self.typesArray.removeAll()
                    
                    self.activityIndicator.isHidden = false
                    self.activityIndicator.startAnimating()
                    admin.insertCategory(parameters: parameters as [String : AnyObject]) {(data, error) in
                        if let response = data{
                            if response.contains("inserted"){
                                self.performUIUpdatesOnMain {
                                    let parameters = ["teacher_id" : UserDefaults.standard.string(forKey: "id"), "level" : self.selectedLevel]
                                    admin.getPdfCategories(parameters: parameters as [String : AnyObject]) {(data, error) in
                                        if let types = data {
                                            self.typesArray = types.RESULT
                                            self.performUIUpdatesOnMain {
                                                SCLAlertView().showSuccess("Success".localized, subTitle:"New category is added successfully".localized, closeButtonTitle:"Ok".localized)
                                                self.pdfTypesTableView.reloadData()
                                            }
                                        }
                                        else if let error = error {
                                            self.performUIUpdatesOnMain {
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
                            }
                            else{
                                self.performUIUpdatesOnMain {
                                    SCLAlertView().showError("Error".localized, subTitle: "Server Error, please contact with applications author".localized, closeButtonTitle:"Ok".localized)
                                    
                                }
                            }
                        }
                    }
                    self.performUIUpdatesOnMain {
                        self.activityIndicator.stopAnimating()
                        self.activityIndicator.isHidden = true
                    }
                }
                else {
                    //call add new essay type api
                    let parameters = ["title" : newTypeTextField.text!,
                                      "level" : self.selectedLevel,
                                      "teacherID" : UserDefaults.standard.string(forKey: "id")]
                    let admin = Admin()
                    self.typesArray.removeAll()
                    
                    self.activityIndicator.isHidden = false
                    self.activityIndicator.startAnimating()
                    admin.insertEssayType(parameters: parameters as [String : AnyObject]) {(data, error) in
                        if let response = data{
                            if response.contains("inserted"){
                                self.performUIUpdatesOnMain {
                                    let parameters = ["teacher_id" : UserDefaults.standard.string(forKey: "id"),
                                                      "level" : self.selectedLevel]
                                    admin.getEssayTypes(parameters: parameters as [String : AnyObject]) {(data, error) in
                                        if let types = data {
                                            self.performUIUpdatesOnMain {
                                                SCLAlertView().showSuccess("Success".localized, subTitle:"New type is added successfully".localized, closeButtonTitle:"Ok".localized)
                                            }
                                            self.typesArray = types.RESULT
                                            self.performUIUpdatesOnMain {
                                                self.pdfTypesTableView.reloadData()
                                                self.activityIndicator.stopAnimating()
                                                self.activityIndicator
                                                    .isHidden = true
                                            }
                                        }
                                        else if let error = error {
                                            self.performUIUpdatesOnMain {
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
                                                    self.activityIndicator
                                                        .isHidden = true
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            else{
                                self.performUIUpdatesOnMain {
                                    SCLAlertView().showError("Error".localized, subTitle: "Server Error, please contact with applications author".localized, closeButtonTitle:"Ok".localized)                         }
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
            }
        }
        addNewTypeAlertView.addButton("Cancal".localized) {
            addNewTypeAlertView.dismiss(animated: true, completion: nil)
            
        }
        
        let alertViewIcon: UIImage
        if(isPdf) {
            alertViewIcon = UIImage(named: "add_pdf_icon")!
        }
        else {
            alertViewIcon = UIImage(named: "book")!
        }
        addNewTypeAlertView.showInfo("Add New Type".localized, subTitle: "", circleIconImage: alertViewIcon)
    }
    
}



extension AvailableTypesViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return typesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "typeCell") as! TypeTableViewCell
        cell.typeLabel.text = typesArray[indexPath.row].title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(isPdf) {
            let pdfTypeVC = storyboard?.instantiateViewController(withIdentifier: "PDFType") as! PDFTypeViewController
            pdfTypeVC.navigationItem.title = typesArray[indexPath.row].title
            pdfTypeVC.selectedCategoryId = typesArray[indexPath.row].id
            pdfTypeVC.teacherId = self.teacherId
            pdfTypeVC.selectedLevel = self.selectedLevel
            self.navigationController?.pushViewController(pdfTypeVC, animated: true)
        }
        else {
            //for student
            if(UserDefaults.standard.value(forKey: "admin_name") == nil) {
                let essayQuestionVC = storyboard?.instantiateViewController(withIdentifier: "EssayQuestionsStudent") as! EssayQuestionsStudentViewController
                essayQuestionVC.questionType = typesArray[indexPath.row].title
                essayQuestionVC.title = chapterName
                essayQuestionVC.selectedChapterId = selectedChapterId
                essayQuestionVC.selectedTypeId = typesArray[indexPath.row].id
                essayQuestionVC.teacherId = self.teacherId
                
                self.navigationController?.pushViewController(essayQuestionVC, animated: true)
            }
            else {
                let askEssayQuestionVC = storyboard?.instantiateViewController(withIdentifier: "EssayQuestion") as! CreateEssayQuestionViewController
                askEssayQuestionVC.selectedChapterId = selectedChapterId
                askEssayQuestionVC.questionType = typesArray[indexPath.row].title
                askEssayQuestionVC.title = chapterName
                askEssayQuestionVC.questionTypeId = typesArray[indexPath.row].id
                askEssayQuestionVC.selectedLevel = self.selectedLevel
                self.navigationController?.pushViewController(askEssayQuestionVC, animated: true)
            }
        }
    }
    
}
