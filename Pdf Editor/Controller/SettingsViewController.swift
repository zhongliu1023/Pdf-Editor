//
//  SettingsViewController.swift
//  Pdf Editor
//
//  Created by Li Jin on 10/24/16.
//  Copyright © 2016 Li Jin. All rights reserved.
//

import UIKit
import MessageUI

class SettingsViewController: UIViewController {

    @IBOutlet weak var lblVersion: UILabel!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtCFICertificate: UITextField!
    @IBOutlet weak var btnCertificateExpirationDate: UIButton!
    @IBOutlet weak var btnExpirationDate: UIButton!
    @IBOutlet weak var swLoginEnable: UISwitch!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnRecoveryQuestion: UIButton!
    @IBOutlet weak var lblSecurityQuestion: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var needToBeSaved: Bool = false
    
    var expirationDate: Date!
    var certificateExpirationDate: Date!
    
    var currentDateButton: UIButton!
    var recoveryQuestion: [String: String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadFromSettings()
    }
    
    func loadFromSettings() {
        let settings = Settings.sharedInstance
        
        if let value = settings.name {
            self.txtName.text = value
        }
        if let value = settings.email {
            self.txtEmail.text = value
        }
        if let value = settings.phone {
            self.txtPhone.text = value
        }
        if let value = settings.cfiCertificate {
            self.txtCFICertificate.text = value
        }
        if let value = settings.isLoginEnabled {
            self.swLoginEnable.isOn = value
        }
        else {
            self.swLoginEnable.isOn = false
        }
        if let value = settings.userName {
            self.txtUserName.text = value
        }
        if let value = settings.password {
            self.txtPassword.text = value
        }
        if let value = settings.certificateExpireDate {
            self.certificateExpirationDate = settings.certificateExpireDate
            self.btnCertificateExpirationDate.setTitle(value.dateString, for: .normal)
        }
        if let value = settings.expireDate {
            self.expirationDate = settings.expireDate
            self.btnExpirationDate.setTitle(value.dateString, for: .normal)
        }
        
        if let value = settings.passwordRecoveryQuestion {
            self.recoveryQuestion = value
            self.lblSecurityQuestion.text = value.keys.first
            self.btnRecoveryQuestion.setTitle(value[self.lblSecurityQuestion.text!], for: .normal)
        }
    }
    
    @IBAction func onSendEmail(_ sender: Any) {
        let mailComposeViewController = MFMailComposeViewController()
        mailComposeViewController.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        mailComposeViewController.setToRecipients(["support@csipapp.com"])
        mailComposeViewController.setSubject("CSIP App v1.01 Support inquiry")
        mailComposeViewController.setMessageBody("Please describe your inquiry in as much detail as possible, we will reply to you as soon as possible. Thanks.", isHTML: false)
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Error", message: "Could not send email", preferredStyle: .alert)
            let actionCancel = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(actionCancel)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func onRecoveryQuestion(_ sender: UIButton) {
        self.performSegue(withIdentifier: "sid_securityQuestion", sender: self)
    }
    
    func checkIfChanged() {
        needToBeSaved = false
        let settings = Settings.sharedInstance
        
        if settings.name == nil {
            if txtName.text!.length > 0 {
                needToBeSaved = true
                return
            }
        }
        else {
            if settings.name! != txtName.text {
                needToBeSaved = true
                return
            }
        }
        
        if settings.email == nil {
            if txtEmail.text!.length > 0 {
                needToBeSaved = true
                return
            }
        }
        else {
            if settings.email! != txtEmail.text {
                needToBeSaved = true
                return
            }
        }
        
        if settings.phone == nil {
            if txtPhone.text!.length > 0 {
                needToBeSaved = true
                return
            }
        }
        else {
            if settings.phone! != txtPhone.text {
                needToBeSaved = true
                return
            }
        }
        
        if settings.cfiCertificate == nil {
            if txtCFICertificate.text!.length > 0 {
                needToBeSaved = true
                return
            }
        }
        else {
            if settings.cfiCertificate! != txtCFICertificate.text {
                needToBeSaved = true
                return
            }
        }
        
        if settings.isLoginEnabled == nil {
            if swLoginEnable.isOn {
                needToBeSaved = true
                return
            }
        }
        else {
            if settings.isLoginEnabled! != swLoginEnable.isOn {
                needToBeSaved = true
                return
            }
        }
        
        if settings.password == nil {
            if txtPassword.text!.length > 0 {
                needToBeSaved = true
                return
            }
        }
        else {
            if settings.password! != txtPassword.text {
                needToBeSaved = true
                return
            }
        }
        
        if self.certificateExpirationDate != nil{
            if settings.certificateExpireDate == nil {
                needToBeSaved = true
                return
            }
            
            if settings.certificateExpireDate!.compare(self.certificateExpirationDate) != .orderedSame {
                needToBeSaved = true
                return
            }
        }
        
        if self.expirationDate != nil{
            if settings.expireDate == nil {
                needToBeSaved = true
                return
            }
            
            if settings.expireDate!.compare(self.expirationDate) != .orderedSame {
                needToBeSaved = true
                return
            }
        }
        
        if recoveryQuestion != nil {
            if settings.passwordRecoveryQuestion == nil {
                needToBeSaved = true
                return
            }
        }
    }
    
    @IBAction func onSave(_ sender: UIBarButtonItem) {
        guard txtName.text!.characters.count > 0, txtEmail.text!.characters.count > 0, txtPhone.text!.characters.count > 0 else {
            self.showError(text: "In order for your profile to be saved, you need to complete all required fields.")
            return
        }
        
        if swLoginEnable.isOn {
            guard txtUserName.text!.characters.count > 0, txtPassword.text!.characters.count > 7 else {
                self.showError(text: "Login has been enabled, please enter your Username and Password.")
                return
            }
            
            guard recoveryQuestion != nil else {
                self.showError(text: "Please enter a security question to be able to recover your password.")
                return
            }
        }
        
        let settings = Settings.sharedInstance
        settings.name = txtName.text
        settings.email = txtEmail.text
        settings.phone = txtPhone.text
        settings.cfiCertificate = txtCFICertificate.text
        settings.isLoginEnabled = swLoginEnable.isOn
        settings.userName = txtUserName.text
        settings.password = txtPassword.text
        if self.certificateExpirationDate != nil {
            settings.certificateExpireDate = self.certificateExpirationDate
        }
        
        if self.expirationDate != nil {
            settings.expireDate = self.expirationDate
        }
        
        if recoveryQuestion != nil {
            settings.passwordRecoveryQuestion = recoveryQuestion
        }
        
        settings.save()
        Manager.sharedInstance.checkExpiration()
        self.showMessage(title: "Success", text: "Your profile has been saved.")
        self.needToBeSaved = false
    }
    
    @IBAction func onShowPassword(_ sender: Any) {
        self.txtPassword.isSecureTextEntry = !self.txtPassword.isSecureTextEntry
    }
}

extension SettingsViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.txtName || textField == self.txtEmail || textField == self.txtPhone || textField == self.txtCFICertificate || textField == self.txtUserName {
            return
        }
        scrollView.setContentOffset(CGPoint(x: 0, y: scrollView.contentOffset.y + 150), animated: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) { // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
        if textField == self.txtName || textField == self.txtEmail || textField == self.txtPhone || textField == self.txtCFICertificate || textField == self.txtUserName {
            return
        }
        scrollView.setContentOffset(CGPoint.zero, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool { // called when 'return' key pressed. return NO to ignore.
        if let nextField = self.view.viewWithTag(textField.tag + 1) {
            if nextField is UITextField {
                textField.resignFirstResponder()
                nextField.becomeFirstResponder()
            }
            else {
                textField.resignFirstResponder()
                scrollView.setContentOffset(CGPoint.zero, animated: true)
            }
        }
        else {
            textField.resignFirstResponder()
            scrollView.setContentOffset(CGPoint.zero, animated: true)
        }
        
        return true;
    }
}

extension SettingsViewController: SecurityQuestionDelegate {
    func securityQuestionReturned(question: String, answer: String) {
        self.recoveryQuestion = [question: answer]
        self.lblSecurityQuestion.text = question
        self.btnRecoveryQuestion.setTitle(answer, for: .normal)
    }
}

extension SettingsViewController { //segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sid_termsOfUse" {
            let webViewController: WebViewController = segue.destination as! WebViewController
            webViewController.filename = "index.html"
        }
        else if segue.identifier == "sid_securityQuestion" {
            let controller: SecurityQuestionViewController = segue.destination as! SecurityQuestionViewController
            controller.delegate = self
        }
        else if segue.identifier == "sid_expirationdate" || segue.identifier == "sid_certificate_expirationdate" {
            self.currentDateButton = sender as? UIButton
            let controller: DatePickerViewController = segue.destination as! DatePickerViewController
            controller.delegate = self
        }
    }
}

extension SettingsViewController: DatePickerDelegate {
    func dateSelected(date: Date) {
        if date.isLessThan(Date()) {
            self.showError(text: "The date has been chosen incorrectly. Please check again")
            return
        }
        
        self.currentDateButton.setTitle(date.dateString, for: .normal)
        if self.currentDateButton == self.btnCertificateExpirationDate {
            self.certificateExpirationDate = date
        }
        else {
            self.expirationDate = date
        }
    }
}

extension SettingsViewController: MFMailComposeViewControllerDelegate{
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}



