//
//  ConfirmPasswordViewController.swift
//  El-Khateeb
//
//  Created by Abdalah on 10/21/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import UIKit
import SCLAlertView

class ConfirmPasswordViewController: UIViewController {
    @IBOutlet weak var TheCode: UILabel!
    @IBOutlet weak var ConfirmNewPassword: UITextField!
    @IBOutlet weak var TheNewPassword: UITextField!
    @IBOutlet weak var changePasswordLabel: UILabel!
    @IBOutlet weak var changePasswordButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var studentPassword = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        changePasswordButton.setTitle("change password".localized, for: .normal)
        skipButton.setTitle("skip".localized, for: .normal)
        ConfirmNewPassword.placeholder = "Confirm The Password".localized
        TheNewPassword.placeholder = "Password".localized
        changePasswordLabel.text = "you can change password".localized

        print("password: \(studentPassword)")
        TheCode.text = "Your password: \(studentPassword)"
        activityIndicator.isHidden = true
        
    }

    @IBAction func ChangePasswordAction(_ sender: Any) {
        if ConfirmNewPassword.text!.isEmpty||TheNewPassword.text!.isEmpty {
            SCLAlertView().showError("Error".localized, subTitle:"Some field is empty".localized, closeButtonTitle:"Ok".localized)
        }
        else {
            if((self.TheNewPassword.text?.elementsEqual(self.ConfirmNewPassword.text!))! != true) {
                SCLAlertView().showError("Error".localized, subTitle:"Passwords do not match".localized, closeButtonTitle:"Ok".localized)
                return
            }
            else {
                //call change password api here
                let parameters = ["id" : UserDefaults.standard.value(forKey: "id"),
                                  "password" : ConfirmNewPassword.text]
                let student = Student()
                self.activityIndicator.isHidden = false
                self.activityIndicator.startAnimating()
                student.updatePassword(parameters: parameters as [String : AnyObject]) { (response, error) in
                    if let response = response {
                        if response.contains("updated") {
                            self.performUIUpdatesOnMain {
                                self.activityIndicator.stopAnimating()
                                self.activityIndicator.isHidden = true
                                
                                
                                let appearence = SCLAlertView.SCLAppearance(
                                    showCloseButton: false
                                )
                                let successAlertView = SCLAlertView(appearance: appearence)
                                successAlertView.addButton("Ok".localized, action: {
                                    let studentTeachersVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeView") as! UINavigationController
                                    studentTeachersVC.modalPresentationStyle = .fullScreen
                                    self.present(studentTeachersVC, animated: true, completion: nil)
                                })
                                successAlertView.showSuccess("Success".localized, subTitle: "Password is changed successfully".localized)
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
    
    @IBAction func SkipAction(_ sender: Any) {
        let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "Login") as! HomeViewController
        homeVC.userType = "student"
        let navigationController = UINavigationController(rootViewController: homeVC)
        self.present(navigationController, animated: true)
    }
    
}
