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
        let appearence = SCLAlertView.SCLAppearance(
            showCloseButton: false, showCircularIcon: true
        )
        let addLinkAlertView = SCLAlertView(appearance: appearence)
        let titleTextField = addLinkAlertView.addTextField("Link Title".localized)
        let descriptionTextFIeld = addLinkAlertView.addTextField("Link Description".localized)
        let linkTextField = addLinkAlertView.addTextField("Link".localized)
                
        titleTextField.textAlignment = .center
        descriptionTextFIeld.textAlignment = .center
        linkTextField.textAlignment = .center
        
        addLinkAlertView.addButton("Add".localized) {
            if(titleTextField.text!.isEmpty || descriptionTextFIeld.text!.isEmpty || linkTextField.text!.isEmpty ) {
                SCLAlertView().showError("Error".localized, subTitle:"Some field is empty".localized, closeButtonTitle:"Ok".localized)
            }
            else {
                let admin = Admin()
                var url = ""
                let writtenUrl = linkTextField.text!
                if(writtenUrl.hasPrefix("https://") || writtenUrl.hasPrefix("Https://") || writtenUrl.hasPrefix("http://") || writtenUrl.hasPrefix("Http://")) {
                    url = writtenUrl
                }
                else {
                    url = "https://\(writtenUrl)"
                }
                print("Url: \(url)")
                let parameters = ["title" : titleTextField.text!,
                                  "description" : descriptionTextFIeld.text!,
                                  "URL" : url,
                                  "level" : self.studentLevel,
                                  "teacher_id" : UserDefaults.standard.string(forKey: "id")]
                self.links.removeAll()
                self.activityIndicator.isHidden = false
                self.activityIndicator.startAnimating()
                admin.insertExternalLink(parameters: parameters as [String : AnyObject], completion: {(data, error) in
                    if let data = data {
                        if data.contains("inserted"){
                            self.performUIUpdatesOnMain {
                                let parameters = ["teacher_id" : UserDefaults.standard.string(forKey: "id"), "level" : self.studentLevel]
                                admin.getExternalLinks(parameters: parameters as [String : AnyObject]) { (data, error) in
                                    if let links = data {
                                        self.links = links.RESULT
                                        self.performUIUpdatesOnMain {
                                            self.activityIndicator.stopAnimating()
                                            self.activityIndicator.isHidden = true
                                            SCLAlertView().showSuccess("Success".localized, subTitle:"is added successfully".localized, closeButtonTitle:"Ok".localized)
                                            self.linksTableView.reloadData()
                                        }
                                    }
                                    else if let error = error {
                                        if error.code == 1001 {
                                            self.performUIUpdatesOnMain {
                                                self.activityIndicator.stopAnimating()
                                                self.activityIndicator.isHidden = true
                                                SCLAlertView().showError("Error happened", subTitle: "Please check your internet connection", closeButtonTitle:"Ok".localized)
                                            }
                                        }
                                        else {
                                            self.performUIUpdatesOnMain {
                                                self.activityIndicator.stopAnimating()
                                                self.activityIndicator.isHidden = true
                                                SCLAlertView().showError("Error happened", subTitle: "Server error happened. please check your internet connection or contact with application's author", closeButtonTitle:"Ok".localized)
                                            }
                                        }
                                        print(error)
                                    }
                                }
                                self.linksTableView.reloadData()
                            }
                        }
                        else {
                            self.performUIUpdatesOnMain {
                                self.activityIndicator.stopAnimating()
                                self.activityIndicator.isHidden = true
                                SCLAlertView().showError("Error".localized, subTitle: "Server Error, please contact with applications author".localized, closeButtonTitle:"Ok".localized)
                                self.linksTableView.reloadData()
                                
                            }
                        }
                    }
                    else if let error = error {
                        self.performUIUpdatesOnMain {
                            if error.code == 1001 {
                                self.performUIUpdatesOnMain {
                                    self.activityIndicator.stopAnimating()
                                    self.activityIndicator.isHidden = true
                                    SCLAlertView().showError("Error happened", subTitle: "Please check your internet connection", closeButtonTitle:"Ok".localized)
                                }
                            }
                            else {
                                self.performUIUpdatesOnMain {
                                    self.activityIndicator.stopAnimating()
                                    self.activityIndicator.isHidden = true
                                    SCLAlertView().showError("Error happened", subTitle: "Server error happened. please check your internet connection or contact with application's author", closeButtonTitle:"Ok".localized)
                                }
                            }
                            print(error)
                        }
                    }
                })
            }
        }
        addLinkAlertView.addButton("Cancal".localized) {
            addLinkAlertView.dismiss(animated: true, completion: nil)
        }
        let alertViewIcon = UIImage(named: "link")
        addLinkAlertView.showInfo("Add External Link".localized, subTitle: "", circleIconImage: alertViewIcon)

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
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if(UserDefaults.standard.string(forKey: "type") == "teacher") {
            return .delete
        }
        else {
            return .none
        }
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let admin = Admin()
            let linkId = links[indexPath.row].id
            let parameters = ["id" : linkId]
            admin.deleteExternalLink(parameters: parameters as [String : AnyObject]) { (response, error) in
                if let response = response{
                    if response.contains("inserted"){
                        self.performUIUpdatesOnMain {
                            SCLAlertView().showSuccess("Success".localized, subTitle:"Link Deleted successfully".localized, closeButtonTitle:"Ok".localized)
                            self.linksTableView.reloadData()
                        }
                    }else{
                        
                        self.performUIUpdatesOnMain {
                            SCLAlertView().showError("Error".localized, subTitle: "Server Error, please contact with applications author".localized, closeButtonTitle:"Ok".localized)
                            
                        }
                    }
                }
            }
            links.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
            
        }
    }

}
