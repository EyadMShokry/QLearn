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
            
        }
    }

}
