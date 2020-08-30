//
//  NewRegistrationViewController.swift
//  El-Khateeb
//
//  Created by Abdalah on 9/26/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import UIKit
import Foundation
import SCLAlertView
class NewRegistrationViewController: UIViewController{

    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var StudentNumText: UITextField!
    @IBOutlet weak var ParentNumText: UITextField!
    @IBOutlet weak var FullNameText: UITextField!
    @IBOutlet weak var RegisterButtom: UIButton!
    @IBOutlet weak var PasswordText: UITextField!
    @IBOutlet weak var ConfirmPassword: UITextField!
    @IBOutlet weak var levelText: UITextField!
        var iconClick = true
    var registerType = "student"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.StudentNumText.delegate = self
          self.ParentNumText.delegate = self
          self.FullNameText.delegate = self
          self.PasswordText.delegate = self
          self.ConfirmPassword.delegate = self
          self.levelText.delegate = self
         self.titleLable.text = "Your Data is Not Registered,Start Registering Now".localized
        RegisterButtom.setTitle("New Registration".localized, for: .normal)
        localiztion()
        //add button in text
        addButton(textField:PasswordText)
        addButton(textField:ConfirmPassword)
        //add pic in text
        let emailImage = UIImage(named:"call-answer")
        addLeftImageTo(txtField: StudentNumText, andImage: emailImage!)
        _ = UIImage(named:"call-answer")
        addLeftImageTo(txtField: ParentNumText, andImage: emailImage!)
      
     
    }
    

    @IBAction func NewRegistrationAction(_ sender: UIButton) {
        //validate for all fields here
        if StudentNumText.text!.isEmpty || ParentNumText.text!.isEmpty || FullNameText.text!.isEmpty || PasswordText.text!.isEmpty ||
            ConfirmPassword.text!.isEmpty{
            SCLAlertView().showError("Error".localized, subTitle:"Some field is empty".localized, closeButtonTitle:"Ok".localized)
        } else {
        if ((self.PasswordText.text?.elementsEqual(self.ConfirmPassword.text!))! != true)
        {
            SCLAlertView().showError("Error".localized, subTitle:"Passwords do not match".localized, closeButtonTitle:"Ok".localized)
            
            return
        }
        else {
            if registerType == "student" {
                let student = Student()
                let studentParameters = ["phone" : StudentNumText.text?.replacedArabicDigitsWithEnglish]
                student.getStudentByPhone(parameters: studentParameters as [String : AnyObject]) { (student, error) in
                    if let student = student {
                        if student.RESULT.count > 0 {
                            self.performUIUpdatesOnMain {
                                SCLAlertView().showError("Error".localized, subTitle: "This student already exists".localized, closeButtonTitle:"Ok".localized)
                            }
                        }
                        else {
                            let user = User()
                            self.performUIUpdatesOnMain {
                                let parameters = ["name" : self.FullNameText.text,
                                                  "phone" : self.StudentNumText.text?.replacedArabicDigitsWithEnglish,
                                                  "parentPhone" : self.ParentNumText.text?.replacedArabicDigitsWithEnglish,
                                                  "level" : self.levelText.text,
                                                  "password" : self.PasswordText.text]
                                
                                user.register(method: "insert_student.php", parameters: parameters as [String : AnyObject]) { (response, error) in
                                    if let response = response{
                                        print(response)
                                        if response.contains("inserted"){
                                            self.performUIUpdatesOnMain {
                                                let appearence = SCLAlertView.SCLAppearance(
                                                    showCloseButton: false
                                                )
                                                let successAlertView = SCLAlertView(appearance: appearence)
                                                successAlertView.addButton("Ok".localized, action: {

                                                    self.navigationController?.popViewController(animated: true)
                                                    
                                                })
                                                successAlertView.showSuccess("Success".localized, subTitle: "Successfull registeration".localized)

                                            }
                                        }else{
                                            self.performUIUpdatesOnMain {
                                                SCLAlertView().showError("Error".localized, subTitle: "Server Error, please contact with applications author".localized, closeButtonTitle:"Ok".localized)
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
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
   }
    }
    
    @IBAction func refresh(_ sender: Any) {
        if(iconClick == true) {
            PasswordText.isSecureTextEntry = false
            ConfirmPassword.isSecureTextEntry = false

            
        } else {
            PasswordText.isSecureTextEntry = true
            ConfirmPassword.isSecureTextEntry = true

        }
        
        iconClick = !iconClick
    }
    
    func localiztion(){
    StudentNumText.placeholder = "Student's Phone Number".localized
    ParentNumText.placeholder = "Father's Phone Number".localized
    FullNameText.placeholder = "Full Name".localized
    PasswordText.placeholder = "Password".localized
    ConfirmPassword.placeholder = "Confirm The Password".localized
    levelText.placeholder = "level".localized
    }
    
    
    func addButton(textField:UITextField){
        textField.rightViewMode = .unlessEditing
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "eye-close-up (1)"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: -16, right: 0)
        button.frame = CGRect(x: CGFloat(textField.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        button.addTarget(self, action: #selector(self.refresh), for: .touchUpInside)
        textField.rightView = button
        textField.rightViewMode = .always
    }
    func addLeftImageTo(txtField: UITextField, andImage img: UIImage) {
        let leftImageView = UIImageView(frame: CGRect(x: 0.0, y: -16, width: img.size.width, height: img.size.height))
        leftImageView.image = img
        txtField.rightView = leftImageView
        txtField.rightViewMode = .always
        
    }

}



extension NewRegistrationViewController:UITextFieldDelegate{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
