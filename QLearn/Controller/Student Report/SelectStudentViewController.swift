//
//  SelectStudentViewController.swift
//  El-Khateeb
//
//  Created by Eyad Shokry on 9/16/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import UIKit

class SelectStudentViewController: UIViewController {
    
    @IBOutlet weak var levelPickerView: UIPickerView!
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    let pickerViewArray = ["1", "2", "3"]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        levelPickerView.dataSource = self
        levelPickerView.delegate = self
        
        idTextField.layer.borderWidth = 1
        idTextField.layer.cornerRadius = 10.0
        idTextField.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    @IBAction func onClickSearchButton(_ sender: Any) {
    }

    

}


extension SelectStudentViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerViewArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerViewArray[row]
    }
}


