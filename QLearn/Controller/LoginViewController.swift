//
//  LoginViewController.swift
//  El-Khateeb
//
//  Created by Abdalah on 9/14/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import UIKit
import SCLAlertView
//import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var studentView: UIView!
    @IBOutlet weak var teacherView: UIView!
    @IBOutlet weak var fatherView: UIView!
    @IBOutlet weak var RegisterButtom: UIButton!
    @IBOutlet weak var textFieldOne: UITextField!
    @IBOutlet weak var textFieldTwo: UITextField!
    @IBOutlet weak var SignORForget: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var userType = "student"
    var iconClick = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFieldTwo.delegate = self
        textFieldOne.delegate = self
        studentView.createBorderForView(color: UIColor.lightGray, radius: studentView.frame.height/2)
        RegisterButtom.setTitle("New Registration".localized, for: .normal)
        
        addButton(textField:textFieldTwo)
        let emailImage = UIImage(named:"call-answer")
        addLeftImageTo(txtField: textFieldOne, andImage: emailImage!)
        activityIndicator.isHidden = true
        
        
    }
    
    
    
    
    @IBAction func refresh(_ sender: Any) {
        if(iconClick == true) {
            textFieldTwo.isSecureTextEntry = false
            
            
        } else {
            textFieldTwo.isSecureTextEntry = true
            
            
        }
        
        iconClick = !iconClick
    }
    
    //mark->  button login
    
    @IBAction func onClickLoginButton(_ sender: Any) {
        if textFieldOne.text!.isEmpty {
            SCLAlertView().showError("Error".localized, subTitle:"Some field is empty".localized, closeButtonTitle:"Ok".localized)
        }
        else {
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            if userType == "student" {
                let student = Student()
                let parameters = ["phone" : textFieldOne.text!.replacedArabicDigitsWithEnglish]
                print(parameters)
                student.login(parameters: parameters as [String : AnyObject]) {(data, error) in
                    if let student = data {
                        print(student)
                        if student.RESULT.count != 0 {
                            UserDefaults.standard.set(student.RESULT[0].id, forKey: "id")
                            UserDefaults.standard.set(student.RESULT[0].level, forKey: "student_level")
                            UserDefaults.standard.set(student.RESULT[0].name, forKey: "student_name")
                            UserDefaults.standard.set(student.RESULT[0].parentPhone, forKey: "student_parent_phone")
                            UserDefaults.standard.set(student.RESULT[0].phone, forKey: "student_phone")
                            UserDefaults.standard.set("student", forKey: "type")
                            self.performUIUpdatesOnMain {
                                self.activityIndicator.stopAnimating()
                                self.activityIndicator.isHidden = true
                                if(student.RESULT[0].password == "") {
                                    let confirmPasswordVC = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmPassword") as! ConfirmPasswordViewController
                                    self.navigationController?.pushViewController(confirmPasswordVC, animated: true)
                                }
                                else if(student.RESULT[0].password == self.textFieldTwo.text) {
                                    //                                let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "Login") as! HomeViewController
                                    //                                homeVC.userType = self.userType
                                    //                                self.navigationController?.popViewController(animated: true)
                                    let studentTeachersVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeView") as! UINavigationController
                                    studentTeachersVC.modalPresentationStyle = .fullScreen
                                    self.textFieldOne.text = ""
                                    self.textFieldTwo.text = ""
                                    self.present(studentTeachersVC, animated: true, completion: nil)
                                    
                                }
                                else {
                                    SCLAlertView().showError("Error".localized, subTitle: "Incorrect Password".localized)
                                }
                            }
                        }
                        else {
                            self.performUIUpdatesOnMain {
                                self.activityIndicator.stopAnimating()
                                self.activityIndicator.isHidden = true
                                SCLAlertView().showError("Error".localized, subTitle:"This student doesn't exists".localized, closeButtonTitle:"Ok".localized)
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
                }
            }
            else if userType == "teacher" {
                if(textFieldTwo.text!.isEmpty) {
                    SCLAlertView().showError("Error".localized, subTitle:"Some field is empty".localized, closeButtonTitle:"Ok".localized)
                }
                else {
                    let admin = Admin()
                    let parameters = ["phone" : textFieldOne.text?.replacedArabicDigitsWithEnglish,
                                      "password" : textFieldTwo.text]
                    print(parameters)
                    admin.login(parameters: parameters as [String : AnyObject]) {(data, error) in
                        if let admin = data {
                            print(admin)
                            if admin.RESULT.count == 1 {
                                UserDefaults.standard.set(admin.RESULT[0].teacherID, forKey: "id")
                                UserDefaults.standard.set(admin.RESULT[0].id, forKey: "sub_id")
                                UserDefaults.standard.set(admin.RESULT[0].name, forKey: "admin_name")
                                UserDefaults.standard.set(admin.RESULT[0].phone, forKey: "admin_phone")
                                UserDefaults.standard.set("teacher", forKey: "type")
                                self.performUIUpdatesOnMain {
                                    self.activityIndicator.stopAnimating()
                                    self.activityIndicator.isHidden = true
                                    let selectLevelVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectLevelsNavigation") as! UINavigationController
                                    selectLevelVC.modalPresentationStyle = .fullScreen
                                    self.textFieldOne.text = ""
                                    self.textFieldTwo.text = ""
                                    self.present(selectLevelVC, animated: true, completion: nil)
                                }
                            }
                            else {
                                self.performUIUpdatesOnMain {
                                    self.activityIndicator.stopAnimating()
                                    self.activityIndicator.isHidden = true
                                    SCLAlertView().showError("Error".localized, subTitle:"This admin doesn't exists".localized, closeButtonTitle:"Ok".localized)
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
                    }
                }
                
            }
            else if userType == "parent" {
                if(textFieldTwo.text!.isEmpty) {
                    SCLAlertView().showError("Error".localized, subTitle:"Some field is empty".localized, closeButtonTitle:"Ok".localized)
                }
                else {
                    let parent = Parent()
                    let parameters = ["phone" : textFieldOne.text?.replacedArabicDigitsWithEnglish,
                                      "parentPhone" : textFieldTwo.text?.replacedArabicDigitsWithEnglish]
                    parent.login(parameters: parameters as [String : AnyObject]) {(data, error) in
                        if let parent = data {
                            if parent.RESULT.count == 1 {
                                UserDefaults.standard.set(parent.RESULT[0].id, forKey: "id")
                                UserDefaults.standard.set(parent.RESULT[0].level, forKey: "student_level")
                                UserDefaults.standard.set(parent.RESULT[0].name, forKey: "student_name")
                                UserDefaults.standard.set(parent.RESULT[0].parentPhone, forKey: "student_parent_phone")
                                UserDefaults.standard.set(parent.RESULT[0].phone, forKey: "student_phone")
                                UserDefaults.standard.set("parent", forKey: "type")
                                self.performUIUpdatesOnMain {
                                    self.activityIndicator.stopAnimating()
                                    self.activityIndicator.isHidden = true
                                    let studentTeachersVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeView") as! UINavigationController
                                    studentTeachersVC.modalPresentationStyle = .fullScreen
                                    self.textFieldOne.text = ""
                                    self.textFieldTwo.text = ""
                                    self.present(studentTeachersVC, animated: true, completion: nil)
                                }
                            }
                            else {
                                self.performUIUpdatesOnMain {
                                    self.activityIndicator.stopAnimating()
                                    self.activityIndicator.isHidden = true
                                    SCLAlertView().showError("Error".localized, subTitle:"This parent doesn't exists".localized, closeButtonTitle:"Ok".localized)
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
                    }
                }
            }
        }
    }
    
    @IBAction func GoNewRegistration(_ sender: UIButton) {
        print("register")
        print("user type: \(self.userType)")
        if (self.userType == "student") {
            let registerStudentVC = storyboard?.instantiateViewController(withIdentifier: "NewRegistrationViewController") as! NewRegistrationViewController
            self.navigationController?.pushViewController(registerStudentVC, animated: true)
        }
        else {
            let registerTeacherVC = storyboard?.instantiateViewController(withIdentifier: "RegisterNewTeacher") as! RegisterNewTeacherViewController
            self.navigationController?.pushViewController(registerTeacherVC, animated: true)
        }
        
    }
    //mark->  button forget password
    
    @IBAction func onClickforgetPasswordButton(_ sender: Any) {
        
        let appearence = SCLAlertView.SCLAppearance(
            showCloseButton: false, showCircularIcon: true
        )
        let addPhoneNumberAlertView = SCLAlertView(appearance: appearence)
        let countryCodeTextField = addPhoneNumberAlertView.addTextField("Your country code".localized)
        let phoneNumberTextField = addPhoneNumberAlertView.addTextField("Phone Number".localized)
        
        countryCodeTextField.text = "+2"
        countryCodeTextField.textAlignment = .center
        countryCodeTextField.keyboardType = .numberPad
        phoneNumberTextField.textAlignment = .center
        phoneNumberTextField.keyboardType = UIKeyboardType.numberPad
        addPhoneNumberAlertView.addButton("Add".localized) {
            if(phoneNumberTextField.text!.isEmpty) {
                SCLAlertView().showError( "Error".localized, subTitle:"Some field is empty".localized, closeButtonTitle:"Ok".localized)
            }
            else {
                //                let basicPhoneNumber = String((phoneNumberTextField.text?.dropFirst(2))!)
                let basicPhoneNumber = phoneNumberTextField.text!.replacedArabicDigitsWithEnglish
                let parameters = ["phone" : basicPhoneNumber]
                let student = Student()
                self.activityIndicator.isHidden = false
                self.activityIndicator.startAnimating()
                student.getStudentByPhone(parameters: parameters as [String : AnyObject], completion: { (data, error) in
                    if let student = data {
                        if student.RESULT.count > 0 {
                            //user is exists send it to verfication screen
                            self.performUIUpdatesOnMain {
                                self.activityIndicator.stopAnimating()
                                self.activityIndicator.isHidden = true
                                let confirmCodeVC = self.storyboard?.instantiateViewController(withIdentifier: "VerficationCode") as! ConfirmCodeViewController
                                confirmCodeVC.studentPhoneNumber = countryCodeTextField.text!.replacedArabicDigitsWithEnglish + phoneNumberTextField.text!.replacedArabicDigitsWithEnglish
                                confirmCodeVC.basicPhoneNumber = basicPhoneNumber
                                self.navigationController?.pushViewController(confirmCodeVC, animated: true)
                            }
                        }
                        else {
                            self.performUIUpdatesOnMain {
                                self.activityIndicator.stopAnimating()
                                self.activityIndicator.isHidden = true
                                SCLAlertView().showError( "Error".localized, subTitle:"This user isn't exist".localized, closeButtonTitle:"Ok".localized)
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
                })
            }
        }
        addPhoneNumberAlertView.addButton("Cancal".localized) {
            addPhoneNumberAlertView.dismiss(animated: true, completion: nil)
            
        }
        
        let alertViewIcon = UIImage(named: "phone")
        addPhoneNumberAlertView.showInfo("Please enter your phone number to recieve a verfication code".localized, subTitle: "", circleIconImage: alertViewIcon)
        
        
    }
    @IBAction func onClickStudentButton(_ sender: UIButton)  {
        
        //        if sender.isSelected{
        sender.isSelected = false
        buttonForget(hidden: false)
        buttonRegister(hidden: false)
        studentView.createBorderForView(color: UIColor.lightGray, radius: studentView.frame.height/2)
        fatherView.createBorderForView(color: UIColor.clear, radius: fatherView.frame.height/2)
        teacherView.createBorderForView(color: UIColor.clear, radius: teacherView.frame.height/2)
        self.userType = "student"
        
        self.textFieldOne.placeholder = "Phone number".localized
        self.textFieldTwo.placeholder = "Password".localized
        self.textFieldTwo.keyboardType = .default
        self.textFieldTwo.isSecureTextEntry = true
        addButton(textField:textFieldTwo)
        
        //        }
        //        else{
        //            sender.isSelected = true
        //            studentView.createBorderForView(color: UIColor.clear, radius: 15)
        //        }
        
    }
    
    
    @IBAction func onClickTeacherButton(_ sender: UIButton) {
        
        //        if sender.isSelected{
        sender.isSelected = false
        buttonForget(hidden: true)
        buttonRegister(hidden: false)
        teacherView.createBorderForView(color: UIColor.lightGray, radius: teacherView.frame.height/2)
        studentView.createBorderForView(color: UIColor.clear, radius: studentView.frame.height/2)
        fatherView.createBorderForView(color: UIColor.clear, radius: fatherView.frame.height/2)
        self.userType = "teacher"
        
        self.textFieldOne.placeholder = "Phone number".localized
        self.textFieldTwo.placeholder = "Password".localized
        self.textFieldTwo.keyboardType = .default
        self.textFieldTwo.isSecureTextEntry = true
        addButton(textField:textFieldTwo)
        
        //        }
        //        else{
        //            sender.isSelected = true
        //            teacherView.createBorderForView(color: UIColor.clear, radius: 15)
        //        }
    }
    
    @IBAction func onClickfatherButton(_ sender: UIButton)  {
        
        //        if sender.isSelected{
        sender.isSelected = false
        buttonForget(hidden: true)
        buttonRegister(hidden: true)
        fatherView.createBorderForView(color: UIColor.lightGray, radius: fatherView.frame.height/2)
        teacherView.createBorderForView(color: UIColor.clear, radius: teacherView.frame.height/2)
        studentView.createBorderForView(color: UIColor.clear, radius: studentView.frame.height/2)
        self.userType = "parent"
        
        self.textFieldOne.placeholder = "Student phone number".localized
        self.textFieldTwo.placeholder = "Parent phone number".localized
        self.textFieldTwo.keyboardType = .phonePad
        self.textFieldTwo.isSecureTextEntry = false
        self.textFieldTwo.rightView = nil
        let emailImage = UIImage(named:"call-answer")
        addLeftImageTo(txtField: textFieldOne, andImage: emailImage!)
        
        //        }
        //        else{
        //            sender.isSelected = true
        //            fatherView.createBorderForView(color: UIColor.clear, radius: fatherView.frame.height/2)
        //        }
    }
    
    func buttonForget (hidden:Bool){
        SignORForget?.isHidden = hidden
    }
    
    func buttonRegister (hidden:Bool){
        RegisterButtom?.isHidden = hidden
    }
    
    func addButton(textField:UITextField){
        textField.rightViewMode = .unlessEditing
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "eye-close-up (1)"), for: .normal)
        
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: -18, right: 0)
        button.frame = CGRect(x: CGFloat(textField.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        button.addTarget(self, action: #selector(self.refresh), for: .touchUpInside)
        textField.rightView = button
        textField.rightViewMode = .always
    }
    
    func addLeftImageTo(txtField: UITextField, andImage img: UIImage) {
        let leftImageView = UIImageView(frame: CGRect(x: 0.0, y: -22, width: img.size.width, height: img.size.height))
        leftImageView.image = img
        txtField.rightView = leftImageView
        txtField.rightViewMode = .always
        
    }
}

extension LoginViewController:UITextFieldDelegate{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        
        return true
    }
}

extension UIView{
    public func createBorderForView(color: UIColor, radius: CGFloat, width: CGFloat = 8) {
        layer.borderWidth = width
        layer.cornerRadius = radius
        layer.shouldRasterize = false
        layer.rasterizationScale = 2
        clipsToBounds = true
        layer.masksToBounds = true
        let cgColor: CGColor = color.cgColor
        layer.borderColor = cgColor
    }
}
