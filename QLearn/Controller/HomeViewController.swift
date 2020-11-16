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
    @IBOutlet weak var adminBarButtonItem: UIButton!
    @IBOutlet weak var studentNumberLabel: UILabel!
    
    var userType = ""
    var sectionsNames = ["Questions Bag".localized, "Student Report".localized, "Appointements".localized, "Ask Us something".localized, "Uploaded PDFs".localized, "Teacher CV".localized, "Contact Us".localized, "External Links".localized]
    var sectionsImagesNames = ["questionbankicon", "studenticon", "timetalbeicon" ,"askquestionicon", "pdficon", "teachercv", "contactus", "link"]
    var newsArray: [String] = []
    var teacherId = ""
    var subTeacherId = ""
    var teacherCard: [Card] = []
    var isMyTeacher = true
    var levelId = ""
    
    func getTeacherCard() {
        let student = Student()
        let parameters = ["teacher_id" : self.teacherId]
        print(parameters)
        student.getTeacherCard(parameters: parameters as [String : AnyObject]){ (data, error) in
            if let teacherCard = data {
                self.teacherCard = teacherCard.RESULT
                self.performUIUpdatesOnMain {
                    self.sectionsTableView.reloadData()
                }
                print("TeacherCard: \(self.teacherCard[0].status) - \(self.teacherCard[1].status)")
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
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getTeacherCard()
        newsArray.removeAll()
        
        if(UserDefaults.standard.value(forKey: "admin_name") == nil) {
            adminBarButtonItem.isEnabled = false
            adminBarButtonItem.isHidden = true
            adminBarButtonItem.tintColor = .clear
            studentNumberLabel.isHidden = false
            studentNumberLabel.text = "رقم الطالب: \(UserDefaults.standard.string(forKey: "id") ?? "0")"
        }
        else {
            adminBarButtonItem.isEnabled = true
            adminBarButtonItem.isHidden = false
            adminBarButtonItem.tintColor = UIColor(displayP3Red: 48/255, green: 140/255, blue: 239/255, alpha: 1.0)
            studentNumberLabel.isHidden = true
        }
        let user = User()
        let parameters = ["expire_date" : Date.getCurrentDate(),
                          "teacher_id" : self.teacherId]
        print("unexpired news : \(parameters)")
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
        if(UserDefaults.standard.string(forKey: "id") == UserDefaults.standard.string(forKey: "sub_id")) {
            button(hidden: true)
            let AdminableVC = storyboard?.instantiateViewController(withIdentifier: "GoTheTeachers")
            navigationController?.pushViewController(AdminableVC!, animated: true)
        }
        else {
            SCLAlertView().showError("Access denied".localized, subTitle: "Only Super Admins can access this content".localized)
        }
    }
    
    @IBAction func goNewsTable(_ sender: Any) {
        
        button(hidden: true)
        let NewstableVC = storyboard?.instantiateViewController(withIdentifier: "GoTheAddNews")
        navigationController?.pushViewController(NewstableVC!, animated: true)
    }
    
    //MARk ->Button drobDownMenu
    @IBAction func drobDownMenu(_ sender: UIButton) {
        print("clicked")
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
        return teacherCard.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell") as! HomeTableViewCell
        cell.cellLabel.text = sectionsNames[indexPath.row]
        cell.cellImageView.image = UIImage(named: sectionsImagesNames[indexPath.row])
        if(UserDefaults.standard.string(forKey: "type") == "teacher") {
            cell.teacherCardStackView.isHidden = false
            cell.lockingImage.isHidden = true
            cell.cellSwitch.isOn = teacherCard[indexPath.row].status == "1" ? true : false
            cell.availabilityLabel.text = teacherCard[indexPath.row].status == "1" ? "available for all students".localized : "available only for my students".localized
            cell.availabilityLabel.textColor = teacherCard[indexPath.row].status == "1" ? UIColor.green : UIColor.red
            cell.switchPressed = { [weak self] sender in
                let admin = Admin()
                var status = ""
                if sender.isOn {
                    status = "1"
                }
                else {
                    status = "0"
                }
                let parameters = ["status" : status,
                                  "teacherID" : UserDefaults.standard.string(forKey: "id"),
                                  "cardNumber" : self!.teacherCard[indexPath.row].cardNumber]
                print(parameters)
                admin.updateCardActivation(parameters: parameters as [String : AnyObject]) { (data, error) in
                    if let response = data{
                        if response.contains("inserted"){
                            self!.performUIUpdatesOnMain {
                                SCLAlertView().showSuccess("Success".localized, subTitle: "Status is changed successfully".localized, closeButtonTitle:"Ok".localized)
                                self?.getTeacherCard()
                            }
                        }
                        else{
                            self!.performUIUpdatesOnMain {
                                SCLAlertView().showError("Error".localized, subTitle: "Server Error, please contact with applications author".localized, closeButtonTitle:"Ok".localized)
                            }
                        }
                    }
                    else if let error = error {
                        if error.code == 1001 {
                            self!.performUIUpdatesOnMain {
                                SCLAlertView().showError("Error happened", subTitle: "Please check your internet connection", closeButtonTitle:"Ok".localized)
                            }
                        }
                        else {
                            self!.performUIUpdatesOnMain {
                                SCLAlertView().showError("Error happened", subTitle: "Server error happened. please check your internet connection or contact with application's author", closeButtonTitle:"Ok".localized)
                            }
                        }
                        print(error)
                    }
                }
            }
        }
        else if(!isMyTeacher){
            cell.teacherCardStackView.isHidden = true
            cell.lockingImage.isHidden = false
            if #available(iOS 13.0, *) {
                cell.lockingImage.image = self.teacherCard[indexPath.row].status == "1" ? UIImage(systemName: "lock.open.fill") : UIImage(systemName: "lock.fill")
            } else {
                // Fallback on earlier versions
                
            }
            cell.lockingImage.tintColor = self.teacherCard[indexPath.row].status == "1" ? UIColor.green : UIColor.black
        }
            //If a student registered with that teacher no matter to show him the lock images (the all features are already availble to him )
        else {
            cell.teacherCardStackView.isHidden = true
            cell.lockingImage.isHidden = true
        }
        
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
                SCLAlertView().showError("Access denied".localized, subTitle: "Contact with your teacher to get an account or login".localized, closeButtonTitle:"Ok".localized)
            }
        }
        else {
            let selectedRow = indexPath.row
            switch selectedRow {
            case 0:
                if(UserDefaults.standard.string(forKey: "type") != "parent") {
                    if(!isMyTeacher && self.teacherCard[0].status == "0") {
                        SCLAlertView().showError("Access denied".localized, subTitle: "You can't access this content", closeButtonTitle:"Ok".localized)
                    }
                    else {
                        let questionBagVC = storyboard?.instantiateViewController(withIdentifier: "QuestionsBag") as! QuestionsBagViewController
                        questionBagVC.teacherId = self.teacherId
                        questionBagVC.selectedLevel = self.levelId
                        navigationController?.pushViewController(questionBagVC, animated: true)
                    }
                }
                else {
                    SCLAlertView().showError("Access denied".localized, subTitle: "Parents can't access this content", closeButtonTitle:"Ok".localized)
                }
                
            case 1:
                //in case of user other than student or parent uncomment this
                //report
                if(UserDefaults.standard.string(forKey: "type") == "teacher") {
                    let studentReportVC = storyboard?.instantiateViewController(withIdentifier: "SelectStudent") as! SelectStudentViewController
                    studentReportVC.selectedLevel = self.levelId
                    navigationController?.pushViewController(studentReportVC, animated: true)
                }
                else {
                    if(!isMyTeacher && self.teacherCard[1].status == "0") {
                        SCLAlertView().showError("Access denied".localized, subTitle: "You can't access this content", closeButtonTitle:"Ok".localized)
                    }
                    else {
                        let studentReportVC = storyboard?.instantiateViewController(withIdentifier: "StudentReport") as! StudentReportViewController
                        studentReportVC.teacherId = self.teacherId
                        navigationController?.pushViewController(studentReportVC, animated: true)
                    }
                }
            case 2:
                if(!isMyTeacher && self.teacherCard[2].status == "0") {
                    SCLAlertView().showError("Access denied".localized, subTitle: "You can't access this content", closeButtonTitle:"Ok".localized)
                }
                else {
                    let timetableVC = storyboard?.instantiateViewController(withIdentifier: "Timetable") as! TimetableViewController
                    timetableVC.teacherId = self.teacherId
                    timetableVC.teacherSelectedLevel = self.levelId
                    navigationController?.pushViewController(timetableVC, animated: true)
                }
            case 3:
                //ask us block
                if(UserDefaults.standard.string(forKey: "type") == "teacher") {
                    let askUsVC = storyboard?.instantiateViewController(withIdentifier: "AskUs") as! StudentsQuestionsViewController
                    askUsVC.selectedLevel = self.levelId
                    navigationController?.pushViewController(askUsVC, animated: true)
                    
                }
                else {
                    if(UserDefaults.standard.string(forKey: "type") == "student") {
                        if(!isMyTeacher && self.teacherCard[3].status == "0") {
                            SCLAlertView().showError("Access denied".localized, subTitle: "You can't access this content", closeButtonTitle:"Ok".localized)
                        }
                        else {
                            let askTeacherVC = storyboard?.instantiateViewController(withIdentifier: "AskTeacher") as! AskTeacherViewController
                            askTeacherVC.teacherId = self.teacherId
                            navigationController?.pushViewController(askTeacherVC, animated: true)
                        }
                    }
                    else {
                        SCLAlertView().showError("Access denied".localized, subTitle: "Parents can't access this content", closeButtonTitle:"Ok".localized)
                    }
                }
            case 4:
                //pdfs block
                if(UserDefaults.standard.string(forKey: "type") != "parent") {
                    if(UserDefaults.standard.string(forKey: "type") == "student") {
                        if(!isMyTeacher && self.teacherCard[4].status == "0") {
                            SCLAlertView().showError("Access denied".localized, subTitle: "You can't access this content", closeButtonTitle:"Ok".localized)
                        }
                        else {
                            let uploadedPDFVC = storyboard?.instantiateViewController(withIdentifier: "AvailableTypes") as! AvailableTypesViewController
                            uploadedPDFVC.isPdf = true
                            uploadedPDFVC.teacherId = self.teacherId
                            uploadedPDFVC.selectedLevel = self.levelId
                            navigationController?.pushViewController(uploadedPDFVC, animated: true)
                        }
                    }
                    else {
                        //If Teacher
                        let uploadedPDFVC = storyboard?.instantiateViewController(withIdentifier: "AvailableTypes") as! AvailableTypesViewController
                        uploadedPDFVC.isPdf = true
                        uploadedPDFVC.teacherId = self.teacherId
                        uploadedPDFVC.selectedLevel = self.levelId
                        navigationController?.pushViewController(uploadedPDFVC, animated: true)
                    }
                }
                else {
                    SCLAlertView().showError("Access denied".localized, subTitle: "Parents can't access this content", closeButtonTitle:"Ok".localized)
                }
                
            case 5:
                if(UserDefaults.standard.string(forKey: "type") == "student") {
                    if(!isMyTeacher && self.teacherCard[5].status == "0") {
                        SCLAlertView().showError("Access denied".localized, subTitle: "You can't access this content", closeButtonTitle:"Ok".localized)
                    }
                    else {
                        let cvTeacherVC =  storyboard?.instantiateViewController(withIdentifier: "CvTeacher") as! CvTeacherViewController
                        cvTeacherVC.teacherId = self.teacherId
                        navigationController?.pushViewController(cvTeacherVC, animated: true)
                    }
                }
                else {
                    let cvTeacherVC =  storyboard?.instantiateViewController(withIdentifier: "CvTeacher") as! CvTeacherViewController
                    cvTeacherVC.teacherId = self.teacherId
                    navigationController?.pushViewController(cvTeacherVC, animated: true)
                }
            case 6:
                if(UserDefaults.standard.string(forKey: "type") == "student") {
                    if(!isMyTeacher && self.teacherCard[6].status == "0") {
                        SCLAlertView().showError("Access denied".localized, subTitle: "You can't access this content", closeButtonTitle:"Ok".localized)
                    }
                    else {
                        let contactUsVc =  storyboard?.instantiateViewController(withIdentifier: "ContactUs") as! ContactUsViewController
                        contactUsVc.teacherId = self.teacherId
                        navigationController?.pushViewController(contactUsVc, animated: true)
                    }
                }
                else {
                    let contactUsVc =  storyboard?.instantiateViewController(withIdentifier: "ContactUs") as! ContactUsViewController
                    contactUsVc.teacherId = self.teacherId
                    navigationController?.pushViewController(contactUsVc, animated: true)
                }
            case 7:
                if(UserDefaults.standard.string(forKey: "type") != "parent") {
                    if(!isMyTeacher && self.teacherCard[7].status == "0") {
                        SCLAlertView().showError("Access denied".localized, subTitle: "You can't access this content", closeButtonTitle:"Ok".localized)
                    }
                    else {
                        let externalLinksVC = storyboard?.instantiateViewController(withIdentifier: "ExternalLinks") as! ExternalLinksViewController
                        externalLinksVC.teacherId = self.teacherId
                        externalLinksVC.studentLevel = self.levelId
                        navigationController?.pushViewController(externalLinksVC, animated: true)
                    }
                }
                else {
                    SCLAlertView().showError("Access denied".localized, subTitle: "Parents can't access this content", closeButtonTitle:"Ok".localized)
                }
            default:
                return
            }
        }
    }
 }
