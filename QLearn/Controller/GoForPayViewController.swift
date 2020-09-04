//
//  GoForPayViewController.swift
//  QLearn
//
//  Created by Eyad Shokry on 9/3/20.
//  Copyright © 2020 Eyad Shokry. All rights reserved.
//

import UIKit

class GoForPayViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func onClickAndroidVersionButton(_ sender: Any) {
        let url = URL(string: "https://play.google.com/store/apps/details?id=com.iLearn.teachers")
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    
    @IBAction func androidVersionButton(_ sender: Any) {
        let url = URL(string: "https://play.google.com/store/apps/details?id=com.iLearn.teachers")
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
}
