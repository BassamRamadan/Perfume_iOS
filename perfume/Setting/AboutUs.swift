//
//  AboutUs.swift
//  perfume
//
//  Created by Bassam Ramadan on 4/25/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import UIKit

class AboutUs: common {
    // MARK:- Outlets
    @IBOutlet weak var content: UILabel!
    var aboutData: AboutUSDataDetails?
    
    // MARK:- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        setupBackButtonWithDismiss()
        getAboutData()
    }
    
    // MARK:- Alamofire
    fileprivate func getAboutData(){
        self.loading()
        let url = "https://services-apps.net/perfumecorner/public/api/aboutus"
        let headers = [
            "Content-Type": "application/json" ,
            "Accept" : "application/json",
        ]
        AlamofireRequests.getMethod(url: url, headers: headers) { (error, success, jsonData) in
            do {
                let decoder = JSONDecoder()
                if error == nil {
                    if success {
                        let dataReceived = try decoder.decode(AboutUS.self, from: jsonData)
                        self.aboutData = dataReceived.data
                        self.content.text = self.aboutData?.content
                    }else{
                        self.present(common.makeAlert(), animated: true, completion: nil)
                    }
                    self.stopAnimating()
                }else{
                    let dataRecived = try decoder.decode(ErrorHandle.self, from: jsonData)
                    self.present(common.makeAlert(message: dataRecived.message ?? ""), animated: true, completion: nil)
                    self.stopAnimating()
                }
            }catch {
                self.present(common.makeAlert(), animated: true, completion: nil)
                self.stopAnimating()
            }
        }
    }
}
