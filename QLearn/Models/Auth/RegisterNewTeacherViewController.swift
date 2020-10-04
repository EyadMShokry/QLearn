//
//  RegisterNewTeacherViewController.swift
//  QLearn
//
//  Created by Eyad Shokry on 8/30/20.
//  Copyright © 2020 Eyad Shokry. All rights reserved.
//

import UIKit
import SCLAlertView

class RegisterNewTeacherViewController: UIViewController {
    
    @IBOutlet weak var teacherNameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var subjectTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    var maxAdminId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onClickAddButton(_ sender: UIButton) {
        if(teacherNameTextField.text!.isEmpty || phoneNumberTextField.text!.isEmpty || passwordTextField.text!.isEmpty || confirmPasswordTextField.text!.isEmpty || subjectTextField.text!.isEmpty) {
            SCLAlertView().showError("Error".localized, subTitle:"Some field is empty".localized, closeButtonTitle:"Ok".localized)
        }
        else if (passwordTextField.text != confirmPasswordTextField.text) {
            SCLAlertView().showError("Error".localized, subTitle:"Passwords do not match".localized, closeButtonTitle:"Ok".localized)
        }
        else {
            let admin = Admin()
            let parameters = ["phone" : phoneNumberTextField.text,
                              "password" : passwordTextField.text]
            admin.login(parameters: parameters as [String : AnyObject]) { (admin, error) in
                if let admin = admin {
                    if admin.RESULT.count > 0 {
                        self.performUIUpdatesOnMain {
                            SCLAlertView().showError("Error".localized, subTitle: "This teacher already exists".localized, closeButtonTitle:"Ok".localized)
                        }
                    }
                    else {
                        let admin = Admin()
                        admin.getMaxId { (data, error) in
                            if let maxId = data {
                                self.performUIUpdatesOnMain {
                                    self.maxAdminId = maxId.RESULT[0].max_id
                                    let user = User()
                                    let parameters = ["id" : maxId,
                                                      "name" : self.teacherNameTextField.text!,
                                                      "password" : self.passwordTextField.text!,
                                                      "phone" : self.phoneNumberTextField.text!,
                                                      "subject" : self.subjectTextField.text!] as [String : Any]
                                    user.register(method: "insert_admin.php", parameters: parameters as [String : AnyObject]) { (response, error) in
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
