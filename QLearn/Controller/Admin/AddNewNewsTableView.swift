//
//  AddNewNewsTableView.swift
//  El-Khateeb
//
//  Created by Abdalah on 9/19/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import UIKit
import SCLAlertView
import TableFlip

class AddNewNewsTableView: UITableViewController {
    var dataPicker: UIDatePicker!
    @IBOutlet var NewNewsTable: UITableView!
    var newsArray = [AllNewsResult]()
    let loadingView = UIView()
    let spinner = UIActivityIndicatorView()
    let loadingLabel = UILabel()
    let fadeAnimation = TableViewAnimation.Cell.fade(duration: 0.7)

    // Set the activity indicator into the main view
    private func setLoadingScreen() {
        
        // Sets the view which contains the loading text and the spinner
        let width: CGFloat = 120
        let height: CGFloat = 30
        let x = (tableView.frame.width / 2) - (width / 2)
        let y = (tableView.frame.height / 2) - (height / 2) - (navigationController?.navigationBar.frame.height)!
        loadingView.frame = CGRect(x: x, y: y, width: width, height: height)
        
        // Sets loading text
        loadingLabel.textColor = .gray
        loadingLabel.textAlignment = .center
        loadingLabel.text = "Loading..."
        loadingLabel.frame = CGRect(x: 0, y: 0, width: 140, height: 30)
        
        // Sets spinner
        spinner.style = .gray
        spinner.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        spinner.startAnimating()
        
        // Adds text and spinner to the view
        loadingView.addSubview(spinner)
        loadingView.addSubview(loadingLabel)
        
        tableView.addSubview(loadingView)
        
    }
    
    // Remove the activity indicator from the main view
    private func removeLoadingScreen() {
        
        // Hides and stops the text and the spinner
        spinner.stopAnimating()
        spinner.isHidden = true
        loadingLabel.isHidden = true
        
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        self.NewNewsTable?.rowHeight = 60.0

        let admin = Admin()
        setLoadingScreen()
        let parameters = ["teacher_id" : UserDefaults.standard.string(forKey: "id")!]
        admin.getAllNews(parameters: parameters as [String : AnyObject]) { (data, error) in
            if let getAllNews = data {
                self.newsArray = getAllNews.RESULT
                print(self.newsArray)
                self.performUIUpdatesOnMain {
                    self.removeLoadingScreen()
                    self.NewNewsTable.reloadData()
                    self.NewNewsTable.animate(animation: self.fadeAnimation)
                }
            }
            else if let error = error {
                if error.code == 1001 {
                    self.performUIUpdatesOnMain {
                        self.removeLoadingScreen()
                        SCLAlertView().showError("Error happened", subTitle: "Please check your internet connection", closeButtonTitle:"Ok".localized)
                    }
                }
                else {
                    self.performUIUpdatesOnMain {
                        self.removeLoadingScreen()
                        SCLAlertView().showError("Error happened", subTitle: "Server error happened. please check your internet connection or contact with application's author", closeButtonTitle:"Ok".localized)
                    }
                }
                print(error)
            }
        }
    }

    // MARK: - Table view data source

   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return newsArray.count

    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddNewNewsTableViewCell") as! AddNewNewsTableViewCell
        cell.AddNewNewslable.text = newsArray[indexPath.row].news_text
        cell.NewsDate.text = newsArray[indexPath.row].expire_date
        
        return cell
    }
 
    override  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let admin = Admin()
            let news = newsArray[indexPath.row].id
            let idNews = ["id":news]
            setLoadingScreen()
            admin.deleteNews(parameters: idNews as [String : AnyObject]) { (response, error) in
                if let response = response {
                    if response.contains("inserted"){
                        self.performUIUpdatesOnMain {
                            SCLAlertView().showSuccess("Success".localized, subTitle:"Your News Deleted successfully".localized, closeButtonTitle:"Ok".localized)
                            self.removeLoadingScreen()
                            self.NewNewsTable.reloadData()
                        }
                    } else {
                        self.performUIUpdatesOnMain {
                            self.removeLoadingScreen()
                            SCLAlertView().showError("Error".localized, subTitle: "Server Error, please contact with applications author".localized, closeButtonTitle:"Ok".localized)
                        }
                    }
                }
                else if let error = error {
                    self.performUIUpdatesOnMain {
                        self.removeLoadingScreen()
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
            newsArray.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
            
        }
    }

    @IBAction func AddNewsAction(_ sender: Any) {
        var textFieldNews = UITextField()
        let myDatePicker = UIDatePicker()
        let dateFormatter = DateFormatter()
       
       
        let alert = UIAlertController(title: "\n\n\n\n\n\n\n\n", message: nil, preferredStyle: UIAlertController.Style.alert)
        
     
        myDatePicker.datePickerMode = UIDatePicker.Mode.date
        dateFormatter.dateFormat = "yyyy-MM-dd"
        myDatePicker.addTarget(self, action: #selector(AddNewNewsTableView.dateChanged(datePicker:)), for: .valueChanged)
        myDatePicker.frame = CGRect(x: 0, y: 15, width: 270, height: 200)
        alert.view.addSubview(myDatePicker)
        
                alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Creat new item".localized
            
            
            alertTextField.textAlignment = .center
            
            textFieldNews = alertTextField
       

        let selectAction = UIAlertAction(title:  "Add".localized , style: UIAlertAction.Style.default, handler: { _ in
            let selectedDate = dateFormatter.string(from: myDatePicker.date)
            print(selectedDate)
            let admin = Admin()
            let parameters = ["teacher_id" : UserDefaults.standard.string(forKey: "id")!, "expire_date" : selectedDate, "news_text" : textFieldNews.text!]
            self.newsArray.removeAll()
            self.setLoadingScreen()
            print(parameters)
            admin.insertNews(parameters: parameters as [String : AnyObject]) { (response, error) in
                if let response = response{
                    if response.contains("inserted"){
                        self.performUIUpdatesOnMain {
                            let parameters = ["teacher_id" : UserDefaults.standard.string(forKey: "id")!]
                            print(parameters)
                            admin.getAllNews(parameters: parameters as [String : AnyObject]) {(data, error) in
                                if let getAllNews = data {
                                    self.newsArray = getAllNews.RESULT
                                    print(self.newsArray)
                                    self.performUIUpdatesOnMain {
                                        self.removeLoadingScreen()
                                        SCLAlertView().showSuccess("Success".localized, subTitle:"is added successfully".localized, closeButtonTitle:"Ok".localized)
                                        self.NewNewsTable.reloadData()
                                    }
                                }
                                else if let error = error {
                                    if error.code == 1001 {
                                        self.performUIUpdatesOnMain {
                                            self.removeLoadingScreen()
                                            SCLAlertView().showError("Error happened", subTitle: "Please check your internet connection", closeButtonTitle:"Ok".localized)
                                        }
                                    }
                                    else {
                                        self.performUIUpdatesOnMain {
                                            self.removeLoadingScreen()
                                            SCLAlertView().showError("Error happened", subTitle: "Server error happened. please check your internet connection or contact with application's author", closeButtonTitle:"Ok".localized)
                                        }
                                    }
                                    print(error)
                                }
                            }
                            self.NewNewsTable.reloadData()
                        }

                    }else{
                        self.performUIUpdatesOnMain {
                            self.removeLoadingScreen()
                            SCLAlertView().showError("Error".localized, subTitle: "Server Error, please contact with applications author".localized, closeButtonTitle:"Ok".localized)
                            self.NewNewsTable.reloadData()
                            
                        }
                    }
                }
                else if let error = error {
                    self.performUIUpdatesOnMain {
                        self.removeLoadingScreen()
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
            self.NewNewsTable.reloadData()
            self.NewNewsTable.beginUpdates()
            
            self.NewNewsTable.endUpdates()
        })
                    
                    
                   
        let cancelAction = UIAlertAction(title:"Cancal".localized, style: UIAlertAction.Style.default, handler: { _ in
        })
        alert.addAction(selectAction)
        alert.addAction(cancelAction)
        
        self.present(alert,animated: true,completion: nil)
            
                    
    
    }
    }
    @objc func dateChanged(datePicker:UIDatePicker){
        
        view.endEditing(true)
    }

  
}
