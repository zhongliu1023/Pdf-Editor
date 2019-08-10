//
//  Settings.swift
//  Pdf Editor
//
//  Created by Li Jin on 11/22/16.
//  Copyright © 2016 Li Jin. All rights reserved.
//

import UIKit

class Settings {
    static let sharedInstance = Settings()
    static let questions = ["In what city were you born",
                            "What was your favorite place to visit as a child",
                            "Who is your favorite actor, musician, or artist",
                            "What is the name of your favorite pet",
                            "What high school did you attend",
                            "What is your favorite movie",
                            "What is your mother's maiden name",
                            "What street did you grow up on",
                            "What is your favorite color",
                            "What is the name of your first grade teacher",
                            "Which is your favorite web browser",
                            "When is your anniversary",
                            "What was the make of your first car"]
    
    subscript(key: String) -> Any?{
        get{
            return data[key]
        }
        set (newValue) {
            data[key] = newValue
//            self.save()
        }
    }
    
    var data = [String: Any]()
    
    var name: String? {
        get{
            return self["name"] as? String
        }
        set{
            self["name"] = newValue as Any?
        }
    }
    
    var email: String? {
        get{
            return self["email"] as? String
        }
        set{
            self["email"] = newValue as Any?
        }
    }
    
    var phone: String? {
        get{
            return self["phone"] as? String
        }
        set{
            self["phone"] = newValue as Any?
        }
    }
    
    var cfiCertificate: String? {
        get{
            return self["cfiCertificate"] as? String
        }
        set{
            self["cfiCertificate"] = newValue as Any?
        }
    }
    
    var certificateExpireDate: Date? {
        get{
            return self["certificateExpireDate"] as? Date
        }
        set{
            self["certificateExpireDate"] = newValue as Any?
        }
    }
    
    var expireDate: Date? {
        get{
            return self["expireDate"] as? Date
        }
        set{
            self["expireDate"] = newValue as Any?
        }
    }
    
    var isLoginEnabled: Bool? {
        get{
            return self["isLoginEnabled"] as? Bool
        }
        set{
            self["isLoginEnabled"] = newValue as Any?
        }
    }
    
    var userName: String? {
        get{
            return self["userName"] as? String
        }
        set{
            self["userName"] = newValue as Any?
        }
    }
    
    var password: String? {
        get{
            return self["password"] as? String
        }
        set{
            self["password"] = newValue as Any?
        }
    }
   
    var passwordRecoveryQuestion: [String: String]? {
        get{
            return self["question"] as? [String: String]
        }
        set{
            self["question"] = newValue as Any?
        }
    }
    
    init() {
        self.loadFromDefault()
    }
    
    func loadFromDefault() {
        let userdefault = UserDefaults.standard
        if let dict = userdefault.dictionary(forKey: "settings") {
            self.data = dict
        }
    }
    
    func save() {
        let userdefault = UserDefaults.standard
        userdefault.set(self.data, forKey: "settings")
        userdefault.synchronize()
    }
}
