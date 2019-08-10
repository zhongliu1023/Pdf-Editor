//
//  PdfItem.swift
//  Pdf Editor
//
//  Created by Li Jin on 10/26/16.
//  Copyright © 2016 Li Jin. All rights reserved.
//

import UIKit

public enum PdfItemStatus: Int {
    case inProgress = 0
    case completed = 1
    
    var image: UIImage? {
        switch self {
        case .inProgress:
            return UIImage(named: "icon_sandwatch")
        case .completed:
            return UIImage(named: "icon_checkmark")
        }
    }
}

class PdfItem{
    var name: String!
    var type: TemplateType!
    var status: PdfItemStatus!
    var date: Date!
    var file: String!
    var path: String!
    var customerName: String!
    var formData: String!
    
    init()
    {
        
    }
    
    init(name: String, type: TemplateType, file: String) {
        self.name = name
        self.type = type
        self.file = file
        self.date = Date()
        self.status = .inProgress
        self.path = name + "\(self.date!)" + ".txt"
        self.customerName = "";
    }
    
    func dict() -> [String: Any] {
        var dict = [String: Any] ()
        dict["name"] = name
        dict["file"] = file
        dict["type"] = type.rawValue
        dict["date"] = date.timeIntervalSince1970
        dict["status"] = status.rawValue
        dict["path"] = path
        dict["customerName"] = customerName
        if self.formData != nil {
            dict["formData"] = self.formData
        }
        return dict
    }
    
    class func from(dict: [String: Any]) -> PdfItem {
        let pdf = PdfItem()
        pdf.name = dict["name"] as! String
        pdf.file = dict["file"] as! String
        pdf.type = TemplateType(rawValue: Int(dict["type"] as! String)!)
        pdf.date = Date(timeIntervalSince1970: Double(dict["date"] as! String)!)
        pdf.status = PdfItemStatus(rawValue: Int(dict["status"] as! String)!)
        pdf.path = dict["path"] as! String
        pdf.customerName = (dict["customerName"] ?? "") as! String
        pdf.formData = dict["formData"] as? String
        return pdf
    }
    
    static func ==(lhs: PdfItem, rhs: PdfItem ) -> Bool {
        return lhs.name == rhs.name
    }
    
    static func !=(lhs: PdfItem, rhs: PdfItem ) -> Bool {
        return lhs.name != rhs.name
    }
    
    static func !== (lhs: PdfItem, rhs: PdfItem ) -> Bool {
        return lhs.path != rhs.path
    }
}
