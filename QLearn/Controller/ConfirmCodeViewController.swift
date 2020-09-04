//
//  ConfirmCodeViewController.swift
//  El-Khateeb
//
//  Created by Abdalah on 10/21/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import UIKit
import SCLAlertView
//import FirebaseAuth

class ConfirmCodeViewController: UIViewController {
    @IBOutlet weak var YourCodeText: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var studentPhoneNumber = ""
    var basicPhoneNumber = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("full number: \(studentPhoneNumber)")
        confirmButton.setTitle("confirmation".localized, for: .normal)
        YourCodeText.placeholder = "your code".localized
        activityIndicator.startAnimating()
//        PhoneAuthProvider.provider().verifyPhoneNumber(studentPhoneNumber, uiDelegate: nil) { (verificationID, error) in
//            self.performUIUpdatesOnMain {
//                self.activityIndicator.stopAnimating()
//                self.activityIndicator.isHidden = true
//                if let error = error {
//                    SCLAlertView().showError("Error".localized, subTitle: "An error happened while sending verification code. You may entered wrong phone number".localized, closeButtonTitle:"Ok".localized)
//
//                    print(error)
//                    return
//
//                }
//                UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
//            }
//        }
    }
    
    
    @IBAction func ConfirmationAction(_ sender: Any) {
//        if YourCodeText.text!.isEmpty {
//            SCLAlertView().showError("Error".localized, subTitle:"Some field is empty".localized, closeButtonTitle:"Ok".localized)
//        }
//        else {
//            self.activityIndicator.isHidden = false
//            self.activityIndicator.startAnimating()
//            let credential = PhoneAuthProvider.provider().credential(withVerificationID: UserDefaults.standard.string(forKey: "authVerificationID")!, verificationCode: YourCodeText.text!)
//            Auth.auth().signIn(with: credential) { (authResult, error) in
//                if let error = error {
//                    self.performUIUpdatesOnMain {
//                        self.activityIndicator.stopAnimating()
//                        self.activityIndicator.isHidden = true
//                        if(error.localizedDescription.contains("The SMS verification code used to create the phone auth credential is invalid. Please resend the verification code SMS and be sure to use the verification code provided by the user.")) {
//                            SCLAlertView().showError("Error".localized, subTitle:"You entered invalid verification code".localized, closeButtonTitle:"Ok".localized)
//                        }
//                        else {
//                            SCLAlertView().showError("Error".localized, subTitle:"An error happened while sending verification code. please check your internet connection or try again later".localized, closeButtonTitle:"Ok".localized)
//                        }
//                        print(error.localizedDescription)
//                    }
//                }
//                else {
//                    print("--- signed in !!! ---")
//                    print(authResult!)
//                    let parameters = ["phone" : self.basicPhoneNumber]
//                    let student = Student()
//                    self.activityIndicator.isHidden = false
//                    self.activityIndicator.startAnimating()
//                    student.getStudentByPhone(parameters: parameters as [String : AnyObject], completion: { (data, error) in
//                        if let student = data {
//                            if student.RESULT.count > 0 {
//                                UserDefaults.standard.set(student.RESULT[0].id, forKey: "id")
//                                UserDefaults.standard.set(student.RESULT[0].level, forKey: "student_level")
//                                UserDefaults.standard.set(student.RESULT[0].name, forKey: "student_name")
//                                UserDefaults.standard.set(student.RESULT[0].parentPhone, forKey: "student_parent_phone")
//                                UserDefaults.standard.set(student.RESULT[0].phone, forKey: "student_phone")
//                                self.performUIUpdatesOnMain {
//                                    self.activityIndicator.stopAnimating()
//                                    self.activityIndicator.isHidden = true
//                                    let confirmPasswordVC = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmPassword") as! ConfirmPasswordViewController
//                                    confirmPasswordVC.studentPassword = student.RESULT[0].password
//                                    self.present(confirmPasswordVC, animated: true)
//                                }
//
//                            }
//                            else {
//                                self.performUIUpdatesOnMain {
//                                    self.activityIndicator.stopAnimating()
//                                    self.activityIndicator.isHidden = true
//                                    SCLAlertView().showError( "Error".localized, subTitle:"This user isn't exist".localized, closeButtonTitle:"Ok".localized)
//                                }
//                            }
//                        }
//                        else if let error = error {
//                            if error.code == 1001 {
//                                self.performUIUpdatesOnMain {
//                                    SCLAlertView().showError("Error happened", subTitle: "Please check your internet connection", closeButtonTitle:"Ok".localized)
//                                }
//                            }
//                            else {
//                                self.performUIUpdatesOnMain {
//                                    SCLAlertView().showError("Error happened", subTitle: "Server error happened. please check your internet connection or contact with application's author", closeButtonTitle:"Ok".localized)
//                                }
//                            }
//                            print(error)
//                            self.performUIUpdatesOnMain {
//                                self.activityIndicator.stopAnimating()
//                                self.activityIndicator.isHidden = true
//                            }
//                        }
//                    })
//
//                }
//            }
//        }
    }
    
    
}

