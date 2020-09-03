//
//  CorrectAnswerViewController.swift
//  El-Khateeb
//
//  Created by Eyad Shokry on 10/4/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import UIKit

class CorrectAnswerViewController: UIViewController {
    @IBOutlet weak var evaluationImage: UIImageView!
    @IBOutlet weak var evaluationLabel: UILabel!
    
    var delegate: DismissManager?
    var isCorrect = true

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if(isCorrect) {
            self.evaluationImage.image = UIImage(named: "check-1")
            self.evaluationLabel.text = "CORRECT ANSWER!"
        }
        else {
            self.evaluationImage.image = UIImage(named: "wrong")
            self.evaluationLabel.text = "WRONG ANSWER :("
        }
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
