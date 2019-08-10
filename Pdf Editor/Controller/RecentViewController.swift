//
//  RecentViewController.swift
//  Pdf Editor
//
//  Created by Li Jin on 10/24/16.
//  Copyright © 2016 Li Jin. All rights reserved.
//

import UIKit

class RecentViewController: UIViewController {
    @IBOutlet weak var tblItems: UITableView!

    var pdfItems = [PdfItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.reload()
    }
    
    func reload() {
        self.pdfItems.removeAll()
        for item in Manager.sharedInstance.pdfs {
            if self.pdfItems.count < 10 {
                if item.type.isRef == false {
                    self.pdfItems.append(item)
                }
            }
            else {
                break
            }
        }
        self.tblItems.reloadData()
    }
    
    @IBAction func onEdit(_ sender: UIButton) {
        if self.tblItems.isEditing {
            self.tblItems.setEditing(false, animated: true)
            sender.setTitle("Edit", for: .normal)
        }
        else {
            self.tblItems.setEditing(true, animated: true)
            sender.setTitle("Done", for: .normal)
        }
    }
}

extension RecentViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.pdfItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PDF_ITEM_CELL") as! PdfItemTableViewCell
        cell.reset(withItem: pdfItems[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constant.Notification.OPENDOCUMENT_REQUESTED), object: pdfItems[indexPath.row], userInfo: nil)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            Manager.sharedInstance.delete(pdf: self.pdfItems[indexPath.row])
            self.pdfItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
