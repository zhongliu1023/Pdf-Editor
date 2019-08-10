//
//  PDF.swift
//  Pdf Editor
//
//  Created by Li Jin on 12/7/16.
//  Copyright © 2016 Li Jin. All rights reserved.
//

import UIKit

class PDFViewController: ReaderViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.rollawayToolbar.tintColor = Constant.UI.TINT_COLOR
        if self.rollawayToolbar.items != nil && self.rollawayToolbar.items!.count > 0 {
            var items = self.rollawayToolbar.items!
            items.remove(at: 0)
            self.rollawayToolbar.setItems(items, animated: false)
        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
}
