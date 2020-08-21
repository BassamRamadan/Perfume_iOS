//
//  Login.swift
//  perfume
//
//  Created by Bassam Ramadan on 5/16/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import UIKit
class Login: common , UIScrollViewDelegate{
    // MARK:- Outlets
    @IBOutlet var ScrollView : UIScrollView!
    @IBOutlet var BagroundImage : UIImageView!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    
    // MARK:- ViewDidload
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        ScrollView.delegate = self
    }
    
    @IBAction func check(_ sender: UIButton) {
        if sender.imageView?.image == #imageLiteral(resourceName: "checked") {
            sender.setImage(#imageLiteral(resourceName: "check"), for: .normal)
        }else{
            sender.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
        }
    }
    // MARK:- Alamofire
    @IBAction func login(_ sender: UIButton) {
        self.loading()
        let url = "https://services-apps.net/perfumecorner/public/api/login"
        let info = ["username": userName.text!,
                    "password": password.text!
        ]
        
        let headers = [ "Content-Type": "application/json" ,
                        "Accept" : "application/json"
        ]
        AlamofireRequests.PostMethod( methodType: "POST", url: url, info: info, headers: headers) { (error, success , jsonData) in
            do {
                let decoder = JSONDecoder()
                if error == nil{
                    if success{
                       let dataRecived = try decoder.decode(SignUp.self, from: jsonData)
                        let user = dataRecived.data
                        CashedData.saveUserApiKey(token: user?.accessToken ?? "")
                        CashedData.saveUserUpdateKey(token: user?.accessToken ?? "")
                        CashedData.saveUserName(name: user?.username ?? "")
                        CashedData.saveUserEmail(name: user?.email ?? "")
                        CashedData.saveUserImage(name: user?.imagePath ?? "")
                        CashedData.saveUserPassword(name: self.password.text ?? "")
                        self.navigationController?.dismiss(animated: true)
                        
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let linkingVC = storyboard.instantiateViewController(withIdentifier: "Main") as! MainViewController
                        let appDelegate = UIApplication.shared.delegate
                        appDelegate?.window??.rootViewController = linkingVC
                       
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
            }
        }
    }
    // MARK:- Actions
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
       
        BagroundImage.transform = CGAffineTransform(translationX: 0, y: ((ScrollView.contentOffset.y/2)+22) * -1)
    }
    @IBAction func sign(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let linkingVC = storyboard.instantiateViewController(withIdentifier: "Sign")  as! UINavigationController
        self.present(linkingVC, animated: true, completion: nil)
    }
    
    @IBAction func forgetPass(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let linkingVC = storyboard.instantiateViewController(withIdentifier: "forgetPass")  as! UINavigationController
        self.present(linkingVC, animated: true, completion: nil)
    }
    @IBAction func back(_ sender: UIButton) {
       self.navigationController?.dismiss(animated: true)
    }

}