//
//  WBTableViewCell.swift
//  Pdf Editor
//
//  Created by Li Jin on 11/3/16.
//  Copyright © 2016 Li Jin. All rights reserved.
//

import UIKit

protocol WBTableViewCellDelegate {
    func valueChanged()
    func nextInput(_ currentTextField: UITextField, rowIndex: Int)
}

class WBTableViewCell: UITableViewCell {
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var btnQty: UIButton!
    @IBOutlet weak var txtQty: UITextField!
    @IBOutlet weak var txtWeight: UITextField!
    @IBOutlet weak var txtArm: UITextField!
    @IBOutlet weak var txtMoment: UITextField!
    var index: Int = 0
    var delegate: WBTableViewCellDelegate!
    
    weak var row: WBRow!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func resetWithWBRow(row: WBRow) {
        self.contentView.endEditing(true)

        self.row = row
        if self.row.title == "Basic Empty Weight (from Aircraft POH)" {
            let fontLarge =  [NSFontAttributeName: UIFont.systemFont(ofSize: 14)]
            let fontSmall =  [NSFontAttributeName: UIFont.systemFont(ofSize: 12)]
            let attrString1 = NSAttributedString(string: "Basic Empty Weight", attributes: fontLarge)
            let attrString2 = NSAttributedString(string: "(from Aircraft POH)", attributes: fontSmall)
            let attrString = NSMutableAttributedString(attributedString: attrString1)
            attrString.append(attrString2)
            txtTitle.attributedText = attrString
        }
        else {
            txtTitle.text = self.row.title
        }
        txtTitle.delegate = self
        
        if self.row.title.lowercased() == "takeoff condition" {
            txtTitle.textColor = Constant.UI.TAKEOFF_CG_COLOR
        }
        else if self.row.title.lowercased() == "landing condition" {
            txtTitle.textColor = Constant.UI.LANDING_CG_COLOR
        }
        else {
            txtTitle.textColor = UIColor.black
        }
        
        if row.qtyEditable {
            if row.qty is OxygenQty {
                btnQty.isHidden = false
                btnQty.layer.borderWidth = 1
                btnQty.layer.borderColor = UIColor.black.cgColor
                txtQty.isHidden = true
                btnQty.setTitle((row.qty as! OxygenQty).name, for: .normal)
            }
            else {
                btnQty.isHidden = true
                txtQty.isHidden = false
                txtQty.text = String(format: "%.1f", (row.qty as! Double))
            }
        }
        else {
            btnQty.isHidden = true
            txtQty.isHidden = true
        }
        txtQty.delegate = self
        
        if row.weightEditable {
            self.enableTextField(txtField: txtWeight, enable: true)
        }
        else {
            self.enableTextField(txtField: txtWeight, enable: false)
        }
        
        if row.momentEditable {
            self.enableTextField(txtField: txtMoment, enable: true)
        }
        else {
            self.enableTextField(txtField: txtMoment, enable: false)
        }
        
        txtWeight.delegate = self
        txtArm.delegate = self
        txtMoment.delegate = self
        
        txtWeight.text = String(format: "%.1f", row.weight)
        txtArm.text = String(format: "%.1f", row.arm)
        txtMoment.text = String(format: "%.3f", row.moment)
    }
    
    func enableTextField(txtField: UITextField, enable: Bool) {
        txtField.isEnabled = enable
        if enable == true {
            txtField.backgroundColor = UIColor.lightGray
        }
        else {
            txtField.backgroundColor = UIColor.clear
        }
    }
    
    @IBAction func onOxygenQty(_ sender: UIButton) {
        let oxygenList = OxygenTableViewController(delegate: self)
        oxygenList.preferredContentSize = CGSize(width: 200, height: 174)
        oxygenList.modalPresentationStyle = .popover
        oxygenList.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.down
        oxygenList.popoverPresentationController?.sourceView = sender // button
        oxygenList.popoverPresentationController?.sourceRect = sender.bounds
        
        let parentController = self.delegate as! WBViewController
        parentController.present(oxygenList, animated: true, completion: nil)
    }
}

protocol OxygenTableViewControllerDelegate{
    func oxygenSelected(oxygen: OxygenQty)
}

class OxygenTableViewController: UITableViewController {
    var oxygenDelegate: OxygenTableViewControllerDelegate!
    var oxygenTypes = [OxygenQty.psi1800, OxygenQty.psi1600, OxygenQty.psi1200, OxygenQty.psi800, OxygenQty.psi400, OxygenQty.psi0]
    
    init(delegate: OxygenTableViewControllerDelegate) {
        super.init(style: .plain)
        self.oxygenDelegate = delegate
    }
    
    override init(style: UITableViewStyle) {
        super.init(style: style)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 29
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.oxygenTypes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "OXYGEN_CELL")
        if cell == nil{
            cell = UITableViewCell(style: .default, reuseIdentifier: "OXYGEN_CELL")
        }
        cell!.textLabel?.text = self.oxygenTypes[indexPath.row].name
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.oxygenDelegate != nil {
            self.oxygenDelegate.oxygenSelected(oxygen: self.oxygenTypes[indexPath.row])
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension WBTableViewCell: OxygenTableViewControllerDelegate {
    func oxygenSelected(oxygen: OxygenQty) {
        self.row.setQty(qtyValue: oxygen)
        if self.delegate != nil {
            self.delegate.valueChanged()
        }
    }
}

extension WBTableViewCell: UITextFieldDelegate {
    func updateTextField(textField: UITextField, value: String) {
        if textField == self.txtWeight {
            self.row.setWeight(value: Double(value)!)
        }
        
        if textField == self.txtMoment {
            self.row.setMoment(value: Double(value)!)
        }
        
        if textField == self.txtQty {
            self.row.setQty(qtyValue: Double(value)!)
        }
        
        if self.delegate != nil {
            self.delegate.valueChanged()
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let textFieldText: NSString = (textField.text ?? "") as NSString
        let txtAfterUpdate = textFieldText.replacingCharacters(in: range, with: string)
        
        var value = 0.0
        if txtAfterUpdate.length > 0 && Double(txtAfterUpdate) != nil
        {
            value = Double(txtAfterUpdate)!
        }
        
            
        if textField == self.txtWeight {
            self.row.setWeight(value: value)
        }
        
        if textField == self.txtMoment {
            self.row.setMoment(value: value)
        }
        
        if textField == self.txtQty {
            self.row.setQty(qtyValue: value)
        }
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.updateTextField(textField: textField, value: textField.text!)
        self.delegate.nextInput(textField, rowIndex: self.index)
        return true;
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if Float(textField.text!) == 0 {
            textField.text = ""
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text!.length == 0 {
            textField.text = "0.0"
        }
        
        self.updateTextField(textField: textField, value: textField.text!)
    }
}

