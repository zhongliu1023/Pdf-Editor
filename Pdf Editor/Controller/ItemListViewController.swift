//
//  ItemListViewController.swift
//  Pdf Editor
//
//  Created by Li Jin on 10/24/16.
//  Copyright © 2016 Li Jin. All rights reserved.
//

import UIKit

protocol ItemListViewControllerDelegate {
    func itemSelected(item: TemplateItem)
}

class ItemListViewController: UITableViewController {
    var delegate: ItemListViewControllerDelegate!
    var items = [TemplateItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ITEM_CELL") as! TemplateItemTableViewCell
        cell.resetWith(item: items[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.dismiss(animated: false, completion: nil)
        if self.delegate != nil {
            self.delegate.itemSelected(item: items[indexPath.row])
        }
    }
}
