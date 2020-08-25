//
//  resetPass.swift
//  perfume
//
//  Created by Bassam Ramadan on 5/16/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import UIKit
class resetPassword: common, UIScrollViewDelegate{
    // MARK:- Outlets
    @IBOutlet var ScrollView : UIScrollView!
    @IBOutlet var BagroundImage : UIImageView!
    @IBOutlet var code : UITextField!
    @IBOutlet var pass : UITextField!
    @IBOutlet var configPass : UITextField!
    
    @IBOutlet var codeSeperator : UIView!
    @IBOutlet var passSeperator : UIView!
    @IBOutlet var configSeperator : UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAllDelegate()
    }
    
    func setupAllDelegate(){
        ScrollView.delegate = self
        pass.delegate = self
        code.delegate = self
        configPass.delegate = self
        pass.placeholder = ""
        code.placeholder = ""
        configPass.placeholder = ""
    }
     // MARK:- Actions
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        BagroundImage.transform = CGAffineTransform(translationX: 0, y: ((ScrollView.contentOffset.y/2)+22) * -1)
    }
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.dismiss(animated: true)
    }
    
     // MARK:- Api
    @IBAction func resetPass(sender : Any){
        self.loading()
        let url = AppDelegate.LocalUrl + "/resetPassword"
        let  info = [
            "code" : code.text ?? "",
            "email" : CashedData.getUserEmail() ?? "",
            "password" : pass.text ?? "",
            "password_confirmation" : configPass.text ?? ""
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
                        
                        self.openRegisteringPage(pagTitle: "Login",window: true)
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
                self.present(common.makeAlert(message: error.localizedDescription), animated: true, completion: nil)
                self.stopAnimating()
            }
        }
    }
}
extension resetPassword: UITextFieldDelegate{
    
    func switchSeperator(){
        codeSeperator.backgroundColor = UIColor(named: "separator")
        passSeperator.backgroundColor = UIColor(named: "separator")
        configSeperator.backgroundColor = UIColor(named: "separator")
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switchSeperator()
        switch textField {
        case code:
            codeSeperator.backgroundColor = UIColor(named: "dark Magenta")
        case pass:
            passSeperator.backgroundColor = UIColor(named: "dark Magenta")
        default:
            configSeperator.backgroundColor = UIColor(named: "dark Magenta")
            
        }
        
        return true
    }
}
