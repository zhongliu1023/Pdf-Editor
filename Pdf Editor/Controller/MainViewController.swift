//
//  MainViewController.swift
//  Pdf Editor
//
//  Created by Li Jin on 10/24/16.
//  Copyright © 2016 Li Jin. All rights reserved.
//

import UIKit
import UserNotifications

class MainViewController: TabViewController {
    @IBOutlet weak var bar: SpringView!
    @IBOutlet weak var btnNew: SpringButton!
    @IBOutlet weak var btnSelectedTemplate: UIButton!
    @IBOutlet weak var btnSelectedRefs: SpringButton!
    var isViewAppeared: Bool = false
    var calcController: CalculatorViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: Constant.Notification.NEWDOCUMENT_CREATED), object: nil, queue: nil) { (notification) in
            if let pdfItem = notification.object as? PdfItem {
                if pdfItem.type.isRef == false {
                    self.loadPdfEditor(for: pdfItem)
                }
                else {
                    self.loadPoh(for: pdfItem)
                }
            }
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: Constant.Notification.OPENDOCUMENT_REQUESTED), object: nil, queue: nil) { (notification) in
            if let pdfItem = notification.object as? PdfItem {
                if pdfItem.type.isRef == false {
                    self.loadPdfEditor(for: pdfItem)
                }
                else {
                    self.loadPoh(for: pdfItem)
                }
            }
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: Constant.Notification.SHOW_CALC), object: nil, queue: nil) { (notification) in
            if self.calcController == nil {
                self.calcController = CalculatorViewController()
                self.addChildViewController(self.calcController)
                self.calcController.view.frame = CGRect(x: 0, y: 0, width: 320, height: 400)
                self.calcController.view.layer.cornerRadius = 10
                self.calcController.view.layer.masksToBounds = true
                
                self.view.addSubview(self.calcController.view)
                
                let topConstraint = NSLayoutConstraint(
                    item: self.calcController.view,
                    attribute: NSLayoutAttribute.top,
                    relatedBy: NSLayoutRelation.equal,
                    toItem: self.view,
                    attribute: NSLayoutAttribute.top,
                    multiplier: 1,
                    constant: 64)
                
                let leftConstraint = NSLayoutConstraint(
                    item: self.calcController.view,
                    attribute: NSLayoutAttribute.left,
                    relatedBy: NSLayoutRelation.equal,
                    toItem: self.view,
                    attribute: NSLayoutAttribute.left,
                    multiplier: 1,
                    constant: 40)
                
                let widthConstraint = NSLayoutConstraint(
                    item: self.calcController.view,
                    attribute: NSLayoutAttribute.width,
                    relatedBy: NSLayoutRelation.equal,
                    toItem: nil,
                    attribute: NSLayoutAttribute.notAnAttribute,
                    multiplier: 1,
                    constant: self.calcController.view.frame.size.width)
                
                let heightConstraint = NSLayoutConstraint(
                    item: self.calcController.view,
                    attribute: NSLayoutAttribute.height,
                    relatedBy: NSLayoutRelation.equal,
                    toItem: nil,
                    attribute: NSLayoutAttribute.notAnAttribute,
                    multiplier: 1,
                    constant: self.calcController.view.frame.size.height)

                self.calcController.view.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([topConstraint, leftConstraint, widthConstraint, heightConstraint])
            }
            else {
                self.calcController.view.isHidden = !self.calcController.view.isHidden
            }
        }
    }
    
    func loadPdfEditor(for item: PdfItem) {
        self.btnSelectedTemplate.setImage(item.type.image!, for: .normal)
        let _ = Manager.sharedInstance.setSelectedPdf(pdfItem: item)
        self.performSegue(withIdentifier: "sid_pdf", sender: self.btnSelectedTemplate)
    }
    
    func loadPoh(for item: PdfItem) {
        self.btnSelectedRefs.setImage(item.type.image!, for: .normal)
        let _ = Manager.sharedInstance.setSelectedPoh(pdfItem: item)
        self.performSegue(withIdentifier: "sid_readpdf", sender: self.btnSelectedRefs)
    }
  
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.performSegue(withIdentifier: "sid_new", sender: btnNew)
        let settings = Settings.sharedInstance
        
        self.isViewAppeared = true
        if let isLoginEnabled = settings.isLoginEnabled {
            if isLoginEnabled == true {
                self.performSegue(withIdentifier: "sid_login", sender: self)
            }
            else {
                self.checkExpiredDate()
            }
        }
        else {
            self.checkExpiredDate()
        }
    }
    
    func checkExpiredDate() {
        guard isViewAppeared else {
            return
        }
        
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
    
    func deHighlightButtons() {
        for subView in self.bar.subviews {
            if subView is SpringButton {
                subView.backgroundColor = UIColor.clear
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue is TabSegue {
            self.deHighlightButtons()
            if sender is SpringButton {
                let button = sender as! SpringButton
                button.backgroundColor = Constant.UI.BUTTON_HIGHLIGHT_COLOR
            }
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if self.currentController is UINavigationController {
            let navController = self.currentController as! UINavigationController
            if navController.viewControllers[0] is SettingsViewController {
                let settingsController = navController.viewControllers[0] as! SettingsViewController
                settingsController.checkIfChanged()
                if settingsController.needToBeSaved {
                    let alert = UIAlertController(title: "Warning", message: "You made a changes to your profile, do you want to save the changes before exiting changes?", preferredStyle: .alert)
                    let action = UIAlertAction(title: "No", style: .default, handler: { (action) in
                        self.performSegue(withIdentifier: identifier, sender: self)
                    })
                    let actionCancel = UIAlertAction(title: "Yes", style: .cancel, handler: { (action) in
                        settingsController.onSave(UIBarButtonItem())
                    })
                    
                    alert.addAction(actionCancel)
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                    return false
                }
            }
            else if navController.viewControllers[0] is PdfEditViewController {
                let pdfController = navController.viewControllers[0] as! PdfEditViewController
                if pdfController.completed {
                    return true
                }
                
                if pdfController.document!.isModified() == false {
                    return true
                }
                
                let alert = UIAlertController(title: "Warning", message: "Do you want to save the changes before exiting changes?", preferredStyle: .alert)
                let action = UIAlertAction(title: "No", style: .default, handler: { (action) in
                    self.performSegue(withIdentifier: identifier, sender: self)
                })
                let actionCancel = UIAlertAction(title: "Yes", style: .cancel, handler: { (action) in
                    pdfController.save()
                    self.performSegue(withIdentifier: identifier, sender: self)
                })
                
                alert.addAction(actionCancel)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                return false
            }
        }
        
        if identifier == "sid_pdf", Manager.sharedInstance.selectedPdf == nil {
            return false
        }
        
        if identifier == "sid_readpdf", Manager.sharedInstance.selectedPohPdf == nil {
            return false
        }
        return true
    }
}

extension MainViewController: UNUserNotificationCenterDelegate {
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Swift.Void) {
        self.checkExpiredDate()
    }
}
