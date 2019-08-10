//
//  TabViewController.swift
//  Pdf Editor
//
//  Created by Li Jin on 10/24/16.
//  Copyright © 2016 Li Jin. All rights reserved.
//

import UIKit

class TabViewController: UIViewController {
    var controllers = [UIViewController]()
    var currentController: UIViewController!
    @IBOutlet weak var vwContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func existingController(of viewController: UIViewController) -> UIViewController? {
        for controller in self.controllers {
            if type(of:controller) == type(of: viewController) {
                if controller is UINavigationController && viewController is UINavigationController {
                    if type(of: (controller as! UINavigationController).topViewController!) == type(of: (viewController as! UINavigationController).topViewController!) {
                        return controller
                    }
                }
                else {
                    return controller
                }
            }
        }
        return nil
    }
    
    override func addChildViewController(_ childController: UIViewController) {
        super.addChildViewController(childController)
        if existingController(of: childController) == nil{
            self.controllers.append(childController)
        }        
    }
    
}
