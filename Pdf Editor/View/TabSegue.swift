//
//  TabSegue.swift
//  Pdf Editor
//
//  Created by Li Jin on 10/24/16.
//  Copyright © 2016 Li Jin. All rights reserved.
//

import UIKit

class TabSegue: UIStoryboardSegue {
    override func perform() {
        if self.source is TabViewController {
            let sourceViewController = self.source as! TabViewController
            
            if let currentController = sourceViewController.currentController {
                if type(of: currentController) == type(of: self.destination) {
                    if currentController is UINavigationController && self.destination is UINavigationController {
                        if type(of: (currentController as! UINavigationController).topViewController!) == type(of: (self.destination as! UINavigationController).topViewController!) {
                            return
                        }
                    }
                    else {
                        return
                    }
                }
                
                currentController.view.removeFromSuperview()
                currentController.removeFromParentViewController()
            }

            var destination = self.destination
            if let destinationController = sourceViewController.existingController(of: self.destination) {
                destination = destinationController
            }
            
            sourceViewController.addChildViewController(destination)
            sourceViewController.vwContainer.addSubview(destination.view)
            sourceViewController.currentController = destination
            
            destination.view.frame = sourceViewController.vwContainer.bounds
            
            let topConstraint = NSLayoutConstraint(
                item: destination.view,
                attribute: NSLayoutAttribute.top,
                relatedBy: NSLayoutRelation.equal,
                toItem: sourceViewController.vwContainer,
                attribute: NSLayoutAttribute.top,
                multiplier: 1,
                constant: 0)
            
            let leftConstraint = NSLayoutConstraint(
                item: destination.view,
                attribute: NSLayoutAttribute.left,
                relatedBy: NSLayoutRelation.equal,
                toItem: sourceViewController.vwContainer,
                attribute: NSLayoutAttribute.left,
                multiplier: 1,
                constant: 0)
            
            let rightConstraint = NSLayoutConstraint(
                item: destination.view,
                attribute: NSLayoutAttribute.right,
                relatedBy: NSLayoutRelation.equal,
                toItem: sourceViewController.vwContainer,
                attribute: NSLayoutAttribute.right,
                multiplier: 1,
                constant: 0)
            
            let bottomConstraint = NSLayoutConstraint(
                item: destination.view,
                attribute: NSLayoutAttribute.bottom,
                relatedBy: NSLayoutRelation.equal,
                toItem: sourceViewController.vwContainer,
                attribute: NSLayoutAttribute.bottom,
                multiplier: 1,
                constant: 0)
            
            NSLayoutConstraint.activate([topConstraint, leftConstraint, rightConstraint, bottomConstraint])
        }
    }
}
