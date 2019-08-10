//
//  PDFReaderViewController.swift
//  Pdf Editor
//
//  Created by Li Jin on 11/22/16.
//  Copyright © 2016 Li Jin. All rights reserved.
//

import UIKit

class PDFReaderViewController: UIViewController {
    var pdfItem: PdfItem!
    var readerController: PDFViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Manager.sharedInstance.selectedPohPdf == nil {
            return
        }
        
        if self.pdfItem == nil || self.pdfItem !== Manager.sharedInstance.selectedPohPdf {
            self.pdfItem = Manager.sharedInstance.selectedPohPdf
            self.loadPdf()
        }
    }
    
    func loadPdf() {
        self.title = self.pdfItem.name
        if let templateFileUrl = Bundle.main.url(forResource: "Pdf/" + pdfItem.file, withExtension: ".pdf") {
            if self.readerController != nil {
                self.readerController.view.removeFromSuperview()
                self.readerController.removeFromParentViewController()
            }
            
            let documentManager = MFDocumentManager(fileUrl: templateFileUrl)
            self.readerController = PDFViewController(documentManager: documentManager)
            documentManager?.resourceFolder = templateFileUrl.path
            self.readerController.documentId = pdfItem.name
            
            self.readerController.view.frame = self.view.bounds
            self.addChildViewController(self.readerController)
            self.view.addSubview(self.readerController.view)
            
            let topConstraint = NSLayoutConstraint(
                item: readerController.view,
                attribute: NSLayoutAttribute.top,
                relatedBy: NSLayoutRelation.equal,
                toItem: self.view,
                attribute: NSLayoutAttribute.top,
                multiplier: 1,
                constant: 0)
            
            let leftConstraint = NSLayoutConstraint(
                item: readerController.view,
                attribute: NSLayoutAttribute.left,
                relatedBy: NSLayoutRelation.equal,
                toItem: self.view,
                attribute: NSLayoutAttribute.left,
                multiplier: 1,
                constant: 0)
            
            let rightConstraint = NSLayoutConstraint(
                item: readerController.view,
                attribute: NSLayoutAttribute.right,
                relatedBy: NSLayoutRelation.equal,
                toItem: self.view,
                attribute: NSLayoutAttribute.right,
                multiplier: 1,
                constant: 0)
            
            let bottomConstraint = NSLayoutConstraint(
                item: readerController.view,
                attribute: NSLayoutAttribute.bottom,
                relatedBy: NSLayoutRelation.equal,
                toItem: self.view,
                attribute: NSLayoutAttribute.bottom,
                multiplier: 1,
                constant: 0)
            
            NSLayoutConstraint.activate([topConstraint, leftConstraint, rightConstraint, bottomConstraint])
        }
    }
}
