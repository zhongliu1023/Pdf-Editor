//
//  POHViewController.swift
//  Pdf Editor
//
//  Created by Li Jin on 10/31/16.
//  Copyright © 2016 Li Jin. All rights reserved.
//

import UIKit

class REFsViewController: UIViewController {
    var selectedButton: SpringButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if sender is SpringButton {
            let button = sender as! SpringButton
            
            var array = [TemplateItem]()
            if let templates = Manager.sharedInstance.templates(forType: TemplateType(rawValue: button.tag)!) as? [TemplateItem] {
                array.append(contentsOf: templates)
            }
            
            let listController = segue.destination as! ItemListViewController
            var contentSize = listController.preferredContentSize
            contentSize.height = CGFloat(array.count * 60)
            contentSize.width = CGFloat(200)
            listController.preferredContentSize = contentSize
            listController.items = array
            listController.delegate = self
            
            if let popOver = listController.popoverPresentationController, let anchor  = popOver.sourceView , popOver.sourceRect == CGRect()
            {
                popOver.permittedArrowDirections = [.up]
                popOver.sourceRect = anchor.bounds
            }
            self.selectedButton = button
        }
    }
    
    func createNewItem(item: TemplateItem) {
        self.view.showLoading()
        Manager.sharedInstance.createNewDocument(fromTemplate: item, completion: { (pdfItem) in
            self.view.hideLoading()
            if let pdfItem = pdfItem {
                print ("PDF has been created successfully - \(pdfItem.name)")
                
                let position = CGPoint(x: self.selectedButton.center.x + self.selectedButton.superview!.frame.origin.x, y: self.selectedButton.center.y + self.selectedButton.superview!.frame.origin.y)
                let size = CGSize(width: self.selectedButton.bounds.size.width*2, height: self.selectedButton.bounds.size.height*2)
                let imageView = UIImageView(frame: CGRect(origin: CGPoint.zero, size: size))
                imageView.image = self.selectedButton.image(for: UIControlState.normal)
                imageView.center = position
                self.view.addSubview(imageView)
                
                UIView.animate(withDuration: 0.5, animations: {
                    imageView.frame = CGRect(x: 0, y: self.view.bounds.height - 358, width: 0, height: 0)
                }) { (completed) in
                    if completed {
                        imageView.removeFromSuperview()
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constant.Notification.NEWDOCUMENT_CREATED), object: pdfItem, userInfo: nil)
                        self.selectedButton = nil
                    }
                }
            }
        })
    }
    
    @IBAction func onFOMTemplate(_ sender: SpringButton) {
        if let template = Manager.sharedInstance.templates(forType: TemplateType(rawValue: sender.tag)!) as? TemplateItem {
            self.selectedButton = sender
            self.createNewItem(item: template)
        }
    }
}

extension REFsViewController: ItemListViewControllerDelegate {
    func itemSelected(item: TemplateItem) {
        self.createNewItem(item: item)
    }
}
