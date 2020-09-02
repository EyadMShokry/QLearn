//
//  ContactUsViewController.swift
//  El-Khateeb
//
//  Created by Abdalah on 9/15/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import UIKit
import SCLAlertView

class ContactUsViewController: UIViewController {
    @IBOutlet weak var AddressesTableView: UITableView!
//    @IBOutlet weak var NameTeacherLabel: UILabel!
    @IBOutlet weak var PhoneNumberTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var addPhoneNumberButton: UIButton!
    @IBOutlet weak var addAddressButton: UIButton!
    
    var teacherId = ""
    var arrayAddresses: [AddressResult] = []
    var arrayPhoneNum: [PhoneResult] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(UserDefaults.standard.string(forKey: "type") != "admin") {
            addPhoneNumberButton.isHidden = true
            addAddressButton.isHidden = true
        }
        
        var user: User
        user = User()
        self.view.bringSubviewToFront(activityIndicator)
        activityIndicator.startAnimating()
        
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        let parameters = ["teacher_id" : teacherId]
        user.getAddresses(parameters: parameters as [String : AnyObject]) {(addresses, error) in
            if let addresses = addresses {
                self.arrayAddresses = addresses.RESULT
                self.performUIUpdatesOnMain {
                    self.AddressesTableView.reloadData()
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
            self.performUIUpdatesOnMain {
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.enter()
        user.getPhoneNumbers(parameters: parameters as [String : AnyObject]) {(phones, error) in
            if let phones = phones {
                self.arrayPhoneNum = phones.RESULT
                self.performUIUpdatesOnMain {
                    self.PhoneNumberTableView.reloadData()
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
            self.performUIUpdatesOnMain {
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
        
//        self.profilecontact.layer.cornerRadius = self.profilecontact.frame.size.width / 2
//        self.profilecontact.clipsToBounds = true
        self.AddressesTableView?.rowHeight = 40.0
        self.PhoneNumberTableView?.rowHeight = 40.0
        self.AddressesTableView.separatorColor = .clear
        self.PhoneNumberTableView.separatorColor = .clear
    }
    

   
    
    //MARK-> : addPhoneNumbersAction
    
    @IBAction func addPhoneNumbers(_ sender: Any) {
        let appearence = SCLAlertView.SCLAppearance(
            showCloseButton: false, showCircularIcon: true
        )
        let addPhoneNumberAlertView = SCLAlertView(appearance: appearence)
        let phoneNumberTextField = addPhoneNumberAlertView.addTextField("Phone Number".localized)
        phoneNumberTextField.textAlignment = .center
        phoneNumberTextField.keyboardType = .numberPad

        addPhoneNumberAlertView.addButton("Add".localized) {
            if(phoneNumberTextField.text!.isEmpty) {
                SCLAlertView().showError("Error".localized, subTitle:"Some field is empty".localized, closeButtonTitle:"Ok".localized)
            }
            else {
                let parameters = ["phone" : phoneNumberTextField.text]
                let admin = Admin()
                self.arrayPhoneNum.removeAll()
                
                self.activityIndicator.isHidden = false
                self.activityIndicator.startAnimating()
                admin.insertPhone(parameters: parameters as [String : AnyObject]) {(data, error) in
                    if let response = data{
                        if response.contains("inserted"){
                            self.performUIUpdatesOnMain {
                                admin.getPhoneNumbers(parameters: parameters as [String : AnyObject]) {(data, error) in
                                    if let numbers = data {
                                        self.arrayPhoneNum = numbers.RESULT
                                        self.performUIUpdatesOnMain {
                                            self.activityIndicator.stopAnimating()
                                            self.activityIndicator.isHidden = true
                                            SCLAlertView().showSuccess("Success".localized, subTitle:"Phone number is added successfully".localized, closeButtonTitle:"Ok".localized)
                                            self.PhoneNumberTableView.reloadData()
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
                                            self.performUIUpdatesOnMain {
                                                self.activityIndicator.stopAnimating()
                                                self.activityIndicator.isHidden = true
                                            }
                                            print(error)
                                        }
                                    }
                                }
                            }
                        }
                        else{
                            self.performUIUpdatesOnMain {
                                self.activityIndicator.stopAnimating()
                                self.activityIndicator.isHidden = true
                                SCLAlertView().showError("Error".localized, subTitle: "Server Error, please contact with applications author".localized, closeButtonTitle:"Ok".localized)
                            }
                        }
                    }
                }

            }
        }
        addPhoneNumberAlertView.addButton("Cancal".localized) {
            addPhoneNumberAlertView.dismiss(animated: true, completion: nil)

        }
        
        let alertViewIcon = UIImage(named: "phone")
        addPhoneNumberAlertView.showInfo("Phone Number".localized, subTitle: "Add new phone number".localized, circleIconImage: alertViewIcon)

        
    }
  
    //MARK-> : addAddAddressesAction
    @IBAction func AddAddresses(_ sender: Any) {
        
        let appearence = SCLAlertView.SCLAppearance(
            showCloseButton: false, showCircularIcon: true
        )
        let addAddressAlertView = SCLAlertView(appearance: appearence)
        
        let addressTitleTextField = addAddressAlertView.addTextField("Address Title".localized)
        let addressTextField = addAddressAlertView.addTextField("Address".localized)
        addressTextField.textAlignment = .center
        addressTitleTextField.textAlignment = .center
        
        addAddressAlertView.addButton("Add".localized) {
            if(addressTextField.text!.isEmpty || addressTitleTextField.text!.isEmpty) {
                SCLAlertView().showError("Error".localized, subTitle:"Some field is empty".localized, closeButtonTitle:"Ok".localized)
            }
            else {
                let parameters = ["address_title" : addressTitleTextField.text, "address" : addressTextField.text]
                let admin = Admin()
                self.arrayAddresses.removeAll()
                
                self.activityIndicator.isHidden = false
                self.activityIndicator.startAnimating()
                admin.insertAddress(parameters: parameters as [String : AnyObject]) {(data, error) in
                    if let response = data{
                        if response.contains("inserted"){
                            self.performUIUpdatesOnMain {
                                admin.getAddresses(parameters: parameters as [String : AnyObject]) {(data, error) in
                                    if let addresses = data {
                                        self.arrayAddresses = addresses.RESULT
                                        self.performUIUpdatesOnMain {
                                            self.activityIndicator.stopAnimating()
                                            self.activityIndicator.isHidden = true
                                            SCLAlertView().showSuccess("Success".localized, subTitle:"Address is added successfully".localized, closeButtonTitle:"Ok".localized)
                                            self.AddressesTableView.reloadData()
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
                                        self.performUIUpdatesOnMain {
                                            self.activityIndicator.stopAnimating()
                                            self.activityIndicator.isHidden = true
                                        }
                                        print(error)
                                    }
                                }
                            }
                        }
                        else{
                            self.performUIUpdatesOnMain {
                                self.activityIndicator.stopAnimating()
                                self.activityIndicator.isHidden = true
                                SCLAlertView().showError("Error".localized, subTitle: "Server Error, please contact with applications author".localized, closeButtonTitle:"Ok".localized)
                            }
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
                        self.performUIUpdatesOnMain {
                            self.activityIndicator.stopAnimating()
                            self.activityIndicator.isHidden = true
                        }
                        print(error)
                    }
                }
            }
        }
        addAddressAlertView.addButton("Cancal".localized) {
            addAddressAlertView.dismiss(animated: true, completion: nil)

        }
        
        let alertViewIcon = UIImage(named: "LocationGreen")
        addAddressAlertView.showInfo("Address".localized, subTitle: "Add new address".localized, circleIconImage: alertViewIcon)


    }
    
    
    
    // mark->  func inserNewIndexPhoneNumber to add data in row if table

    
    func inserNewIndexPhoneNumber(){
        
        let indexPath = IndexPath(row: arrayPhoneNum.count - 1, section: 0)
        PhoneNumberTableView.insertRows(at: [indexPath], with: .left)
        PhoneNumberTableView.reloadData()
        
    }
    
    // mark->  func inserNewIndexAddresses to add data in row if table

    func inserNewIndexAddresses(){
        
        let indexPath = IndexPath(row: arrayAddresses.count - 1, section: 0)
        AddressesTableView.insertRows(at: [indexPath], with: .left)
        AddressesTableView.reloadData()
        
    }
}






// mark->  extension all tableview data insert
extension ContactUsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == PhoneNumberTableView
        {
            return arrayPhoneNum.count
        }
        else{
            return arrayAddresses.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == PhoneNumberTableView
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "officePhoneNumbersCell") as! OfficePhoneNumbersTableViewCell
            cell.PhoneNumbersLable.text = arrayPhoneNum[indexPath.row].phone
            cell.PhoneNumbersImage.image = UIImage(named: "phone")
            if(UserDefaults.standard.value(forKey: "admin_name") != nil) {
                let holdToEditGestureRecognizer = LongPressGesture(target: self, action: #selector(ContactUsViewController.updatePhoneNumber))
                holdToEditGestureRecognizer.minimumPressDuration = 1.00
                holdToEditGestureRecognizer.title = arrayPhoneNum[indexPath.row].phone
                holdToEditGestureRecognizer.selectedId = arrayPhoneNum[indexPath.row].id
                cell.addGestureRecognizer(holdToEditGestureRecognizer)
            }

            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddressesCell") as! AddressesTableViewCell
            cell.AddressesLable.text = "\(arrayAddresses[indexPath.row].address_title): \(arrayAddresses[indexPath.row].address)"
            cell.AddressesImage.image = UIImage(named: "LocationGreen")
            if(UserDefaults.standard.value(forKey: "admin_name") != nil) {
                let holdToEditGestureRecognizer = LongPressGesture(target: self, action: #selector(ContactUsViewController.updateAddress))
                holdToEditGestureRecognizer.minimumPressDuration = 1.00
                holdToEditGestureRecognizer.title = arrayAddresses[indexPath.row].address
                holdToEditGestureRecognizer.addressTitle = arrayAddresses[indexPath.row].address_title
                holdToEditGestureRecognizer.selectedId = arrayAddresses[indexPath.row].id
                cell.addGestureRecognizer(holdToEditGestureRecognizer)
            }
            
            return cell
        }
        
    }
    
    @objc func updatePhoneNumber(sender: LongPressGesture) {
        if(sender.state == .ended) {
            print("long tap is done")
            let appearence = SCLAlertView.SCLAppearance(
                showCloseButton: false, showCircularIcon: true
            )
            
            let editPhoneAlertView = SCLAlertView(appearance: appearence)
            let phoneTextField = editPhoneAlertView.addTextField(NSLocalizedString("Phone Number", comment: ""))
            phoneTextField.textAlignment = .center
            phoneTextField.text = sender.title
            
            editPhoneAlertView.addButton("Edit".localized) {
                if(phoneTextField.text!.isEmpty) {
                    SCLAlertView().showError("Error".localized, subTitle:"Some field is empty".localized, closeButtonTitle:"Ok".localized)
                }
                else {
                    let admin = Admin()
                    let parameters = ["id" : sender.selectedId,
                                      "phone" : phoneTextField.text!]
                    
                    self.activityIndicator.isHidden = false
                    self.activityIndicator.startAnimating()
                    admin.updatePhoneNumber(parameters: parameters as [String : AnyObject], completion: { (response, error) in
                        if let response = response {
                            if response.contains("inserted") {
                                self.performUIUpdatesOnMain {
                                    SCLAlertView().showSuccess("Success".localized, subTitle: "Phone number edited successfully".localized, closeButtonTitle:"Ok".localized)
                                    
                                    admin.getPhoneNumbers(parameters: parameters as [String : AnyObject]) {(data, error) in
                                        if let numbers = data {
                                            self.arrayPhoneNum = numbers.RESULT
                                            self.performUIUpdatesOnMain {
                                                self.activityIndicator.stopAnimating()
                                                self.activityIndicator.isHidden = true
                                                self.PhoneNumberTableView.reloadData()
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
                                            self.performUIUpdatesOnMain {
                                                self.activityIndicator.stopAnimating()
                                                self.activityIndicator.isHidden = true
                                            }
                                            print(error)
                                        }
                                    }
                                }
                            }
                            else {
                                self.performUIUpdatesOnMain {
                                    SCLAlertView().showError("Error".localized, subTitle: "Server Error, please contact with applications author".localized, closeButtonTitle:"Ok".localized)
                                    self.activityIndicator.stopAnimating()
                                    self.activityIndicator.isHidden = true
                                }
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
                    })
                }
            }
            
            editPhoneAlertView.addButton("Cancal".localized) {
                editPhoneAlertView.dismiss(animated: true, completion: nil)
            }
            
            let alertViewIcon = UIImage(named: "phone")
            editPhoneAlertView.showInfo(
                "Phone numbers".localized, subTitle: "Edit Phone number".localized, circleIconImage: alertViewIcon)
        }
    }
    
    @objc func updateAddress(sender: LongPressGesture) {
        if(sender.state == .ended) {
            print("long tap is done")
            let appearence = SCLAlertView.SCLAppearance(
                showCloseButton: false, showCircularIcon: true
            )
            
            let editAddressAlertView = SCLAlertView(appearance: appearence)
            let addressTitleTextField = editAddressAlertView.addTextField(NSLocalizedString("Address title", comment: ""))
            let addressTextField = editAddressAlertView.addTextField(NSLocalizedString("Address", comment: ""))
            addressTextField.textAlignment = .center
            addressTextField.text = sender.title
            addressTitleTextField.textAlignment = .center
            addressTitleTextField.text = sender.addressTitle
            
            editAddressAlertView.addButton("Edit".localized) {
                if(addressTextField.text!.isEmpty || addressTitleTextField.text!.isEmpty) {
                    SCLAlertView().showError("Error".localized, subTitle:"Some field is empty".localized, closeButtonTitle:"Ok".localized)
                }
                else {
                    let admin = Admin()
                    let parameters = ["id" : sender.selectedId,
                                      "address_title" : addressTitleTextField.text!,
                                      "address" : addressTextField.text!]
                    
                    self.activityIndicator.isHidden = false
                    self.activityIndicator.startAnimating()
                    admin.updateAddress(parameters: parameters as [String : AnyObject], completion: { (response, error) in
                        if let response = response {
                            if response.contains("inserted") {
                                self.performUIUpdatesOnMain {
                                    SCLAlertView().showSuccess("Success".localized, subTitle: "Address edited successfully".localized, closeButtonTitle:"Ok".localized)
                                    
                                    admin.getAddresses(parameters: parameters as [String : AnyObject]) {(data, error) in
                                        if let addresses = data {
                                            self.arrayAddresses = addresses.RESULT
                                            self.performUIUpdatesOnMain {
                                                self.activityIndicator.stopAnimating()
                                                self.activityIndicator.isHidden = true
                                                self.AddressesTableView.reloadData()
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
                                            self.performUIUpdatesOnMain {
                                                self.activityIndicator.stopAnimating()
                                                self.activityIndicator.isHidden = true
                                            }
                                            print(error)
                                        }
                                    }
                                }
                            }
                            else {
                                self.performUIUpdatesOnMain {
                                    SCLAlertView().showError("Error".localized, subTitle: "Server Error, please contact with applications author".localized, closeButtonTitle:"Ok".localized)
                                    self.activityIndicator.stopAnimating()
                                    self.activityIndicator.isHidden = true
                                }
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
                    })
                }
            }
            
            editAddressAlertView.addButton("Cancal".localized) {
            editAddressAlertView.dismiss(animated: true, completion: nil)
            }
            
            let alertViewIcon = UIImage(named: "LocationGreen")
            editAddressAlertView.showInfo(
                "Phone numbers".localized, subTitle: "Edit Phone number".localized, circleIconImage: alertViewIcon)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if(UserDefaults.standard.value(forKey: "admin_name") != nil) {
            return .delete
        }
        else {
            return .none
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if tableView == PhoneNumberTableView{
            if editingStyle == .delete {
                let admin = Admin()
                let phone = arrayPhoneNum[indexPath.row].id
                let deletephone = ["id" : phone]
                admin.deletePhone(parameters: deletephone as [String : AnyObject]) { (response, error) in
                    if let response = response{
                        if response.contains("inserted"){
                            self.performUIUpdatesOnMain {
                                SCLAlertView().showSuccess("Success".localized, subTitle:"Phone Deleted successfully".localized, closeButtonTitle:"Ok".localized)
                                self.PhoneNumberTableView.reloadData()
                            }
                        }
                        else{
                            self.performUIUpdatesOnMain {
                                SCLAlertView().showError("Error".localized, subTitle: "Server Error, please contact with applications author".localized, closeButtonTitle:"Ok".localized)
                                
                            }
                        }
                    }
                }
                arrayPhoneNum.remove(at: indexPath.row)
                tableView.beginUpdates()
                tableView.deleteRows(at: [indexPath], with: .automatic)
                tableView.endUpdates()
            }
        }
        else {
            if editingStyle == .delete {
                let admin = Admin()
                let address = arrayAddresses[indexPath.row].id
                let deleteadress = ["id" : address]
                admin.deleteAddress(parameters: deleteadress as [String : AnyObject]) { (response, error) in
                    if let response = response{
                        if response.contains("inserted"){
                            self.performUIUpdatesOnMain {
                                SCLAlertView().showSuccess("Success".localized, subTitle:"Your Addresse Deleted successfully".localized, closeButtonTitle:"Ok".localized)
                                self.AddressesTableView.reloadData()
                            }
                        }else{
                            self.performUIUpdatesOnMain {
                                SCLAlertView().showError("Error".localized, subTitle: "Server Error, please contact with applications author".localized, closeButtonTitle:"Ok".localized)                         }
                        }
                    }
                }
                arrayAddresses.remove(at: indexPath.row)
                tableView.beginUpdates()
                tableView.deleteRows(at: [indexPath], with: .automatic)
                tableView.endUpdates()
            }
        }
    }
}



