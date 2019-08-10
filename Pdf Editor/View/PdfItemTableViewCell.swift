//
//  PdfItemTableViewCell.swift
//  Pdf Editor
//
//  Created by Li Jin on 10/26/16.
//  Copyright © 2016 Li Jin. All rights reserved.
//

import UIKit

class PdfItemTableViewCell: UITableViewCell {
    @IBOutlet weak var imgStatus: UIImageView!
    @IBOutlet weak var imgItemType: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    weak var item: PdfItem!
    
    func reset(withItem item: PdfItem) {
        self.item = item
        if item.customerName != nil && item.customerName.length > 0 {
            self.lblTitle.text = item.customerName + " - " + item.name
        }
        else {
            self.lblTitle.text = item.name
        }
        self.lblDate.text = item.date.dateString
        self.imgItemType.image = item.type.image
        self.imgStatus.image = item.status.image
    }
}
