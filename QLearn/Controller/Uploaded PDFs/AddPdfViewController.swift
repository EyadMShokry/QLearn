//
//  AddPdfViewController.swift
//  El-Khateeb
//
//  Created by Eyad Shokry on 9/24/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import UIKit
import SCLAlertView
import FirebaseStorage

class AddPdfViewController: UIViewController {
    @IBOutlet weak var fileNameTextField: UITextField!
    @IBOutlet weak var addPdfButton: UIButton!
    @IBOutlet weak var uploadButton: UIButton!
    
    var selectedFileUrl: URL!
    let storage = Storage.storage()
    var waitAlertViewResponder: SCLAlertViewResponder!
    var selectedCategoryId = ""
    var delegate: DismissManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func onClickChoosePdfButton(_ sender: Any) {
        let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.text", "com.apple.iwork.pages.pages", "public.data"], in: .import)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true, completion: nil)
    }
    
    @IBAction func onClickUploadButton(_ sender: Any) {
        if(selectedFileUrl == nil || fileNameTextField.text!.isEmpty) {
            SCLAlertView().showError("Error".localized, subTitle:"Some field is empty".localized, closeButtonTitle:"Ok".localized)
        }
        else {
            self.fileNameTextField.isEnabled = false
            self.uploadButton.isEnabled = false
            self.addPdfButton.isEnabled = false
            let storageReference = storage.reference()
            let pdfRef = storageReference.child("docs/\(fileNameTextField.text!)")
            let uploadTask = pdfRef.putFile(from: selectedFileUrl, metadata: nil)
            
            let appearence = SCLAlertView.SCLAppearance(
                showCloseButton: false
            )
            let waitAlertView = SCLAlertView(appearance: appearence)
            waitAlertView.addButton("Cancel uploading".localized) {
                print("Cancel")
                uploadTask.cancel()
                self.waitAlertViewResponder.close()
            }
            
            self.waitAlertViewResponder = waitAlertView.showWait("Uploading...".localized, subTitle: "")

            uploadTask.observe(.progress) { (snapshot) in
                let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
                self.performUIUpdatesOnMain {                self.waitAlertViewResponder.setSubTitle("\(round(percentComplete*100)/100)% is uploaded")
                }
                print(percentComplete)
            }
            uploadTask.observe(.success) { (snapshot) in
                self.performUIUpdatesOnMain {
                    self.waitAlertViewResponder.close()
                }
                let fileUrl = snapshot.metadata?.downloadURL()
                print("File url on firebase: \(fileUrl!)")
                let parameters = ["url" : "\(fileUrl!)",
                                  "title" : self.fileNameTextField.text!,
                                  "category_id" : self.selectedCategoryId]
                let admin = Admin()
                admin.insertPdf(parameters: parameters as [String : AnyObject], completion: { (response, error) in
                    if let response = response {
                        if response.contains("inserted") {
                            self.performUIUpdatesOnMain {
                                SCLAlertView().showSuccess("Success".localized, subTitle: "Pdf file is uploaded successfully", closeButtonTitle:"Ok".localized)
                                
                                self.delegate?.popoverDismiss(isExit: true)
                                self.dismiss(animated: true, completion: nil)
                            }
                        }
                        else {
                            self.performUIUpdatesOnMain {
                                SCLAlertView().showError("Error".localized, subTitle: "Server Error, please contact with applications author".localized, closeButtonTitle:"Ok".localized)
                            }
                        }
                    }
                    else if let error = error {
                        self.performUIUpdatesOnMain {
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
                        self.performUIUpdatesOnMain {
                            self.fileNameTextField.isEnabled = true
                            self.uploadButton.isEnabled = true
                            self.addPdfButton.isEnabled = true
                        }
                    }
                })
            }
            uploadTask.observe(.failure) { (snapshot) in
                if let error = snapshot.error as NSError? {
                    switch (StorageErrorCode(rawValue: error.code)!) {
                    case .objectNotFound:
                        self.performUIUpdatesOnMain {
                            SCLAlertView().showError("Can't upload the file".localized, subTitle:"file doesn't exists".localized, closeButtonTitle:"Ok".localized)
                        }
                    case .unauthorized:
                        self.performUIUpdatesOnMain {
                            SCLAlertView().showError("Can't upload the file".localized, subTitle:"User doesn't have permission to access this file".localized, closeButtonTitle:"Ok".localized)
                        }
                    case .unknown:
                        self.performUIUpdatesOnMain {
                            SCLAlertView().showError("Can't upload the file".localized, subTitle:"Unknown error occured".localized, closeButtonTitle:"Ok".localized)
                        }
                    case .cancelled:
                        self.performUIUpdatesOnMain {
                            self.dismiss(animated: true, completion: nil)
                            return
                        }
                    default:
                        self.performUIUpdatesOnMain {
                            SCLAlertView().showError("Error".localized, subTitle: "An error happined while uploading your file. please check your internet connection or contact with application author".localized, closeButtonTitle:"Ok".localized)
                        }
                    }
                }
            }
        }
    }
    
}


extension AddPdfViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let fileUrl = urls.first else {
            return
        }
        print("import result: \(fileUrl)")
        self.selectedFileUrl = fileUrl
    }
    
}
