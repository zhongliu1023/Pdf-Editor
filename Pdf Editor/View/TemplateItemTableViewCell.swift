//
//  TemplateItemTableViewCell.swift
//  Pdf Editor
//
//  Created by Li Jin on 10/24/16.
//  Copyright © 2016 Li Jin. All rights reserved.
//

import UIKit

class TemplateItemTableViewCell: UITableViewCell {
    weak var item: TemplateItem!
    @IBOutlet weak var imgItem: UIImageView!
    @IBOutlet weak var lblName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func resetWith(item: TemplateItem) {
        self.item = item
        
        lblName.text = item.name
        self.imgItem.image = item.type.image
    }
}
