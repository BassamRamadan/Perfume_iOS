//
//  Policy.swift
//  perfume
//
//  Created by Bassam Ramadan on 4/25/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import UIKit

class Policy: common {
    // MARK:- Outlets
    @IBOutlet weak var content: UILabel!
    var policy: AboutUSDataDetails?
    
    // MARK:- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "سياسة الأستخدام"
        setupBackButtonWithDismiss()
        getPolicy()
    }
    
    // MARK:- Alamofire
    fileprivate func getPolicy() {
        self.loading()
        let url = "https://services-apps.net/perfumecorner/public/api/policies"
        let headers = [
            "Content-Type": "application/json",
            "Accept": "application/json",
        ]
        AlamofireRequests.getMethod(url: url, headers: headers) { error, success, jsonData in
            do {
                let decoder = JSONDecoder()
                if error == nil {
                    if success {
                        let dataReceived = try decoder.decode(AboutUS.self, from: jsonData)
                        self.policy = dataReceived.data
                        self.content.text = self.policy?.content
                    } else {
                        let dataReceived = try decoder.decode(ErrorHandle.self, from: jsonData)
                        let alert = common.makeAlert(message: dataReceived.message ?? "")
                        self.present(alert, animated: true, completion: nil)
                    }
                    self.stopAnimating()
                }else{
                    let dataRecived = try decoder.decode(ErrorHandle.self, from: jsonData)
                    self.present(common.makeAlert(message: dataRecived.message ?? ""), animated: true, completion: nil)
                    self.stopAnimating()
                }
            } catch {
                let alert = common.makeAlert()
                self.present(alert, animated: true, completion: nil)
                self.stopAnimating()
            }
        }
    }
}
