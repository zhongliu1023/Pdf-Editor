//
//  SecurityQuestionViewController.swift
//  Pdf Editor
//
//  Created by Li Jin on 11/23/16.
//  Copyright © 2016 Li Jin. All rights reserved.
//

import UIKit

protocol SecurityQuestionDelegate {
    func securityQuestionReturned(question: String, answer: String)
}

class SecurityQuestionViewController: UIViewController {
    @IBOutlet weak var tblQuestions: UITableView!

    @IBOutlet weak var txtQuestion: UITextField!
    @IBOutlet weak var txtAnswer: UITextField!
    
    var questions = [String]()
    var delegate: SecurityQuestionDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let settings = Settings.sharedInstance
        if let value = settings.passwordRecoveryQuestion {
            self.txtQuestion.text = value.keys.first
            self.txtAnswer.text = value[self.txtQuestion.text!]
        }
        
        self.txtQuestion.becomeFirstResponder()
        self.updateWithFilter()
    }
    
    @IBAction func onCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onOk(_ sender: Any) {
        guard txtQuestion.text!.characters.count > 0, txtAnswer.text!.characters.count > 0 else {
            showError(text: "Input the data correctly")
            return
        }
        
        if self.delegate != nil {
            self.delegate.securityQuestionReturned(question: txtQuestion.text!, answer: txtAnswer.text!)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func updateWithFilter() {
        self.questions.removeAll()
        if let filter = txtQuestion.text {
            for question in Settings.questions {
                if question.contains(filter) {
                    self.questions.append(question)
                }
            }
        }
        else {
            self.questions.append(contentsOf: Settings.questions)
        }
        self.tblQuestions.reloadData()
    }
}

extension SecurityQuestionViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Settings.questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "QUESTION_CELL")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "QUESTION_CELL")
            cell!.textLabel?.textColor = Constant.UI.TINT_COLOR
        }
        cell?.textLabel?.text = Settings.questions[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.txtQuestion.text = Settings.questions[indexPath.row]
        self.tblQuestions.isHidden = true
    }
}

extension SecurityQuestionViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {// became first responder
        guard textField == self.txtQuestion else {
            return
        }
        self.tblQuestions.isHidden = false
        self.updateWithFilter()
    }

    func textFieldDidEndEditing(_ textField: UITextField) {// may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
        guard textField == self.txtQuestion else {
            return
        }
        self.updateWithFilter()
        self.tblQuestions.isHidden = true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {// return NO to not change text
        guard textField == self.txtQuestion else {
            return true
        }
        
        self.tblQuestions.isHidden = false
        self.updateWithFilter()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {// called when 'return' key pressed. return NO to ignore.
        textField.resignFirstResponder()
        self.tblQuestions.isHidden = true
        return true
    }
}
