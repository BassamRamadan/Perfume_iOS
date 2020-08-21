//
//  Setting.swift
//  ezhelhaa
//
//  Created by Bassam Ramadan on 3/31/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import UIKit
import Photos
import SDWebImage
class UserAccount: ContentViewController ,UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    // MARK: - Outlets
    let myPicController = UIImagePickerController()
    var images : UIImage?
    var orders = [OrdersData]()
    var favorites = [Product]()
    @IBOutlet var orderCount : UILabel!
    @IBOutlet var favoriteCount : UILabel!
    @IBOutlet var name : UILabel!
    @IBOutlet var email : UILabel!
    @IBOutlet var image : UIImageView!
    @IBOutlet var camera : UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AppDelegate.firstBadge[3] = true
        setupData()
        myPicController.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if CashedData.getUserApiKey() == ""{
            openRegisteringPage(pagTitle: "Login",window: true)
        }else{
            getOrdersData(url: "https://services-apps.net/perfumecorner/public/api/my-orders?status=sent")
            getFavorite{
                (data) in
                self.favorites.removeAll()
                self.favorites.append(contentsOf: data ?? [])
                self.favoriteCount.text = "\(self.favorites.count)"
            }
        }
        getCartItems(id: 3)
    }
    // MARK: - set Data
    func setupData(){
        name.text = CashedData.getUserName()
        email.text = CashedData.getUserEmail()
        image.sd_setImage(with: URL(string: CashedData.getUserImage() ?? ""))
        if image.image == nil {
            image.image = #imageLiteral(resourceName: "avatar")
        }
    }
    
    
    // MARK: - Actions
    @IBAction func Orders(_ sender: Any){
        let storyboard = UIStoryboard(name: "Orders", bundle: nil)
        let linkingVC = storyboard.instantiateViewController(withIdentifier: "Orders") as! UINavigationController
        linkingVC.modalPresentationStyle = .fullScreen
        let des = linkingVC.viewControllers[0] as! Orders
        des.myOrders = self.orders
        self.present(linkingVC,animated: true,completion: nil)
    }
    
    @IBAction func Favorite(_ sender: Any){
        
        let storyboard = UIStoryboard(name: "Favorite", bundle: nil)
        let linkingVC = storyboard.instantiateViewController(withIdentifier: "Favorite") as! Favorite
        linkingVC.modalPresentationStyle = .fullScreen
        linkingVC.favoriteItems = self.favorites
        navigationController?.pushViewController(linkingVC, animated: true)
    }
    
    @IBAction func Share(_ sender: Any){
        let activityController = UIActivityViewController(activityItems: [AppDelegate.stringWithLink], applicationActivities: nil)
        
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            navigationItem.setLeftBarButton(UIBarButtonItem(customView: UIButton()), animated: false)
            let activityVC: UIActivityViewController = UIActivityViewController(activityItems: [AppDelegate.stringWithLink], applicationActivities: nil)
            present(activityVC, animated: true)
            if let popOver = activityVC.popoverPresentationController {
                popOver.barButtonItem = navigationItem.leftBarButtonItem
                //popOver.barButtonItem
            }
            
        } else {
            present(activityController, animated: true)
        }
    }
    
    @IBAction func EditInfomation(_ sender: Any){
        performSegue(withIdentifier: "Edit", sender: self)
    }
    
    @IBAction func logout(_ sender: Any){
        common.AdminLogout(currentController: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Edit"{
            if let link = segue.destination as? UINavigationController{
               let des = link.viewControllers[0] as! Sign
                des.isProfilEditing = true
            }
        }
    }

    
   
    
     // MARK: - Pick Images
    
    @IBAction func pickImages(_ sender: UIButton) {
         checkPermission()
    }
    
    @objc  func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            self.image.image = image
            EditProfile()
        }
        self.dismiss(animated: true, completion: nil)
        
    }
    func EditProfile(){
        self.loading()
        let url = "\(AppDelegate.LocalUrl)/edit-profile"
        let  info = [
            "username" : name.text ?? "",
            "email" : email.text ?? "",
            "password" : CashedData.getUserPassword() ?? "",
            "password_confirmation" : CashedData.getUserPassword() ?? "",
            "_method" : "PUT"
        ]
        let headers = [
            "Accept" : "application/json",
            "Content-Type" : "application/json",
            "Authorization": "Bearer \(CashedData.getUserApiKey() ?? "")"
        ]
        AlamofireRequests.UserSignUp(url: url, info: info as [String : Any], images: [], CompanyImage: self.image.image, coverImage: nil, idImage: nil, licenseImage: nil, headers: headers){
            (error, success , jsonData) in
            do {
                let decoder = JSONDecoder()
                if error == nil{
                    if success{
                        let dataRecived = try decoder.decode(SignUp.self, from: jsonData)
                        CashedData.saveUserImage(name: dataRecived.data?.imagePath ?? "")
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
    func checkPermission() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            myPicController.sourceType = UIImagePickerController.SourceType.photoLibrary
            myPicController.allowsEditing = true
            self.present(myPicController , animated: true, completion: nil)
            print("Access is granted by user")
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                print("status is \(newStatus)")
                if newStatus ==  PHAuthorizationStatus.authorized {
                    /* do stuff here */
                    print("success")
                }
            })
            print("It is not determined until now")
        case .restricted:
            // same same
            print("User do not have access to photo album.")
        case .denied:
            // same same
            print("User has denied the permission.")
        @unknown default:
            print("User has denied the permission.")
        }
    }
    
    
    // MARK:- Alamofire
    func getOrdersData(url: String){
        loading()
        let headers = [
            "Authorization": "Bearer " + (CashedData.getUserApiKey() ?? "")
        ]
        AlamofireRequests.getMethod(url: url, headers:headers) { (error, success , jsonData) in
            do {
                let decoder = JSONDecoder()
                if error == nil{
                    let dataRecived = try decoder.decode(userOrders.self, from: jsonData)
                    if success{
                        self.orders.removeAll()
                        self.orders.append(contentsOf: dataRecived.data ?? [])
                        self.orderCount.text = "\(self.orders.count)"
                        self.stopAnimating()
                    }
                    else  {
                        self.present(common.makeAlert(message: dataRecived.message ?? ""), animated: true, completion: nil)
                        self.stopAnimating()
                    }
                }else{
                    let dataRecived = try decoder.decode(ErrorHandle.self, from: jsonData)
                    self.present(common.makeAlert(message: dataRecived.message ?? ""), animated: true, completion: nil)
                    self.stopAnimating()
                }
            } catch {
                self.present(common.makeAlert(), animated: true, completion: nil)
                self.stopAnimating()
            }
        }
        
    }
    
}
