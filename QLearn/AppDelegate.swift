//
//  AppDelegate.swift
//  El-Khateeb
//
//  Created by Eyad Shokry on 9/12/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import UIKit
import MOLH
import IQKeyboardManagerSwift
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MOLHResetable {
    

    var window: UIWindow?
    var navigationController : UINavigationController? //Navigation controller
    
    //Create singleton object
    static var sharedInstance: AppDelegate {
        return UIApplication.shared.delegate! as! AppDelegate
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if(UserDefaults.standard.value(forKey: "id") != nil && UserDefaults.standard.string(forKey: "type")  == "student") {
            let homeVC = storyboard.instantiateViewController(withIdentifier: "StudentTeachersVC") as! AvailableTeachersViewController
            self.window?.rootViewController = homeVC
        }
        else {
            let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginNavigationController") as! UINavigationController
            self.window?.rootViewController = loginVC
        }
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.disabledToolbarClasses = [AnswerQuestionViewController.self]
        MOLH.shared.activate(true)
        FirebaseApp.configure()
        
        return true
    }

    func reset() {
        let rootviewcontroller: UIWindow = ((UIApplication.shared.delegate?.window)!)!
        let stry = UIStoryboard(name: "Main", bundle: nil)
        rootviewcontroller.rootViewController = stry.instantiateViewController(withIdentifier: "HomeView")
    }
    
}

extension String{
    var localized:String{
        return NSLocalizedString(self, comment: "")
    }
}
