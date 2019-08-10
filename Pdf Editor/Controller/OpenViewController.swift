//
//  OpenViewController.swift
//  Pdf Editor
//
//  Created by Li Jin on 10/24/16.
//  Copyright © 2016 Li Jin. All rights reserved.
//

import UIKit

class OpenViewController: UIViewController {
    @IBOutlet weak var tblInProgress: UITableView!
    @IBOutlet weak var tblCompleted: UITableView!

    var pdfCompleted = [PdfItem]()
    var pdfInProgress = [PdfItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.reload()
    }
    
    func reload() {
        self.pdfInProgress.removeAll()
        self.pdfCompleted.removeAll()
        
        for item in Manager.sharedInstance.pdfs {
            if item.status == PdfItemStatus.inProgress{
                if item.type.isRef == false {
                    self.pdfInProgress.append(item)
                }
            }
            else {
                self.pdfCompleted.append(item)
            }
        }
        
        self.tblInProgress.reloadData()
        self.tblCompleted.reloadData()
    }
    
    @IBAction func onEdit(_ sender: AnyObject) {
        if self.tblInProgress.isEditing {
            self.tblInProgress.setEditing(false, animated: true)
            self.tblCompleted.setEditing(false, animated: true)
            sender.setTitle("Edit", for: .normal)
        }
        else {
            self.tblInProgress.setEditing(true, animated: true)
            self.tblCompleted.setEditing(true, animated: true)
            sender.setTitle("Done", for: .normal)
        }
    }
}

extension OpenViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tblInProgress {
            return self.pdfInProgress.count
        }
        else {
            return self.pdfCompleted.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PDF_ITEM_CELL") as! PdfItemTableViewCell
        if tableView == self.tblInProgress {
            cell.reset(withItem: pdfInProgress[indexPath.row])
        }
        else {
            cell.reset(withItem: pdfCompleted[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        var selectedItem: PdfItem!
        if tableView == self.tblInProgress {
            selectedItem = pdfInProgress[indexPath.row]
        }
        else {
            selectedItem = pdfCompleted[indexPath.row]
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constant.Notification.OPENDOCUMENT_REQUESTED), object: selectedItem, userInfo: nil)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            if tableView == self.tblInProgress {
                Manager.sharedInstance.delete(pdf: self.pdfInProgress[indexPath.row])
                self.pdfInProgress.remove(at: indexPath.row)
            }
            else {
                Manager.sharedInstance.delete(pdf: self.pdfCompleted[indexPath.row])
                self.pdfCompleted.remove(at: indexPath.row)
            }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
