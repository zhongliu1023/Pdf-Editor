//
//  LoginViewController.swift
//  Pdf Editor
//
//  Created by Li Jin on 11/22/16.
//  Copyright © 2016 Li Jin. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var vwLogin: SpringView!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    
    @IBOutlet weak var vwSecurityQuestion: UIView!
    @IBOutlet weak var lblSecurityQuestion: UILabel!
    @IBOutlet weak var txtAnswer: UITextField!

    var secureQuestion: [String: String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.vwLogin.layer.cornerRadius = 5
        self.vwSecurityQuestion.layer.cornerRadius = 5
        
        self.loadFromSettings()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.checkExpiredDate()
    }
    
    func loadFromSettings() {
        let settings = Settings.sharedInstance
        if let secureQuestion = settings.passwordRecoveryQuestion {
            self.secureQuestion = secureQuestion
            
            self.lblSecurityQuestion.text = self.secureQuestion.keys[self.secureQuestion.startIndex]
        }
    }
    
    @IBAction func onEye(_ sender: Any) {
        txtPassword.isSecureTextEntry = !txtPassword.isSecureTextEntry
    }
    
    func checkExpiredDate() {
        let settings = Settings.sharedInstance
        
        var message: String = ""
        if let date = settings.expireDate {
            let days = Date.daysBetween(date1: Date(), date2: date)
            if days < 30 {
                if days <= 0 {
                    message = "Your CSIP certification has expired."
                }
                else {
                    message = "Your CSIP certification will expire in \(days) day(s)."
                }
            }
        }
        
        if let date = settings.certificateExpireDate {
            let days = Date.daysBetween(date1: Date(), date2: date)
            if days < 30 {
                if days <= 0 {
                    if message.length > 0 {
                        message = message.replacingOccurrences(of: ".", with: ", ")
                        message = message + "and your CFI Certificate has expired."
                    }
                    else {
                        message = "Your CFI Certificate has expired."
                    }
                }
                else {
                    if message.length > 0 {
                        message = message.replacingOccurrences(of: ".", with: ", ")
                        message = message + "and Your CFI Certificate will expire in \(days) day(s)."
                    }
                    else {
                        message = "Your CFI Certificate will expire in \(days) day(s)."
                    }
                }
            }
        }
        
        if message.length > 0 {
            self.showMessage(title: "Warning", text: message)
        }
    }
    
    @IBAction func onForgotPassword(_ sender: Any) {
        self.vwSecurityQuestion.alpha = 0.0
        UIView.animate(withDuration: 0.3, animations: {
            self.vwSecurityQuestion.alpha = 1.0
        }, completion: nil)
    }
    
    @IBAction func onOk(_ sender: Any) {
        let settings = Settings.sharedInstance
        
        guard settings.userName != nil && settings.password != nil else { return
        }
        
        if txtUserName.text == settings.userName! && txtPassword.text == settings.password! {
            self.success()
        }
        else {
            showError(text: "User name or password is wrong, please check and try again.")
        }
    }

    @IBAction func onAnswerOk(_ sender: Any) {
        guard self.secureQuestion != nil else { return }
        
        if self.txtAnswer.text == self.secureQuestion[self.lblSecurityQuestion.text!] {
            self.success()
        }
        else {
            showError(text: "Answer is wrong, please try again.")
        }
    }
    
    @IBAction func onAnswerCancel(_ sender: Any) {
        self.vwSecurityQuestion.alpha = 0.0
    }
    
    func success() {
        UIView.animate(withDuration: 0.3, animations: {
            self.vwLogin.alpha = 0.0
        }, completion: { (finished) in
            self.dismiss(animated: true, completion: nil)
        })
    }
}


extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == self.txtUserName {
            txtPassword.becomeFirstResponder()
        }
        else if textField == self.txtPassword {
            self.onOk(textField)
        }
        return true;
    }
}

