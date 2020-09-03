//
//  TimetableViewController.swift
//  El-Khateeb
//
//  Created by Eyad Shokry on 9/14/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import UIKit
import SCLAlertView

class TimetableViewController: UIViewController {
    @IBOutlet weak var timetableTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var timesArray: [String] = []
    var placesArray: [String] = []
    var teacherId = ""
    var levelName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        timetableTableView.dataSource = self
        timetableTableView.delegate = self
        
        activityIndicator.startAnimating()
        var user: User
        user = User()
        let parameters = ["teacher_id" : self.teacherId, "level" : UserDefaults.standard.string(forKey: "student_level")]
        user.getLessionDates(parameters: parameters as [String : AnyObject]) {(dates, error) in
            if let dates = dates {
                self.levelName = dates.RESULT[0].levelTitle
                for date in dates.RESULT {
                    self.placesArray.append(date.place)
                    self.timesArray.append("\(date.day) \(date.time):\(date.minutes)")
                }
                self.performUIUpdatesOnMain {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    self.timetableTableView.reloadData()
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


extension TimetableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let attachment = NSTextAttachment()
        attachment.image = UIImage(named: "location")
        let attachmentString = NSAttributedString(attachment: attachment)
        
        
        let cell = timetableTableView.dequeueReusableCell(withIdentifier: "AppointmentCell")
        let cellString = NSMutableAttributedString(string: "\(timesArray[indexPath.row])  |  \(placesArray[indexPath.row]) ")
        cellString.append(attachmentString)
        cell?.textLabel?.attributedText = cellString
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionName: String
        
        switch section {
        case 0:
            sectionName = self.levelName
            
        default:
            sectionName = ""
        }
        
        return sectionName
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = .clear
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor(displayP3Red: 48/255, green: 140/255, blue: 239/255, alpha: 1.0)
    }
}
