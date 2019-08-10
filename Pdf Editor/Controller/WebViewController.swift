//
//  WebViewController.swift
//  Pdf Editor
//
//  Created by Li Jin on 11/22/16.
//  Copyright © 2016 Li Jin. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    var filename: String!
    var url: URL!
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.filename != nil{
            if let path = Bundle.main.path(forResource: filename.deletingPathExtension, ofType: filename.pathExtension) {
//                let str = try! String(contentsOfFile: path, encoding: .utf8)
//                self.view.showLoading()
//                self.webView.loadHTMLString(str, baseURL: nil)
                if let fileUrl = URL(string: path) {
                    self.loadURL(fileUrl: fileUrl)
                }
            }
        }
        else if self.url != nil {
            self.loadURL(fileUrl: self.url)
        }
        
    }
    
    func loadURL(fileUrl: URL) {
        let urlRequest = URLRequest(url: fileUrl)
        self.webView.loadRequest(urlRequest)
        self.view.showLoading()
    }
    
    @IBAction func onClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension WebViewController: UIWebViewDelegate {
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.view.hideLoading()
    }
}
