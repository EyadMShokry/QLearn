//
//  StudentReportViewController.swift
//  El-Khateeb
//
//  Created by Eyad Shokry on 9/14/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import UIKit

class StudentReportViewController: UIViewController {
    @IBOutlet weak var studentNameLabel: UILabel!
    @IBOutlet weak var menuCollectionView: UICollectionView!
    @IBOutlet weak var weeksReportTableView: UITableView!
    @IBOutlet weak var monthsReportTableView: UITableView!
    @IBOutlet weak var attendanceReportTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var menuTitles = ["WEEKS GRADES".localized, "MONTHS GRADES".localized, "ATTENDANCE".localized]
    
    var weeksGrades = [WeekGrade]()
    var monthsGrades = [MonthGrade]()
    var attendances = [Attendance]()
    var selectedIndex = 0
    var selectedIndexPath = IndexPath(item: 0, section: 0)
    var indicatorView = UIView()
    let indicatorHeight: CGFloat = 3
    
    let noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
    
    fileprivate func adjustMenuCollectionView() {
        menuCollectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: .centeredVertically)
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction))
        leftSwipe.direction = .left
        self.view.addGestureRecognizer(leftSwipe)
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction))
        rightSwipe.direction = .right
        self.view.addGestureRecognizer(rightSwipe)
        
        indicatorView.backgroundColor = .red
        indicatorView.frame = CGRect(x: menuCollectionView.bounds.minX, y: menuCollectionView.bounds.maxY - indicatorHeight, width: menuCollectionView.bounds.width / CGFloat(menuTitles.count), height: indicatorHeight)
        menuCollectionView.addSubview(indicatorView)
    }
    
    @objc func swipeAction(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .left {
            if selectedIndex < menuTitles.count - 1 {
                selectedIndex += 1
            }
        } else {
            if selectedIndex > 0 {
                selectedIndex -= 1
            }
        }
        selectedIndexPath = IndexPath(item: selectedIndex, section: 0)
        menuCollectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: .centeredVertically)
        refreshContent()
    }
    
    func refreshContent() {
        print(selectedIndex)
        if (selectedIndex == 0) {
            monthsReportTableView.isHidden = true
            attendanceReportTableView.isHidden = true
            weeksReportTableView.isHidden = false
        }
        else if (selectedIndex == 1) {
            weeksReportTableView.isHidden = true
            attendanceReportTableView.isHidden = true
            monthsReportTableView.isHidden = false
        }
        else if (selectedIndex == 2) {
            weeksReportTableView.isHidden = true
            monthsReportTableView.isHidden = true
            attendanceReportTableView.isHidden = false
        }
        
        let desiredX = (menuCollectionView.bounds.width / CGFloat(menuTitles.count)) * CGFloat(selectedIndex)
        UIView.animate(withDuration: 0.3) {
            self.indicatorView.frame = CGRect(x: desiredX, y: self.menuCollectionView.bounds.maxY - self.indicatorHeight, width: self.menuCollectionView.bounds.width / CGFloat(self.menuTitles.count), height: self.indicatorHeight)
        }
    }
    
    fileprivate func addNoDataLabel() {
        self.noDataLabel.center = self.view.center
        self.noDataLabel.textAlignment = .center
        self.noDataLabel.text = "No Data to show yet.".localized
        self.noDataLabel.textColor = .gray
        self.noDataLabel.font = noDataLabel.font.withSize(20)
        self.view.addSubview(noDataLabel)
    }
    
    private func showNoDataLabel() {
        self.noDataLabel.isHidden = false
    }
    
    private func hideNoDataLabel() {
        self.noDataLabel.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.adjustMenuCollectionView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        menuCollectionView.dataSource = self
        menuCollectionView.delegate = self
        
        activityIndicator.isHidden = true
        self.weeksReportTableView.rowHeight = 75
        self.monthsReportTableView.rowHeight = 75
        self.attendanceReportTableView.rowHeight = 75

        weeksReportTableView.dataSource = self
        weeksReportTableView.delegate = self
        monthsReportTableView.dataSource = self
        monthsReportTableView.delegate = self
        attendanceReportTableView.dataSource = self
        attendanceReportTableView.delegate = self
        
        monthsReportTableView.isHidden = true
        attendanceReportTableView.isHidden = true
        
        weeksReportTableView.separatorColor = .clear
        monthsReportTableView.separatorColor = .clear
        attendanceReportTableView.separatorColor = .clear
        
        //to be deleted after calling APIs
        weeksGrades.append(WeekGrade(weekNumber: "1", grade: "10", date: "10/10"))
        weeksGrades.append(WeekGrade(weekNumber: "2", grade: "10", date: "10/10"))
        weeksGrades.append(WeekGrade(weekNumber: "3", grade: "10", date: "10/10"))
        weeksGrades.append(WeekGrade(weekNumber: "4", grade: "10", date: "10/10/2018"))

        monthsGrades.append(MonthGrade(monthNumber: "1", grade: "20"))
        monthsGrades.append(MonthGrade(monthNumber: "3", grade: "20"))
        monthsGrades.append(MonthGrade(monthNumber: "4", grade: "20"))
        monthsGrades.append(MonthGrade(monthNumber: "6", grade: "20"))
        
        attendances.append(Attendance(weekNumber: "1", status: true, date: "10/12/2019"))
        attendances.append(Attendance(weekNumber: "1", status: false, date: "10/12/2019"))
        attendances.append(Attendance(weekNumber: "1", status: true, date: "10/12/2019"))
        attendances.append(Attendance(weekNumber: "1", status: true, date: "10/12/2019"))

        
    }
    

 

}


extension StudentReportViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuCell", for: indexPath) as! MenuCollectionViewCell
        cell.setupCell(text: menuTitles[indexPath.item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width / CGFloat(menuTitles.count), height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.item
        refreshContent()
    }

}


extension StudentReportViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == weeksReportTableView) {
            return weeksGrades.count
        }
        else if(tableView == monthsReportTableView) {
            return monthsGrades.count
        }
        else {
            return attendances.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(tableView == weeksReportTableView) {
            let weekCell = tableView.dequeueReusableCell(withIdentifier: "WeekGrades") as! WeekGradesTableViewCell
            weekCell.gradeLabel.text = weeksGrades[indexPath.row].grade
            weekCell.weekNumberLabel.text = weeksGrades[indexPath.row].weekNumber
            weekCell.dateLabel.text = weeksGrades[indexPath.row].date
            
            return weekCell
        }
        else if(tableView == monthsReportTableView) {
            let monthCell = tableView.dequeueReusableCell(withIdentifier: "MonthGrades") as! MonthGradesTableViewCell
            monthCell.gradeLabel.text = monthsGrades[indexPath.row].grade
            monthCell.monthNumberLabel.text = monthsGrades[indexPath.row].monthNumber
            
            return monthCell
        }
        else {
            let attendanceCell = tableView.dequeueReusableCell(withIdentifier: "Attendance") as! AttendanceTableViewCell
            attendanceCell.dateLabel.text = attendances[indexPath.row].date
            attendanceCell.statusLabel.text = attendances[indexPath.row].status ?"Attend".localized: "Not Attended".localized
            
            return attendanceCell
        }
    }

}
