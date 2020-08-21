//
//  ContactUs.swift
//  perfume
//
//  Created by Bassam Ramadan on 4/25/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import UIKit

class ContactUs: common {

     // MARK:- Outlets
    @IBOutlet var name : UITextField!
    @IBOutlet var email : UITextField!
    @IBOutlet var body : UITextView!
    
    // MARK:- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "إتصل بنا"
        let tap = UITapGestureRecognizer(target: self, action: #selector(ok(reg:)))
        view.addGestureRecognizer(tap)
        setupBackButtonWithDismiss()
        setUserData()
    }
    @objc func ok(reg : UITapGestureRecognizer){
        view.endEditing(true)
    }
     // MARK:- Actions
    fileprivate func Modules(){
        name.delegate = self
        email.delegate = self
        setModules(name)
        setModules(email)
    }
    fileprivate func setModules(_ textField : UIView){
        textField.backgroundColor = UIColor(named: "textFieldBackground")
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 0.0
    }
    
    fileprivate func setUserData(){
        email.text = CashedData.getUserEmail() ?? ""
        name.text = CashedData.getUserName() ?? ""
    }
    
    // MARK:- Alamofire
    @IBAction func AlamofireUpload(sender: UIButton){
        self.loading()
        let url = "https://services-apps.net/perfumecorner/public/api/contact-us"
        let headers = ["Content-Type": "application/json" ,
                       "Accept" : "application/json",
                       "Authorization": "Bearer \(CashedData.getUserApiKey() ?? "")"
        ]
        let parameters = [
            "name": name.text!,
            "email": email.text!,
            "message": body.text!
            ] as [String : Any]
        AlamofireRequests.PostMethod(methodType: "POST", url: url, info: parameters, headers: headers) {
            (error, success , jsonData) in
            do {
                let decoder = JSONDecoder()
                if error == nil{
                    if success{
                        self.body.text = ""
                        let alert = common.makeAlert( message: "تم الارسال بنجاح")
                        self.present(alert, animated: true, completion: nil)
                    }
                    else{
                        let dataRecived = try decoder.decode(ErrorHandle.self, from: jsonData)
                        let alert = common.makeAlert(message: dataRecived.message ?? "")
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
extension ContactUs : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.backgroundColor = .white
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor(named: "light blue")?.cgColor
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        setModules(textField)
    }
}
