//
//  CloudManager.swift
//  Pdf Editor
//
//  Created by Li Jin on 12/8/16.
//  Copyright © 2016 Li Jin. All rights reserved.
//

import UIKit

class CloudManager {
    static let sharedInstance = CloudManager()

    class func saveFile(filePath: String!) -> Bool {
        do {
            let fileManager = FileManager.default
            var cloudFolderUrl = fileManager.url(forUbiquityContainerIdentifier: nil)
            if cloudFolderUrl == nil {
                print ("iCloud is not working")
                return false
            }
            
            cloudFolderUrl = cloudFolderUrl!.appendingPathComponent("PdfFormData")
            if cloudFolderUrl != nil {
                if fileManager.fileExists(atPath: cloudFolderUrl!.path) == false{
                    try fileManager.createDirectory(at: cloudFolderUrl!, withIntermediateDirectories: true, attributes: nil)
                }
            }
            
            let cloudFileUrl = cloudFolderUrl!.appendingPathComponent(filePath.lastPathComponent)
            if fileManager.fileExists(atPath: cloudFileUrl.path) {
                try fileManager.removeItem(at: cloudFileUrl)
            }
            
            try fileManager.copyItem(atPath: filePath, toPath: cloudFileUrl.path)
        }
        catch {
            print ("Save File To iCloud: " + error.localizedDescription)
        }
        return true
    }
    
    class func loadFiles() {
        do {
            let fileManager = FileManager.default
            if let cloudFolderUrl = fileManager.url(forUbiquityContainerIdentifier: nil) {
                let folderUrl = cloudFolderUrl.appendingPathComponent("PdfFormData")
                let paths = try fileManager.contentsOfDirectory(atPath: folderUrl.path)
                for path in paths {
                    let fileUrl = folderUrl.appendingPathComponent(path)
                    Manager.sharedInstance.loadPdfItem(filePath: fileUrl.path)
                }
            }
        }
        catch {
            print ("Load Files To iCloud: " + error.localizedDescription)
        }
    }
    
    class func deleteFile(filename: String!) -> Bool {
        do {
            let fileManager = FileManager.default
            if let cloudFolderUrl = fileManager.url(forUbiquityContainerIdentifier: nil) {
                let fileUrl = cloudFolderUrl.appendingPathComponent("PdfFormData").appendingPathComponent(filename)
                try fileManager.removeItem(atPath: fileUrl.path)
            }
            else {
                print ("iCloud is not working")
                return false
            }
        }
        catch {
            print ("Error to remove file:" + error.localizedDescription)
        }
        return true
    }
}
