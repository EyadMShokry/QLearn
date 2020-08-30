//
//  UIViewController+Extension.swift
//  El-Khateeb
//
//  Created by Eyad Shokry on 9/15/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
        DispatchQueue.main.async {
            updates()
        }
    }
    
    func showInfo(withTitle: String, withMessage: String, action: (() -> Void)? = nil) {
        performUIUpdatesOnMain {
            let alertController = UIAlertController(title: withTitle, message: withMessage, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {(alertAction) in
                action?()
            }))
            self.present(alertController, animated: true)
        }
    }
    
}
