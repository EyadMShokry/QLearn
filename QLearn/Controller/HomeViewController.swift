 //
 //  HomeViewController.swift
 //  El-Khateeb
 //
 //  Created by Eyad Shokry on 9/12/19.
 //  Copyright © 2019 Eyad Shokry. All rights reserved.
 //
 
 import UIKit
 import SCLAlertView
 
 class HomeViewController: UIViewController {
    @IBOutlet weak var sectionsTableView: UITableView!
    @IBOutlet weak var newsView: SlidingText!
    @IBOutlet weak var addNewsButton: UIButton!
    @IBOutlet var buttonDrobMenu: [UIButton]!
    @IBOutlet weak var addTeachersButton: UIButton!
    @IBOutlet weak var newsButton: UIButton!
    @IBOutlet weak var AdminButton: UIButton!
    @IBOutlet weak var adminBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var studentNumberLabel: UILabel!
    
    var userType = ""
    //full features
    var sectionsNames = ["Questions Bag".localized, "Student Report".localized, "Appointements".localized, "Ask Us something".localized, "Uploaded PDFs".localized, "Teacher CV".localized, "Contact Us".localized]
    var sectionsImagesNames = ["questionbankicon", "studenticon", "timetalbeicon" ,"askquestionicon", "pdficon", "teachercv", "contactus"]

    var newsArray: [String] = []
 
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        newsArray.removeAll()
        
        if(UserDefaults.standard.value(forKey: "admin_name") == nil) {
            adminBarButtonItem.isEnabled = false
            adminBarButtonItem.tintColor = .clear
            studentNumberLabel.text = "رقم الطالب: 0"
        }
        else {
            adminBarButtonItem.isEnabled = true
            adminBarButtonItem.tintColor = UIColor(displayP3Red: 48/255, green: 140/255, blue: 239/255, alpha: 1.0)
        }
        let user = User()
        let parameters = ["today_date" : Date.getCurrentDate()]
        print("current date: \(Date.getCurrentDate()).... \(Date())")
        user.getUnexpiredNews(parameters: parameters as [String : AnyObject]) { (data, error) in
            if let unexpiredNews = data {
                for news in unexpiredNews.RESULT{
                    self.newsArray.append(news.news_text)
                }
                self.performUIUpdatesOnMain {
                    self.newsView.labelTexts = self.newsArray.joined(separator: "|n‏")
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
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        sectionsTableView.dataSource = self
        sectionsTableView.delegate = self
        sectionsTableView.isScrollEnabled = false
        sectionsTableView.separatorColor = .clear
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        button(hidden: true)
    }
       
    @IBAction func goAdminTable(_ sender: Any) {
         button (hidden: true)
        let AdminableVC = storyboard?.instantiateViewController(withIdentifier: "GoTheTeachers")
        navigationController?.pushViewController(AdminableVC!, animated: true)
    }
    
    @IBAction func goNewsTable(_ sender: Any) {
        
     button (hidden: true)

        let NewstableVC = storyboard?.instantiateViewController(withIdentifier: "GoTheAddNews")
        navigationController?.pushViewController(NewstableVC!, animated: true)
     
        
    }
    
    
   //MARk ->Button drobDownMenu
    @IBAction func drobDownMenu(_ sender: UIBarButtonItem) {

        UIView.animate(withDuration: 0.3) {
//            self.buttonDrobMenu.forEach { (button) in
//                button.isHidden = !button.isHidden
//                self.view.layIfNeeded()
//            }
            if(UserDefaults.standard.string(forKey: "id") == "1") {
                self.AdminButton.isHidden = !self.AdminButton.isHidden
                self.newsButton.isHidden = !self.newsButton.isHidden
                self.view.layoutIfNeeded()
            }
            else {
                self.AdminButton.isHidden = true
                self.newsButton.isHidden = !self.newsButton.isHidden
                self.view.layoutIfNeeded()

            }
        }
    }
   
    
    
    func button (hidden:Bool){
        AdminButton?.isHidden = hidden
        newsButton?.isHidden = hidden
    }
    
 }
 //GoTheTeachers
 //
 extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return sectionsNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell") as! HomeTableViewCell
            cell.cellLabel.text = sectionsNames[indexPath.row]
            cell.cellImageView.image = UIImage(named: sectionsImagesNames[indexPath.row])
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(UserDefaults.standard.value(forKey: "id") == nil) {
            if(indexPath.row == 3) {
                let cvTeacherVC =  storyboard?.instantiateViewController(withIdentifier: "CvTeacher")
                navigationController?.pushViewController(cvTeacherVC!, animated: true)
            }
            else if(indexPath.row == 4) {
                let contactUsVc =  storyboard?.instantiateViewController(withIdentifier: "ContactUs")
                navigationController?.pushViewController(contactUsVc!, animated: true)
            }
            else {
                SCLAlertView().showError("Access denied".localized, subTitle: "Contact with Mr. Tarek to get an account or login".localized, closeButtonTitle:"Ok".localized)
            }
        }
        else {
            let selectedRow = indexPath.row
            switch selectedRow {
            case 0:
                if(UserDefaults.standard.value(forKey: "user_type") == nil) {
                    let questionBagVC = storyboard?.instantiateViewController(withIdentifier: "QuestionsBag")
                    navigationController?.pushViewController(questionBagVC!, animated: true)
                }
                else {
                    SCLAlertView().showError("Access denied".localized, subTitle: "Parents can't access this content", closeButtonTitle:"Ok".localized)
                }
                
            case 1:
                //in case of user other than student or parent uncomment this
                //report
//                if(UserDefaults.standard.value(forKey: "admin_name") != nil) {
//                    let studentReportVC = storyboard?.instantiateViewController(withIdentifier: "SelectStudent")
//                    navigationController?.pushViewController(studentReportVC!, animated: true)
//                }
//                else {
//                    let studentReportVC = storyboard?.instantiateViewController(withIdentifier: "StudentReport")
//                    navigationController?.pushViewController(studentReportVC!, animated: true)
//                }
                if(UserDefaults.standard.value(forKey: "admin_name") != nil) {
                    let askUsVC = storyboard?.instantiateViewController(withIdentifier: "AskUs")
                    navigationController?.pushViewController(askUsVC!, animated: true)
                    
                }
                else {
                    if(UserDefaults.standard.value(forKey: "user_type") == nil) {
                        let askTeacherVC = storyboard?.instantiateViewController(withIdentifier: "AskTeacher")
                        navigationController?.pushViewController(askTeacherVC!, animated: true)
                    }
                    else {
                        SCLAlertView().showError("Access denied".localized, subTitle: "Parents can't access this content", closeButtonTitle:"Ok".localized)
                    }
                }
            case 2:
//                let timetableVC = storyboard?.instantiateViewController(withIdentifier: "Timetable")
//                navigationController?.pushViewController(timetableVC!, animated: true)
                if(UserDefaults.standard.value(forKey: "user_type") == nil) {
                    let uploadedPDFVC = storyboard?.instantiateViewController(withIdentifier: "AvailableTypes") as! AvailableTypesViewController
                    uploadedPDFVC.isPdf = true
                    navigationController?.pushViewController(uploadedPDFVC, animated: true)
                    
                }
                else {
                    SCLAlertView().showError("Access denied".localized, subTitle: "Parents can't access this content", closeButtonTitle:"Ok".localized)
                }

            case 3:
                let cvTeacherVC =  storyboard?.instantiateViewController(withIdentifier: "CvTeacher")
                navigationController?.pushViewController(cvTeacherVC!, animated: true)
                
            case 4:
                let contactUsVc =  storyboard?.instantiateViewController(withIdentifier: "ContactUs")
                navigationController?.pushViewController(contactUsVc!, animated: true)

            default:
                return
            }
        }
    }
 }
