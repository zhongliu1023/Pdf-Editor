//
//  FormTableViewCell.swift
//  Pdf Editor
//
//  Created by Li Jin on 11/24/16.
//  Copyright © 2016 Li Jin. All rights reserved.
//

import UIKit

class FormTableViewCell: UITableViewCell {
    @IBOutlet weak var imgAircraft: UIImageView!
    @IBOutlet weak var lblModelName: UILabel!
    @IBOutlet weak var lblFormName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func reset(with item: WBItem) {
        self.imgAircraft.image = item.aircraftType.image
        self.lblModelName.text = item.aircraftType.name
        self.lblFormName.text = item.name
    }
}
