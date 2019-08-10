//
//  Manager.swift
//  Pdf Editor
//
//  Created by Li Jin on 10/24/16.
//  Copyright © 2016 Li Jin. All rights reserved.
//

import UIKit
import UserNotifications

public enum AircraftType: Int {
    case SR20_G1_G2 = 1
    case SR20_G3 = 2
    case SR22_G1_G2 = 3
    case SR22_G3 = 4
    case SR22_G5 = 5
    case SR22T_G3 = 6
    case SR22T_G5 = 7
    
    var name: String? {
        switch self {
        case .SR20_G1_G2:
            return "G1 G2"
        case .SR20_G3:
            return "G3"
        case .SR22_G1_G2:
            return "G1 G2"
        case .SR22_G3:
            return "G3"
        case .SR22_G5:
            return "G5"
        case .SR22T_G3:
            return "G3"
        case .SR22T_G5:
            return "G5"
        }
    }
    
    var image: UIImage? {
        switch self {
        case .SR20_G1_G2:
            return UIImage(named: "type4")
        case .SR20_G3:
            return UIImage(named: "type4")
        case .SR22_G1_G2:
            return UIImage(named: "type1")
        case .SR22_G3:
            return UIImage(named: "type1")
        case .SR22_G5:
            return UIImage(named: "type1")
        case .SR22T_G3:
            return UIImage(named: "type2")
        case .SR22T_G5:
            return UIImage(named: "type2")
        }
    }
}

class Manager {
    static let sharedInstance = Manager()
    var selectedPdf: PdfItem!
    var selectedPohPdf: PdfItem!
    var pdfs = [PdfItem]()
    var badgeNumber = 0
    
    init() {
        checkExpiration()
    }
    
    func checkExpiration() {
        self.badgeNumber = 0
        self.cleanAllNotifications()
        
        let settings = Settings.sharedInstance
        
        var messageForCSIP: String! = nil
        var messageForCFI: String! = nil
        
        if let date = settings.expireDate {
            let days = Date.daysBetween(date1: Date(), date2: date)
            if days <= 30 {
                if days <= 0 {
                    messageForCSIP = "Your CSIP certification has expired."
                }
                else {
                    messageForCSIP = "Your CSIP certification will expire in \(days) day(s)."
                }
               
                self.badgeNumber = badgeNumber + 1
            }
        }
        
        if let date = settings.certificateExpireDate {
            let days = Date.daysBetween(date1: Date(), date2: date)
            if days <= 30 {
                if days <= 0 {
                    messageForCFI = "Your CFI Certificate has expired."
                }
                else {
                    messageForCFI = "Your CFI Certificate will expire in \(days) day(s)."
                }

                self.badgeNumber = badgeNumber + 1
            }
        }
        
        if UIApplication.shared.applicationIconBadgeNumber > self.badgeNumber {
            UIApplication.shared.applicationIconBadgeNumber = self.badgeNumber
        }
        
        if messageForCSIP != nil {
            addLocalNotification(date: Calendar.current.date(bySettingHour: 7, minute: 0, second: 0, of: Date())!,
                                 body: messageForCSIP, identifier: "CSIP Expiration")
        }
        
        if messageForCFI != nil {
            addLocalNotification(date: Calendar.current.date(bySettingHour: 7, minute: 0, second: 0, of: Date())!,
                             body: messageForCFI, identifier: "CFI Expiration")
        }
    }
    
    func addLocalNotification(date: Date, body: String, identifier: String) {
        if #available(iOS 10.0, *) {
            scheduleLocalNotification10(date, body: body, identifier: identifier)
        } else {
            scheduleLocalNotification(fireDate: date, body: body, identifier: identifier)
        }
    }
    
    @available(iOS 10.0, *)
    func scheduleLocalNotification10(_ fireDate: Date, body: String, identifier: String) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                center.removeDeliveredNotifications(withIdentifiers: [identifier])
                let content = UNMutableNotificationContent()
                content.body = body
                content.sound = UNNotificationSound.default()
                content.badge = NSNumber(integerLiteral: self.badgeNumber)
                let dateComponents = (Calendar.current as NSCalendar).components([.hour, .minute], from: fireDate)
                let trigger = UNCalendarNotificationTrigger.init(dateMatching: dateComponents, repeats: true)
                let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                center.add(request)
            }
        }
    }
    
    func scheduleLocalNotification(fireDate: Date, body: String, identifier: String) {
        let app:UIApplication = UIApplication.shared
        for notification in app.scheduledLocalNotifications! {
            if notification.category == identifier {
                app.cancelLocalNotification(notification)
                break;
            }
        }

        let agendaLocalNotification = UILocalNotification()
        agendaLocalNotification.fireDate = fireDate
        agendaLocalNotification.alertBody = body
        agendaLocalNotification.repeatInterval = .day
        agendaLocalNotification.category = identifier
        agendaLocalNotification.applicationIconBadgeNumber = self.badgeNumber

        agendaLocalNotification.soundName = UILocalNotificationDefaultSoundName
        UIApplication.shared.scheduleLocalNotification(agendaLocalNotification)
    }
    
    func cleanAllNotifications() {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().removeAllDeliveredNotifications()
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        } else {
            UIApplication.shared.cancelAllLocalNotifications()
        }
    }

    func templates(forType type: TemplateType) -> Any? {
        if type == .transition22 || type == .transition22T || type == .transition22TN || type == .transition20 {
            var templates = [TemplateItem]()
            templates.append(TemplateItem(name: "Transition Training (VFR)", type: type, file: "Transition Training Binder"))
            templates.append(TemplateItem(name: "Advanced Transition Training (IFR)", type: type, file: "Advanced Transition Training Binder"))
            templates.append(TemplateItem(name: "AirFrame-Powerplant Differences Training", type: type, file: "Airframe-Powerplant Differences Training Binder"))
            return templates
        }
        
        if type == .poh_1 {
            var templates = [TemplateItem]()
            templates.append(TemplateItem(name: "G1 Vacuum 6-Pack", type: type, file: "POH_SR20 POH - Vacuum System (6 Pack)"))
            templates.append(TemplateItem(name: "G2 Avidyne", type: type, file: "POH_SR20 POH - All Electric (6 Pack or Avidyne Entegra)"))
            templates.append(TemplateItem(name: "G3 Perspective", type: type, file: "POH_SR20 POH - Cirrus Perspective"))
            return templates
        }
        else if type == .poh_2 {
            var templates = [TemplateItem]()
            templates.append(TemplateItem(name: "G1, G2 Avidyne", type: type, file: "POH_SR22 POH - Avidyne Entegra or No PFD"))
            templates.append(TemplateItem(name: "G3 Perspective", type: type, file: "POH_SR22 POH - Cirrus Perspective"))
            templates.append(TemplateItem(name: "G5 Perspective", type: type, file: "POH_SR22 G5 POH - Perspective"))
            return templates
        }
        else if type == .poh_3 {
            var templates = [TemplateItem]()
            templates.append(TemplateItem(name: "G3 Perspective", type: type, file: "POH_SR22T G3 POH - Cirrus Perspective"))
            templates.append(TemplateItem(name: "G5 Perspective", type: type, file: "POH_SR22T G5 POH - Cirrus Perspective"))
            return templates
        }
        else if type == .poh_4 {
            var templates = [TemplateItem]()
            templates.append(TemplateItem(name: "G2 Avidyne", type: type, file: "POH_SR22TN POH - Avidyne Entegra"))
            templates.append(TemplateItem(name: "G3 Perspective", type: type, file: "POH_SR22TN POH - Cirrus Perspective"))
            return templates
        }
        
        if type == .transitionCP {
            return TemplateItem(name: "Avionics Differences Training", type: type, file: "Avionics Differences Training Binder")
        }
        else if type == .transitionAVIDYNE {
            return TemplateItem(name: "Avionics Differences Training", type: type, file: "Avionics Differences Training Binder")
        }
        else if type == .recurrentIFR {
            return TemplateItem(name: "IFR Recurrent Training - Schedule A", type: type, file: "IFR Recurrent Training Binder - Schedule A")
        }
        else if type == .recurrentVFR {
            return TemplateItem(name: "VFR Recurrent Training - Schedule B", type: type, file: "VFR Recurrent Training Binder - Schedule B")
        }
        else if type == .recurrentLST {
            return TemplateItem(name: "Landing Standardization Training", type: type, file: "Landing Standardization Syllabus")
        }
        else if type == .recurrentCAPS {
            return TemplateItem(name: "CAPS Training", type: type, file: "CAPS Training Binder")
        }
        else if type == .recurrent90Day {
            return TemplateItem(name: "Recurrent Training - 90 Day", type: type, file: "Recurrent Training Binder - 90 Day")
        }
        else if type == .fom_cirrus {
            return TemplateItem(name: "Instructor FOM - Cirrus Perspective", type: type, file: "Instructor FOM - Cirrus Perspective")
        }
        else if type == .fom_avidyne {
            return TemplateItem(name: "Flight Operations - Avidyne Entegra", type: type, file: "Flight Operations Manual - Avidyne Entegra")
        }
        else if type == .sillaby {
            return TemplateItem(name: "Cirrus Syllabus Suite - CFI Ed", type: type, file: "Cirrus Syllabus Suite - CFI Ed")
        }
        return nil
    }
    
    func setSelectedPdf(pdfItem: PdfItem) -> Bool{
        if self.selectedPdf == nil || self.selectedPdf !== pdfItem {
            self.selectedPdf = pdfItem
            return true
        }
        return false
    }
    
    func setSelectedPoh(pdfItem: PdfItem) -> Bool{
        if self.selectedPohPdf == nil || self.selectedPohPdf !== pdfItem {
            self.selectedPohPdf = pdfItem
            return true
        }
        return false
    }
}

extension Manager { //PDF device management
    func add(pdf: PdfItem) {
        self.pdfs.append(pdf)
        self.savePdfItem(pdfItem: pdf)
    }

    func loadPdfs() {
        self.pdfs.removeAll()
        
        let fileManager = FileManager.default
        do {
            let directoryPath = Manager.applicationDirectory()
            let paths = try fileManager.contentsOfDirectory(atPath: directoryPath)
            for path in paths {
                let filePath = directoryPath.appendingPathComponent(path: path)
                self.loadPdfItem(filePath: filePath)
            }
        }
        catch {
            print ("Load Pdf files: " + error.localizedDescription)
        }
    }
    
    func isExisting(pdfItem: PdfItem) -> Bool {
        for pdf in self.pdfs {
            if pdf.date == pdfItem.date && pdf.name == pdfItem.name{
                return true
            }
        }
        return false
    }
    
    func loadPdfItem(filePath: String) {
        do {
            guard filePath.contains("txt") else {
                return
            }
            
            let content = try String(contentsOfFile: filePath, encoding: .utf8)
            
            if let dict = XMLDictionaryParser.sharedInstance().dictionary(with: content) {
                let pdf = PdfItem.from(dict: dict as! [String : Any])
                if isExisting(pdfItem: pdf) == false{
                    self.pdfs.append(pdf)
                }
            }
        }
        catch {
            print ("Load a Pdf: " + error.localizedDescription)
        }
    }
    
    func savePdfItem(pdfItem: PdfItem) {
        pdfItem.date = Date()
        let dict: NSDictionary = pdfItem.dict() as NSDictionary
        let str = dict.xmlString()
        
        let path = Manager.applicationDirectory().appendingPathComponent(path: pdfItem.path)
        do {
            try str?.write(toFile: path, atomically: true, encoding: .utf8)
//            if CloudManager.saveFile(filePath: path) {
//                print ("Save file to iCloud Successfully")
//            }
//            else {
//                print ("Error Saving file to iCloud")
//            }
        }catch {
            print ("Error to save file:" + error.localizedDescription)
        }
    }
    
    func delete(pdf: PdfItem) {
        for i in (0..<self.pdfs.count).reversed() {
            let pdfItem = self.pdfs[i]
            if pdf.date == pdfItem.date{
                self.pdfs.remove(at: i)
                break
            }
        }
        
        let path = Manager.applicationDirectory().appendingPathComponent(path: pdf.path)
        let fileManager = FileManager.default
        do {
            try fileManager.removeItem(atPath: path)
        }
        catch {
            print ("Error to remove file:" + error.localizedDescription)
        }
//        
//        if CloudManager.deleteFile(filename: pdf.path) {
//            print ("Delete file from iCloud Successfully")
//        }
//        else {
//            print ("Error Deleting a file from iCloud")
//        }
    }
    
    func createNewDocument(fromTemplate template: TemplateItem, completion: ((PdfItem?)->Void)?) {
        let pdf = PdfItem(name: template.name, type: template.type, file: template.file)
        self.add(pdf: pdf)
        if let completion = completion {
            completion(pdf)
        }
    }
    
    class func applicationDirectory() -> String {
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let rightPath = dirPaths[0].appendingPathComponent(path: "pdfs")
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: rightPath) == false {
            try! fileManager.createDirectory(atPath: rightPath, withIntermediateDirectories: true, attributes: nil)
        }
        return rightPath
    }
    
    class func WBDirectory() -> String {
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let rightPath = dirPaths[0].appendingPathComponent(path: "wbitems")
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: rightPath) == false {
            try! fileManager.createDirectory(atPath: rightPath, withIntermediateDirectories: true, attributes: nil)
        }
        return rightPath
    }
}
