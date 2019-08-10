//
//  Constant.swift
//  Pdf Editor
//
//  Created by Li Jin on 10/24/16.
//  Copyright © 2016 Li Jin. All rights reserved.
//

import UIKit

struct Constant {
    struct UI {
        static func RGB(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
            return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1)
        }
        
        static let TINT_COLOR = RGB(r: 210, g: 71, b: 38)
        static let BUTTON_HIGHLIGHT_COLOR = UIColor.white.withAlphaComponent(0.3)
        static let BUTTON_SELECT_COLOR = TINT_COLOR.withAlphaComponent(0.3)
        static let LABEL_BACKCOLOR = UIColor.white.withAlphaComponent(0.9)
        static let TEXTFIELD_BORDER_COLOR = RGB(r: 189, g: 215, b: 238)
        
        static let ENVELOPE_COLOR = UIColor.darkGray
        static let FUEL_BURN_COLOR = RGB(r: 162, g: 175, b: 189)
        static let TAKEOFF_CG_COLOR = UIColor.cyan//RGB(r: 82, g: 126, b: 185)
        static let LANDING_CG_COLOR = UIColor.green//RGB(r: 88, g: 134, b: 123)
        static let LIMIT_COLOR = RGB(r: 210, g: 71, b: 38)//RGB(r: 82, g: 126, b: 185)
    }
    
    struct Notification {
        static let NEWDOCUMENT_CREATED = "NEWDOCUMENT_CREATED"
        static let NEWDOCUMENT_UPDATED = "NEWDOCUMENT_UPDATED"
        static let OPENDOCUMENT_REQUESTED = "OPENDOCUMENT_REQUESTED"
        static let SHOW_CALC = "SHOW_CALC"
    }
}

extension String {
    var lastPathComponent: String {
        
        get {
            return (self as NSString).lastPathComponent
        }
    }
    var pathExtension: String {
        
        get {
            
            return (self as NSString).pathExtension
        }
    }
    var deletingLastPathComponent: String {
        
        get {
            
            return (self as NSString).deletingLastPathComponent
        }
    }
    var deletingPathExtension: String {
        
        get {
            
            return (self as NSString).deletingPathExtension
        }
    }
    var pathComponents: [String] {
        
        get {
            
            return (self as NSString).pathComponents
        }
    }
    
    func appendingPathComponent(path: String) -> String {
        
        let nsSt = self as NSString
        
        return nsSt.appendingPathComponent(path)
    }
    
    func appendingPathExtension(ext: String) -> String? {
        
        let nsSt = self as NSString  
        
        return nsSt.appendingPathExtension(ext)  
    }  
}

extension Array {
    mutating func removeObject<T>(obj: T) where T : Equatable {
        self = self.filter({$0 as? T != obj})
    }
}

extension UIImage {
    func crop( rect: CGRect) -> UIImage {
        var rect = rect
        rect.origin.x*=self.scale
        rect.origin.y*=self.scale
        rect.size.width*=self.scale
        rect.size.height*=self.scale
        
        let imageRef = self.cgImage!.cropping(to: rect)
        let image = UIImage(cgImage: imageRef!, scale: self.scale, orientation: self.imageOrientation)
        return image
    }
}

extension String {
    
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
    
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
}

extension UIViewController {
    func showError(text: String) {
        let alert = UIAlertController(title: "Error", message: text, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showMessage(title: String, text: String) {
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
