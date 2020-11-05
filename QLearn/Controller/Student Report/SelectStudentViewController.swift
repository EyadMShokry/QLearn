//
//  SelectStudentViewController.swift
//  El-Khateeb
//
//  Created by Eyad Shokry on 9/16/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import UIKit
import TableFlip
import SCLAlertView

class SelectStudentViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var studentsTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var selectedLevel = ""
    var studentsArray = [StudentResult]()
    var filteredStudentsArray: [StudentResult] = []

    let fadeAnimation = TableViewAnimation.Cell.fade(duration: 0.7)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        studentsTableView.dataSource = self
        studentsTableView.delegate = self
        searchBar.delegate = self
        
        let admin = Admin()
        activityIndicator.startAnimating()
        let parameters = ["teacher_id" : UserDefaults.standard.string(forKey: "id")!,
                          "level" : selectedLevel]
        print(parameters)
        admin.getStudentsByTeacher(parameters: parameters as [String : AnyObject]) { (data, error) in
            if let students = data {
                self.studentsArray = students.RESULT
                self.filteredStudentsArray = self.studentsArray
                print(self.studentsArray)
                self.performUIUpdatesOnMain {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    self.studentsTableView.reloadData()
                    self.studentsTableView.animate(animation: self.fadeAnimation)
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

    }
    
}


extension SelectStudentViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredStudentsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentTableViewCell") as! StudentTableViewCell
        cell.studentDataLabel.text = filteredStudentsArray[indexPath.row].name + " - " + filteredStudentsArray[indexPath.row].id 
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let studentReportVC = self.storyboard?.instantiateViewController(withIdentifier: "StudentReport") as! StudentReportViewController
        studentReportVC.isStudentRequest = false
        studentReportVC.selectedStudentId = filteredStudentsArray[indexPath.row].id
        studentReportVC.selectedStudentName = filteredStudentsArray[indexPath.row].name
        
        self.navigationController?.pushViewController(studentReportVC, animated: true)
    }
}


extension SelectStudentViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredStudentsArray = searchText.isEmpty ? studentsArray : studentsArray.filter {
            
            $0.name.contains(searchText) || $0.id.contains(searchText)
            
        }
        studentsTableView.reloadData()
        
        if searchBar.text?.count == 0{
      
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
       
    }
    
}
