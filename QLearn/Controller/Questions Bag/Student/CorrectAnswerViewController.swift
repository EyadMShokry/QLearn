//
//  CorrectAnswerViewController.swift
//  El-Khateeb
//
//  Created by Eyad Shokry on 10/4/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import UIKit

class CorrectAnswerViewController: UIViewController {
    var delegate: DismissManager?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onClickNextButton(_ sender: Any) {
        delegate?.popoverDismiss(isExit: false)
        self.dismiss(animated: true, completion: nil)

    }
    
    @IBAction func onClickExitButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        delegate?.popoverDismiss(isExit: true)
    }
    
}
