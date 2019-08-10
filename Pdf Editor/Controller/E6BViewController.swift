//
//  E6BViewController.swift
//  Pdf Editor
//
//  Created by Li Jin on 10/31/16.
//  Copyright © 2016 Li Jin. All rights reserved.
//

import UIKit

class E6BViewController: UIViewController {
    var fliteController: FliteCalcViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if fliteController == nil {
            self.loadE6B()
        }
    }
    
    func loadE6B() {
        if self.fliteController != nil {
            self.fliteController.view.removeFromSuperview()
            self.fliteController.removeFromParentViewController()
        }
        
        self.fliteController = FliteCalcViewController()
        self.fliteController.view.frame = self.view.bounds
        self.addChildViewController(self.fliteController)
        self.view.addSubview(self.fliteController.view)
        
        let topConstraint = NSLayoutConstraint(
            item: fliteController.view,
            attribute: NSLayoutAttribute.top,
            relatedBy: NSLayoutRelation.equal,
            toItem: self.view,
            attribute: NSLayoutAttribute.top,
            multiplier: 1,
            constant: 0)
        
        let leftConstraint = NSLayoutConstraint(
            item: fliteController.view,
            attribute: NSLayoutAttribute.left,
            relatedBy: NSLayoutRelation.equal,
            toItem: self.view,
            attribute: NSLayoutAttribute.left,
            multiplier: 1,
            constant: 0)
        
        let rightConstraint = NSLayoutConstraint(
            item: fliteController.view,
            attribute: NSLayoutAttribute.right,
            relatedBy: NSLayoutRelation.equal,
            toItem: self.view,
            attribute: NSLayoutAttribute.right,
            multiplier: 1,
            constant: 0)
        
        let bottomConstraint = NSLayoutConstraint(
            item: fliteController.view,
            attribute: NSLayoutAttribute.bottom,
            relatedBy: NSLayoutRelation.equal,
            toItem: self.view,
            attribute: NSLayoutAttribute.bottom,
            multiplier: 1,
            constant: 0)

        NSLayoutConstraint.activate([topConstraint, leftConstraint, rightConstraint, bottomConstraint])
    }
}
