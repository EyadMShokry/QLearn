//
//  PDFTypeViewController.swift
//  El-Khateeb
//
//  Created by Eyad Shokry on 9/19/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import UIKit
import SCLAlertView
import TableFlip

class PDFTypeViewController: UIViewController, DismissManager {
    @IBOutlet weak var addNewPdfButton: UIBarButtonItem!
    @IBOutlet weak var pdfFilesTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var selectedCategoryId = ""
    var pdfs: [PdfResult] = []
    let fadeAnimation = TableViewAnimation.Cell.fade(duration: 0.7)
    var teacherId = ""
    var selectedLevel = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if(UserDefaults.standard.string(forKey: "type") != "teacher") {
            addNewPdfButton.isEnabled = false
            addNewPdfButton.tintColor = .clear
            selectedLevel = UserDefaults.standard.string(forKey: "student_level")!
        }
        else {
            teacherId = UserDefaults.standard.string(forKey: "id")!
        }

        // Do any additional setup after loading the view.
        self.view.bringSubviewToFront(activityIndicator)
        
        pdfFilesTableView.dataSource = self
        pdfFilesTableView.delegate = self
        pdfFilesTableView.separatorColor = .clear
        self.pdfFilesTableView?.rowHeight = 70.0
        
        activityIndicator.startAnimating()
        var student: Student
        student = Student()
        
        let parameters = ["category_id" : selectedCategoryId, "teacher_id" : teacherId, "level" : selectedLevel]
        student.getPdfs(parameters: parameters as [String : AnyObject]) {(pdfs, error) in
            if let pdfs = pdfs {
                self.pdfs = pdfs.RESULT
                print("PDFS: \(self.pdfs)")
                self.performUIUpdatesOnMain {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    self.pdfFilesTableView.reloadData()
                    self.pdfFilesTableView.animate(animation: self.fadeAnimation)
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
    
    @IBAction func onClickAddNewPdfButton(_ sender: Any) {        
        let addPdfVC = storyboard?.instantiateViewController(withIdentifier: "AddPdf") as! AddPdfViewController
        addPdfVC.modalPresentationStyle = .popover
        addPdfVC.popoverPresentationController?.delegate = self
        addPdfVC.popoverPresentationController?.permittedArrowDirections = .any
        addPdfVC.popoverPresentationController?.barButtonItem = addNewPdfButton
        addPdfVC.delegate = self
        addPdfVC.selectedCategoryId = self.selectedCategoryId
        
        self.present(addPdfVC, animated: true)
    }
    
    func downloadPdf(cell: PDFTableViewCell) {
        let indexPathTapped = self.pdfFilesTableView.indexPath(for: cell)
        let selectedPdfUrl = URL(string: self.pdfs[(indexPathTapped?.row)!].url)
        
        let appearence = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        let waitAlertViewResponder = SCLAlertView(appearance: appearence).showWait("Wait", subTitle: "Please wait while downloading your file")
        if(selectedPdfUrl != nil) {
            FileDownloader.loadFileAsync(url: selectedPdfUrl!) {(path, error) in
                if let path = path {
                    if path.contains("file exists") {
                        self.performUIUpdatesOnMain {
                            waitAlertViewResponder.close()
                            SCLAlertView().showWarning("Download is canceled".localized, subTitle: "This file already exists".localized)
                        }
                    }
                    else {
                        self.performUIUpdatesOnMain {
                            waitAlertViewResponder.close()
                            SCLAlertView().showSuccess("Success".localized, subTitle:"Pdf is downloaded successfully".localized, closeButtonTitle:"Ok".localized)
                        }
                    }
                }
                else if let error = error {
                    self.performUIUpdatesOnMain {
                        waitAlertViewResponder.close()
                        SCLAlertView().showError("Error".localized, subTitle: "Can't download this file. please check your internet connection or try again later".localized)
                        print(error)
                    }
                }
            }
        }
        else {
            SCLAlertView().showError("Error".localized, subTitle: "Incorrect File link".localized)
        }
      
    }
    
    func popoverDismiss(isExit: Bool) {
        print("popover dismissed")
        activityIndicator.startAnimating()
        var student: Student
        student = Student()
        
        let parameters = ["category_id" : selectedCategoryId, "teacher_id" : teacherId, "level" : selectedLevel]
        student.getPdfs(parameters: parameters as [String : AnyObject]) {(pdfs, error) in
            if let pdfs = pdfs {
                self.pdfs = pdfs.RESULT
                self.performUIUpdatesOnMain {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    self.pdfFilesTableView.reloadData()
                    self.pdfFilesTableView.animate(animation: self.fadeAnimation)
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
    
}


extension PDFTypeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pdfs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pdfCell") as! PDFTableViewCell
        cell.pdfVC = self
        cell.pdfNameLabel.text = pdfs[indexPath.row].title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
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
            let pdf = pdfs[indexPath.row].id
            let idPdfs = ["id":pdf]
            admin.deletePds(parameters: idPdfs as [String : AnyObject]) { (response, error) in
                if let response = response{
                    if response.contains("inserted"){
                        self.performUIUpdatesOnMain {
                            SCLAlertView().showSuccess("Success".localized, subTitle:"PDF Deleted successfully".localized, closeButtonTitle:"Ok".localized)
                            self.pdfFilesTableView.reloadData()
                        }
                    }else{
                        
                        self.performUIUpdatesOnMain {
                            SCLAlertView().showError("Error".localized, subTitle: "Server Error, please contact with applications author".localized, closeButtonTitle:"Ok".localized)
                            
                        }
                    }
                }
            }
            pdfs.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
            
        }
    }
}


extension PDFTypeViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }

//    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
//        return false
//    }
}
