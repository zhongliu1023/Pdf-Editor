//
//  DatePickerViewController.swift
//  Pdf Editor
//
//  Created by Li Jin on 11/25/16.
//  Copyright © 2016 Li Jin. All rights reserved.
//

import UIKit

@objc protocol DatePickerDelegate {
    func dateSelected(date: Date)
}

class DatePickerViewController: UIViewController {
    var date: Date!
    weak var delegate: DatePickerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.date = Date()
    }

    @IBAction func onDateChanged(_ sender: UIDatePicker) {
        self.date = sender.date
    }
    
    @IBAction func onDone(_ sender: Any) {
        if self.delegate != nil {
            self.delegate.dateSelected(date: self.date)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
