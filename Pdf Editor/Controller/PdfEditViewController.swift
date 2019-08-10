//
//  PdfEditViewController.swift
//  Pdf Editor
//
//  Created by Li Jin on 10/26/16.
//  Copyright © 2016 Li Jin. All rights reserved.
//

import UIKit
import MessageUI

class PdfEditViewController: ILPDFViewController {
    var pdfItem: PdfItem!
    @IBOutlet var btnSave: UIBarButtonItem!
    @IBOutlet weak var btnComplete: UIBarButtonItem!
    var btnShare: UIBarButtonItem!
    
    var signatureField: ILPDFFormSignatureField!
    var loaded: Bool = false
    var completed: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnSave.isEnabled = false
        self.btnComplete.isEnabled = false

        NotificationCenter.default.addObserver(self, selector: #selector(signatureRequested), name: NSNotification.Name(rawValue: "SIGNATURE_REQUESTED"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Manager.sharedInstance.selectedPdf == nil {
            return
        }
        
        if self.pdfItem == nil || self.pdfItem !== Manager.sharedInstance.selectedPdf {
            self.pdfItem = Manager.sharedInstance.selectedPdf
            loaded = false
            
            self.loadPdf()
        }
    }
    
    func loadPdf() {
        if let templateFileUrl = Bundle.main.url(forResource: "Pdf/" + pdfItem.file, withExtension: ".pdf") {
            do {
                let data = try Data(contentsOf: templateFileUrl)
                self.document = ILPDFDocument(data: data)
                self.view.showLoading()
            }
            catch {
                print("Error")
            }
        }
    }
    
    override func didLoad(_ pdfView: ILPDFView) {
        self.view.hideLoading()
        if self.loaded == false {
            self.loadFile()
        }
    }
    
    func loadFile() {
        self.view.showLoading()
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            if self.pdfItem.formData != nil {
                self.document!.load(fromJson: self.pdfItem.formData)
//                self.document!.load(fromXML: self.pdfItem.formData)
            }
            
            DispatchQueue.main.async {
                self.view.hideLoading()
                self.loaded = true
                if self.pdfItem.status == .completed {
                    let data = self.document?.savedStaticPDFData()
                    self.document = ILPDFDocument(data: data!)
                    self.showShare()
                    self.btnComplete.isEnabled = false
                    self.completed = true
                }
                else {
                    if let aircraftModel = self.pdfItem.type.aircraftModel {
                        self.document!.setFormValue(aircraftModel, forFormName: "AircraftModel")
                    }
                    
                    let settings = Settings.sharedInstance
                    if settings.name != nil && settings.name!.length > 0 {
                        self.document!.setFormValue(settings.name!, forFormName: "InstName")
                    }
                    
                    if settings.cfiCertificate != nil && settings.cfiCertificate!.length > 0 {
                        self.document!.setFormValue(settings.cfiCertificate!, forFormName: "InstCert")
                    }
                    
                    self.btnComplete.isEnabled = true
                    self.navigationItem.rightBarButtonItem = self.btnSave
                    self.btnSave.isEnabled = true
                    self.completed = false
                }
                delay(delay: 0.5, closure: {
                    self.document!.documentSaved()
                })
            }
        }
    }
    
    func showShare() {
        self.btnShare = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(PdfEditViewController.onShare))
        self.navigationItem.rightBarButtonItem = self.btnShare
    }
}

extension PdfEditViewController: EPSignatureDelegate { //SIGNATURE_REQUESTED
    func signatureRequested(notification: Notification) {
        if let signatureField = notification.object as? ILPDFFormSignatureField {
            self.signatureField = signatureField
            
            let signatureController = EPSignatureViewController(signatureDelegate: self, showsDate: true, showsSaveSignatureOption: false)
            
            let nav = UINavigationController(rootViewController: signatureController)
            nav.modalPresentationStyle = .formSheet
            nav.preferredContentSize = CGSize(width: self.view.bounds.height/2, height: self.view.bounds.height/2)
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    func epSignature(_: EPSignatureViewController, didSign signatureImage : UIImage, boundingRect: CGRect) {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            let image = signatureImage.crop(rect: boundingRect)
            DispatchQueue.main.async {
                self.signatureField.signatureImage = image
                self.signatureField = nil
            }
        }
    }
    
    func epSignature(_ controller: EPSignatureViewController, didCancel error : NSError) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension PdfEditViewController {
    func exportToPdf()
    {
        let data = self.document?.savedStaticPDFData()
        let savedVCDocument = ILPDFDocument(data: data!)
        self.document = savedVCDocument
    }
    
    func onShare(_ sender: Any) {
        let data = self.document!.documentData as Data
        var name = self.pdfItem.name + ".pdf"
        if self.pdfItem.customerName != nil {
            name = self.pdfItem.customerName + "-" + name
        }
        let activityViewController = UIActivityViewController(activityItems: [name, data], applicationActivities: nil)
        activityViewController.setValue(name, forKey: "subject")
        activityViewController.modalPresentationStyle = .popover
        activityViewController.completionWithItemsHandler = { (type: UIActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            if let error = error {
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                let actionCancel = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alert.addAction(actionCancel)
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        self.present(activityViewController, animated: true, completion: nil)
        if let popover = activityViewController.popoverPresentationController {
            popover.permittedArrowDirections = .any
            popover.barButtonItem = self.btnShare
        }
    }
    
    @IBAction func onComplete(_ sender: Any) {
        let alert : UIAlertController = UIAlertController(title: "Confirm", message: "Are you sure to complete?", preferredStyle: .alert)
        let action = UIAlertAction(title: "Yes", style: .default) { (_ : UIAlertAction) in
            self.view.showLoading()
            DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
                self.pdfItem.status = .completed
                
                if let customerName = self.document?.value(forForm: "CustName"){
                    self.pdfItem.customerName = customerName
                }
                
                self.pdfItem.formData = self.document?.jsonFromPDF()
                Manager.sharedInstance.savePdfItem(pdfItem: self.pdfItem)
                self.document!.documentSaved()

                DispatchQueue.main.async {
                    self.showShare()
                    self.view.hideLoading()
                    self.completed = true
                    let data = self.document?.savedStaticPDFData()
                    self.document = ILPDFDocument(data: data!)
                    let alert : UIAlertController = UIAlertController(title: "Success", message: "Pdf has been successfully completed.", preferredStyle: .alert)
                    let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        alert.addAction(action)
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(actionCancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    func save() {
        self.view.showLoading()
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            if let customerName = self.document?.value(forForm: "CustName"){
                self.pdfItem.customerName = customerName
            }
            
            self.pdfItem.formData = self.document?.jsonFromPDF()
            Manager.sharedInstance.savePdfItem(pdfItem: self.pdfItem)
            
            self.document!.documentSaved()
            
            DispatchQueue.main.async {
                self.view.hideLoading()
                let alert : UIAlertController = UIAlertController(title: "Success", message: "Pdf has been successfully saved.", preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func onSave(_ sender: Any) {
        if self.pdfItem.status == .completed {
//            //Send Email
//            let mailComposeViewController = MFMailComposeViewController()
//            mailComposeViewController.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
////            mailComposeViewController.setToRecipients(["acortes@nova.aero"])
////            mailComposeViewController.setSubject("Hello")
////            mailComposeViewController.setMessageBody("How are you?", isHTML: false)
//            
//            var name = self.pdfItem.name + ".pdf"
//            if self.pdfItem.customerName != nil {
//                name = self.pdfItem.customerName + "-" + name
//            }
//            mailComposeViewController.addAttachmentData(self.document!.documentData as Data, mimeType: "application/pdf", fileName: name)
//            if MFMailComposeViewController.canSendMail() {
//                self.present(mailComposeViewController, animated: true, completion: nil)
//            } else {
//                let alert = UIAlertController(title: "Error", message: "Could not send email", preferredStyle: .alert)
//                let actionCancel = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
//                alert.addAction(actionCancel)
//                self.present(alert, animated: true, completion: nil)
//            }
        }
        else {
            let alert : UIAlertController = UIAlertController(title: "Confirm", message: "Are you sure to save?", preferredStyle: .alert)
            let action = UIAlertAction(title: "Yes", style: .default) { (_ : UIAlertAction) in
                self.save()
            }
            alert.addAction(action)
            let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(actionCancel)
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension PdfEditViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

