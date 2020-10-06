//
//  ExternalLinksViewController.swift
//  QLearn
//
//  Created by Eyad Shokry on 10/5/20.
//  Copyright © 2020 Eyad Shokry. All rights reserved.
//

import UIKit
import SCLAlertView
import TableFlip


class ExternalLinksViewController: UIViewController {
    @IBOutlet weak var linksTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var addNewLinkBarButtonItem: UIBarButtonItem!
    var links: [Link] = []
    let fadeAnimation = TableViewAnimation.Cell.fade(duration: 0.7)
    var teacherId = ""
    var studentLevel = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        linksTableView.dataSource = self
        linksTableView.delegate = self
        if(UserDefaults.standard.string(forKey: "type") == "teacher") {
            addNewLinkBarButtonItem.isEnabled = true
            addNewLinkBarButtonItem.tintColor = UIColor(displayP3Red: 194/255, green: 139/255, blue: 188/255, alpha: 1.0)
            teacherId = UserDefaults.standard.string(forKey: "id")!
        }
        else {
            addNewLinkBarButtonItem.isEnabled = false
            addNewLinkBarButtonItem.tintColor = .clear
            self.studentLevel = UserDefaults.standard.string(forKey: "student_level")!
        }
        linksTableView.separatorColor = .lightGray
        self.linksTableView?.rowHeight = 70.0
        
        activityIndicator.startAnimating()
        var user: User
        user = User()
        
        let parameters = ["teacher_id" : teacherId, "level" : studentLevel]
        print(parameters)
        user.getExternalLinks(parameters: parameters as [String : AnyObject]) {(links, error) in
            if let links = links {
                self.links = links.RESULT
                print("Links: \(self.links)")
                self.performUIUpdatesOnMain {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    self.linksTableView.reloadData()
                    self.linksTableView.animate(animation: self.fadeAnimation)
                }
            }
            else if let error = error {
                self.performUIUpdatesOnMain {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                }
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
            }
        }
    }
    
    @IBAction func onClickAddNewLink(_ sender: UIBarButtonItem) {
        
    }
    

}


extension ExternalLinksViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return links.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "externalLinkCell") as! ExternalLinkTableViewCell
        cell.linkNameLabel.text = links[indexPath.row].title
        cell.linkDescribtionLabel.text = links[indexPath.row].description
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let urlString = links[indexPath.row].URL
        let url = URL(string: urlString)
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)

    }
}
