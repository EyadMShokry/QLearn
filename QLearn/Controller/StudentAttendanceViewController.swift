//
//  StudentAttendanceViewController.swift
//  QLearn
//
//  Created by Eyad Shokry on 11/22/20.
//  Copyright © 2020 Eyad Shokry. All rights reserved.
//

import UIKit

class StudentAttendanceViewController: UIViewController {

    @IBOutlet weak var studentIdLabel: UILabel!
    @IBOutlet weak var qrCodeImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        studentIdLabel.text = "رقم الطالب: \(UserDefaults.standard.string(forKey: "id")!)"
        qrCodeImageView.image = generateQRCode(from: UserDefaults.standard.string(forKey: "id")!)
    }
    
    fileprivate func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        return nil
    }


}
