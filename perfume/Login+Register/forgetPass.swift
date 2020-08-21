//
//  forgetPass.swift
//  perfume
//
//  Created by Bassam Ramadan on 5/16/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import UIKit
class forgetPass: common, UIScrollViewDelegate{
    // MARK:- Outlets
    @IBOutlet var ScrollView : UIScrollView!
    @IBOutlet var BagroundImage : UIImageView!
    
    @IBOutlet var email : UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        email.text = CashedData.getUserEmail() ?? ""
        ScrollView.delegate = self
    }
    // MARK:- Actions
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        BagroundImage.transform = CGAffineTransform(translationX: 0, y: ((ScrollView.contentOffset.y/2)+22) * -1)
    }
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.dismiss(animated: true)
    }
    
     // MARK:- Api
    @IBAction func forgetPass(sender : Any){
        self.loading()
        let url = AppDelegate.LocalUrl + "/forgetPasswordRequest"
        let  info = [
            "email" : email.text ?? ""
        ]
        let headers = [
            "Accept" : "application/json",
            "Content-Type" : "application/json"
        ]
        AlamofireRequests.PostMethod(methodType: "POST", url: url, info: info, headers: headers){
            (error, success , jsonData) in
            do {
                let decoder = JSONDecoder()
                if error == nil{
                    if success{
                        
                        let storyboard = UIStoryboard(name: "Login", bundle: nil)
                        let linkingVC = storyboard.instantiateViewController(withIdentifier: "resetPass")  as! UINavigationController
                        self.present(linkingVC, animated: true, completion: nil)
                        self.stopAnimating()
                    }else{
                        let dataRecived = try decoder.decode(ErrorHandle.self, from: jsonData)
                        self.present(common.makeAlert(message: dataRecived.message ?? ""), animated: true, completion: nil)
                        self.stopAnimating()
                    }
                }else{
                    let dataRecived = try decoder.decode(ErrorHandle.self, from: jsonData)
                    self.present(common.makeAlert(message: dataRecived.message ?? ""), animated: true, completion: nil)
                    self.stopAnimating()
                }
            }catch {
                self.present(common.makeAlert(message: "غير موجود"), animated: true, completion: nil)
                self.stopAnimating()
            }
        }
    }
}
