//
//  common.swift
//  Tourist-Guide
//
//  Created by mac on 11/28/19.
//  Copyright © 2019 Tamkeen. All rights reserved.
//
import UIKit
import NVActivityIndicatorView
import SDWebImage
class common : UIViewController , NVActivityIndicatorViewable{
    
    
    
    class func drowbackButton()->UIButton {
        let notifBtn: UIButton = UIButton(type: UIButton.ButtonType.custom)
        notifBtn.setImage(UIImage(named: "ic_back_black"), for: [])
        notifBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        return notifBtn
        // Do any additional setup after loading the view
    }
    class func drowCartButton()->UIButton {
        let notifBtn: UIButton = UIButton(type: UIButton.ButtonType.custom)
        notifBtn.setImage(UIImage(named: "ic_cart"), for: [])
        notifBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        return notifBtn
        // Do any additional setup after loading the view
    }
    class func drowCartNumber()->UIButton {
        let notifBtn: UIButton = UIButton(type: UIButton.ButtonType.custom)
        notifBtn.backgroundColor = UIColor(named: "VividOrange")
        notifBtn.frame = CGRect(x: 45, y: 0, width: 30, height: 30)
        notifBtn.layer.cornerRadius = 15
        notifBtn.layer.masksToBounds = false
        return notifBtn
        // Do any additional setup after loading the view
    }
  
    class func openLogin(sender : UINavigationController){
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let linkingVC = storyboard.instantiateViewController(withIdentifier: "Login")
        sender.present(linkingVC, animated: true, completion: nil)
    }
    

    class func isAdminLogedin()-> Bool{
        let token = CashedData.getAdminApiKey() ?? ""
        if token.isEmpty{
            return false
        }else{
            return true
        }
        
    }
    
    class func AdminLogout(currentController: UIViewController){
            CashedData.saveUserApiKey(token: "")
            openMain(currentController: currentController)
    }
    
    func loading(_ message:String = ""){
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "", type: NVActivityIndicatorType.lineSpinFadeLoader)
    }
    
    class func makeAlert( message: String = "عفوا حدث خطأ في الاتصال من فضلك حاول مره آخري") -> UIAlertController {
        let alert = UIAlertController(title: "تنبيه", message: message , preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            switch action.style{
            case .default,.cancel,.destructive:
                print("default")
            @unknown default:
                print("default")
            }}))
        return alert
    }
    func CallPhone(phone: String) {
        var fullMob: String = phone
        fullMob = fullMob.replacingOccurrences(of: " ", with: "")
        fullMob = fullMob.replacingOccurrences(of: "+", with: "")
        fullMob = fullMob.replacingOccurrences(of: "-", with: "")
        if fullMob != "" {
            let url = NSURL(string: "tel://\(fullMob)")!
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
    }
    func callWhats(whats: String) {
        var fullMob: String = whats
        fullMob = fullMob.replacingOccurrences(of: " ", with: "")
        fullMob = fullMob.replacingOccurrences(of: "+", with: "")
        fullMob = fullMob.replacingOccurrences(of: "-", with: "")
        let urlWhats = "whatsapp://send?phone=\(fullMob)"
        
        if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) {
            if let whatsappURL = NSURL(string: urlString) {
                if UIApplication.shared.canOpenURL(whatsappURL as URL) {
                    UIApplication.shared.open(whatsappURL as URL, options: [:], completionHandler: { (Bool) in
                    })
                } else {
                    self.present(common.makeAlert(message:NSLocalizedString("WhatsApp Not Found on your device", comment: "")), animated: true, completion: nil)
                }
            }
        }
    }
    func setupCartButton(number :Int) {
        self.navigationItem.hidesBackButton = true
        let backBtn: UIButton = common.drowCartButton()
        let backButton = UIBarButtonItem(customView: backBtn)
        backBtn.addTarget(self, action: #selector(self.OpenCart), for: UIControl.Event.touchUpInside)
        self.navigationItem.setLeftBarButton(backButton, animated: true)
    }
    
    func setupBackButtonWithPOP() {
        self.navigationItem.hidesBackButton = true
        let backBtn: UIButton = common.drowbackButton()
        let backButton = UIBarButtonItem(customView: backBtn)
        self.navigationItem.setRightBarButton(backButton, animated: true)
        backBtn.addTarget(self, action: #selector(self.POP), for: UIControl.Event.touchUpInside)
    }
    
    func setupBackButtonWithDismiss() {
        self.navigationItem.hidesBackButton = true
        let backBtn: UIButton = common.drowbackButton()
        let backButton = UIBarButtonItem(customView: backBtn)
        self.navigationItem.setRightBarButton(backButton, animated: true)
        backBtn.addTarget(self, action: #selector(self.Dismiss), for: UIControl.Event.touchUpInside)
    }
    
    @objc func Dismiss() {
        self.navigationController?.dismiss(animated: true)
    }
   
    @objc func POP() {
        self.navigationController?.popViewController(animated: true)
    }
    
   
    
    class func OpenSetting(){
        let storyboard = UIStoryboard(name: "Setting", bundle: nil)
        let linkingVC = storyboard.instantiateViewController(withIdentifier: "Setting")
        let appDelegate = UIApplication.shared.delegate
        appDelegate?.window??.rootViewController = linkingVC
    }
    
    class func openMain(currentController: UIViewController){
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        UIApplication.shared.keyWindow?.rootViewController = storyboard.instantiateInitialViewController()
    }
   
    @objc func OpenCart() {
        let storyboard = UIStoryboard(name: "Cart", bundle: nil)
        let linkingVC = storyboard.instantiateViewController(withIdentifier: "CartNav") as!
        UINavigationController
        self.present(linkingVC,animated: true,completion: nil)
    }
    
  
    
    
    
    func getPriceAfterDiscount(price: String,discount: String) -> String{
        var IntPrice:Double? = Double(price)
        var IntDiscount:Double? = Double(discount)
        
        IntDiscount = (IntDiscount ?? 0.0)/100.0
        if let p = IntDiscount{
            IntPrice = (IntPrice ?? 0.0) - ((IntPrice ?? 0.0) * p)
        }
        return "\(IntPrice ?? 0.0)"
    }
    
    
    
   
}




extension common {
    func getGenders(complition :  @escaping (_ sectionItems: [publicFilteringData])->Void){
        let url = AppDelegate.LocalUrl + "/genders"
        let headers = [
            "Content-Type": "application/json" ,
            "Accept" : "application/json",
        ]
        AlamofireRequests.getMethod(url: url, headers: headers) { (error, success, jsonData) in
            do {
                let decoder = JSONDecoder()
                if error == nil {
                    if success {
                        let dataReceived = try decoder.decode(publicFiltering.self, from: jsonData)
                        complition(dataReceived.data ?? [])
                        
                    }else{
                        self.present(common.makeAlert(), animated: true, completion: nil)
                        complition([])
                    }
                    
                }else{
                    let dataRecived = try decoder.decode(ErrorHandle.self, from: jsonData)
                    self.present(common.makeAlert(message: dataRecived.message ?? ""), animated: true, completion: nil)
                    complition([])
                }
            }catch {
                self.present(common.makeAlert(), animated: true, completion: nil)
                complition([])
            }
        }
    }
    
    
    func getBrands(complition :  @escaping (_ sectionItems: [publicFilteringData])->Void){
        let url = AppDelegate.LocalUrl + "/brands"
        let headers = [
            "Content-Type": "application/json" ,
            "Accept" : "application/json",
        ]
        AlamofireRequests.getMethod(url: url, headers: headers) { (error, success, jsonData) in
            do {
                let decoder = JSONDecoder()
                if error == nil {
                    if success {
                        let dataReceived = try decoder.decode(publicFiltering.self, from: jsonData)
                        complition(dataReceived.data ?? [])
                    }else{
                        self.present(common.makeAlert(), animated: true, completion: nil)
                        complition([])
                    }
                    
                }else{
                    let dataRecived = try decoder.decode(ErrorHandle.self, from: jsonData)
                    self.present(common.makeAlert(message: dataRecived.message ?? ""), animated: true, completion: nil)
                    complition([])
                }
            }catch {
                self.present(common.makeAlert(), animated: true, completion: nil)
                complition([])
            }
        }
    }
    
    
    func getTypes(complition :  @escaping (_ sectionItems: [publicFilteringData])->Void){
        let url = AppDelegate.LocalUrl + "/types"
        let headers = [
            "Content-Type": "application/json" ,
            "Accept" : "application/json",
        ]
        AlamofireRequests.getMethod(url: url, headers: headers) { (error, success, jsonData) in
            do {
                let decoder = JSONDecoder()
                if error == nil {
                    if success {
                        let dataReceived = try decoder.decode(publicFiltering.self, from: jsonData)
                        complition(dataReceived.data ?? [])
                    }else{
                        self.present(common.makeAlert(), animated: true, completion: nil)
                        complition([])
                    }
                    
                }else{
                    let dataRecived = try decoder.decode(ErrorHandle.self, from: jsonData)
                    self.present(common.makeAlert(message: dataRecived.message ?? ""), animated: true, completion: nil)
                    complition([])
                }
            }catch {
                self.present(common.makeAlert(), animated: true, completion: nil)
                complition([])
            }
        }
    }
    
    
    func getConcentrations(complition :  @escaping (_ sectionItems: [publicFilteringData])->Void){
        let url = AppDelegate.LocalUrl + "/concentrations"
        let headers = [
            "Content-Type": "application/json" ,
            "Accept" : "application/json",
        ]
        AlamofireRequests.getMethod(url: url, headers: headers) { (error, success, jsonData) in
            do {
                let decoder = JSONDecoder()
                if error == nil {
                    if success {
                        let dataReceived = try decoder.decode(publicFiltering.self, from: jsonData)
                        complition(dataReceived.data ?? [])
                    }else{
                        self.present(common.makeAlert(), animated: true, completion: nil)
                        complition([])
                    }
                    
                }else{
                    let dataRecived = try decoder.decode(ErrorHandle.self, from: jsonData)
                    self.present(common.makeAlert(message: dataRecived.message ?? ""), animated: true, completion: nil)
                    complition([])
                }
            }catch {
                self.present(common.makeAlert(), animated: true, completion: nil)
                complition([])
            }
        }
    }
    
    func getCart(complition : @escaping (_ CartItems:CartData?)->Void){
        let url = AppDelegate.LocalUrl + "/cart-items"
        let headers = [
            "Content-Type": "application/json" ,
            "Accept" : "application/json",
            "Authorization": "Bearer " + (CashedData.getUserApiKey() ?? "")
        ]
        AlamofireRequests.getMethod(url: url, headers: headers) { (error, success, jsonData) in
            do {
                let decoder = JSONDecoder()
                if error == nil {
                    if success {
                        let dataReceived = try decoder.decode(CartModel.self, from: jsonData)
                        complition(dataReceived.data)
                    }else{
                     //   self.present(common.makeAlert(), animated: true, completion: nil)
                    }
                   
                }else{
                    let dataRecived = try decoder.decode(ErrorHandle.self, from: jsonData)
                    self.present(common.makeAlert(message: dataRecived.message ?? ""), animated: true, completion: nil)
                }
            }catch {
                self.present(common.makeAlert(), animated: true, completion: nil)
            }
        }
    }
    
    func AddToCart(productId:Int?,productPriceId:Int?,complition : @escaping (_ ok:Bool)->Void){
        self.loading()
        let url = AppDelegate.LocalUrl + "/add-to-cart"
        let headers = [
            "Content-Type": "application/json" ,
            "Accept" : "application/json",
            "Authorization": "Bearer " + (CashedData.getUserApiKey() ?? "")
        ]
        let info:[String : Any] = [
            "product_id": productId ?? 0,
            "product_price_id": productPriceId ?? 0,
            "quantity":"1"
        ]
        AlamofireRequests.PostMethod(methodType: "POST", url: url, info: info, headers: headers){
            (error, success, jsonData) in
            do {
                let decoder = JSONDecoder()
                if error == nil {
                    if success {
                        self.present(common.makeAlert(message: "تم الإضافة الى العربة"), animated: true, completion: nil)
                       complition(true)
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
    
    func getProducts(url:String? = AppDelegate.LocalUrl + "/products",maps: Dictionary<String,Any> = [:],complition : @escaping (_ CartItems: [Product]?,_ url:String)->Void){
        
        let headers = [
            "Content-Type": "application/json" ,
            "Accept" : "application/json",
        ]
        let info:[String : Any] = maps.mapValues{ str in str }
        AlamofireRequests.PostMethod(methodType: "POST", url: url ?? "", info: info, headers: headers){
            (error, success, jsonData) in
            do {
                let decoder = JSONDecoder()
                if error == nil {
                    if success {
                        let dataReceived = try decoder.decode(Products.self, from: jsonData)
                        
                        complition(dataReceived.data?.products ?? [],dataReceived.data?.nextPageUrl ?? "")
                     
                    }else{
                        self.present(common.makeAlert(), animated: true, completion: nil)
                    }
                    
                }else{
                    let dataRecived = try decoder.decode(ErrorHandle.self, from: jsonData)
                    self.present(common.makeAlert(message: dataRecived.message ?? ""), animated: true, completion: nil)
                   
                }
            }catch {
                self.present(common.makeAlert(), animated: true, completion: nil)
                
            }
        }
    }
    
    func getOneProduct(id:Int,complition : @escaping (_ CartItems: Product?)->Void){
        self.loading()
        let url = AppDelegate.LocalUrl + "/products/\(id)"
        let headers = [
            "Content-Type": "application/json" ,
            "Accept" : "application/json",
        ]
        AlamofireRequests.getMethod(url: url, headers: headers){
            (error, success, jsonData) in
            do {
                let decoder = JSONDecoder()
                if error == nil {
                    if success {
                        let dataReceived = try decoder.decode(oneProduct.self, from: jsonData)
                        
                        complition(dataReceived.data?.product)
                        
                    }else{
                        self.present(common.makeAlert(), animated: true, completion: nil)
                    }
                    
                }else{
                    let dataRecived = try decoder.decode(ErrorHandle.self, from: jsonData)
                    self.present(common.makeAlert(message: dataRecived.message ?? ""), animated: true, completion: nil)
                    
                }
            }catch {
                self.present(common.makeAlert(), animated: true, completion: nil)
                
            }
        }
    }
    func AddToFavorite(productId:Int?,alertText:String,complition : @escaping (_ ok:Bool)->Void){
        self.loading()
        let url = AppDelegate.LocalUrl + "/add-to-favourite"
        let headers = [
            "Content-Type": "application/json" ,
            "Accept" : "application/json",
            "Authorization": "Bearer " + (CashedData.getUserApiKey() ?? "")
        ]
        let info:[String : Any] = [
            "product_id": productId ?? 0
        ]
        AlamofireRequests.PostMethod(methodType: "POST", url: url, info: info, headers: headers){
            (error, success, jsonData) in
            do {
                let decoder = JSONDecoder()
                if error == nil {
                    if success {
                        self.present(common.makeAlert(message: alertText), animated: true, completion: nil)
                        complition(true)
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
    
    func getBank(complition : @escaping (_ data:[bankAccount]?)->Void){
        let url = AppDelegate.LocalUrl + "/bank-account"
        let headers = [
            "Content-Type": "application/json" ,
            "Accept" : "application/json",
        ]
        AlamofireRequests.getMethod(url: url, headers: headers) { (error, success, jsonData) in
            do {
                let decoder = JSONDecoder()
                if error == nil {
                    if success {
                        let dataReceived = try decoder.decode(Banks.self, from: jsonData)
                        complition(dataReceived.data)
                    }else{
                        self.present(common.makeAlert(), animated: true, completion: nil)
                    }
                }else{
                    let dataRecived = try decoder.decode(ErrorHandle.self, from: jsonData)
                    self.present(common.makeAlert(message: dataRecived.message ?? ""), animated: true, completion: nil)
                }
            }catch {
                self.present(common.makeAlert(), animated: true, completion: nil)
            }
        }
    }
    func getFavorite(complition : @escaping (_ data:[Product]?)->Void){
        let url = AppDelegate.LocalUrl + "/favourites"
        let headers = [
            "Content-Type": "application/json" ,
            "Accept" : "application/json",
            "Authorization": "Bearer " + (CashedData.getUserApiKey() ?? "")
        ]
        
        AlamofireRequests.getMethod(url: url, headers: headers){
            (error, success, jsonData) in
            do {
                let decoder = JSONDecoder()
                if error == nil {
                    if success {
                        let dataReceived = try decoder.decode(FavoriteModel.self, from: jsonData)
                        complition(dataReceived.data ?? [])
                    }else{
                        self.present(common.makeAlert(), animated: true, completion: nil)
                    }
                    
                }else{
                    let dataRecived = try decoder.decode(ErrorHandle.self, from: jsonData)
                    self.present(common.makeAlert(message: dataRecived.message ?? ""), animated: true, completion: nil)
                    
                }
            }catch {
                self.present(common.makeAlert(), animated: true, completion: nil)
                
            }
        }
    }
}
extension String {
    
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
    
    func heightOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.height
    }
    
    func sizeOfString(usingFont font: UIFont) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        return self.size(withAttributes: fontAttributes)
    }
}
extension UIImageView {
    func setDefaultImage(url: String){
        self.sd_setImage(with: URL(string: url))
        if self.image == nil{
            self.image =  #imageLiteral(resourceName: "logo")
        }
    }
}
public extension CATransaction {
    static func perform(method: () -> Void, completion: @escaping () -> Void) {
        begin()
        setCompletionBlock {
            completion()
        }
        method()
        commit()
    }
}
public extension UITableView {
    func reloadData(completion: @escaping (() -> Void)) {
        CATransaction.perform(method: {
            reloadData()
        }, completion: completion)
    }
}
extension CAShapeLayer {
    func drawCircleAtLocation(location: CGPoint, withRadius radius: CGFloat, andColor color: UIColor,stokColor:UIColor) {
        fillColor = color.cgColor
        strokeColor = stokColor.cgColor
        let origin = CGPoint(x: location.x - radius, y: location.y - radius)
        path = UIBezierPath(ovalIn: CGRect(origin: origin, size: CGSize(width: radius * 2 + 5, height: radius * 2+5))).cgPath
    }
}
extension UIButton{
    public func addBadge(id:Int,number: Int, withOffset offset: CGPoint = CGPoint.zero, andBackgroundColor color: UIColor, strokeColor: UIColor,textColor:UIColor) {
        
        guard let view = self as? UIView
            else { return }
        
        // Initialize Badge
        if number == 0{
            AppDelegate.badge[id].removeFromSuperlayer()
            AppDelegate.badge[id] = CAShapeLayer()
            AppDelegate.firstBadge[id] = true
            return
        }
       
        if AppDelegate.firstBadge[id]{
            let radius = CGFloat(8)
            let location = CGPoint(x: view.frame.width - (radius + offset.x), y: (radius + offset.y))
            AppDelegate.badge[id].drawCircleAtLocation(location: location, withRadius: radius, andColor: color, stokColor: strokeColor)
            view.layer.addSublayer(AppDelegate.badge[id])
            
            // Initialiaze Badge's label
            let label = CATextLayer()
            label.string = "\(number)"
            label.alignmentMode = CATextLayerAlignmentMode.center
            if number > 9 {
                label.fontSize = 11
                label.font = UIFont(name:"HelveticaNeue-Bold", size: 11)!
                label.frame = CGRect(origin: CGPoint(x: location.x-5, y: offset.y+4), size: CGSize(width: 12, height: 16))
            }else{
                label.fontSize = 11
                label.font = UIFont(name:"HelveticaNeue-Bold", size: 11)!
                label.frame = CGRect(origin: CGPoint(x: location.x - 2, y: offset.y+4), size: CGSize(width: 10, height: 16))
            }
            label.foregroundColor = textColor.cgColor
            label.backgroundColor = UIColor.clear.cgColor
            label.contentsScale = UIScreen.main.scale
            AppDelegate.badge[id].addSublayer(label)
            var handle: UInt8 = 0
            // Save Badge as UIBarButtonItem property
            objc_setAssociatedObject(self, &handle, AppDelegate.badge, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            AppDelegate.firstBadge[id] = false
        }else{
            (AppDelegate.badge[id].sublayers?[0] as! CATextLayer).string = "\(number)"
        }
    }
    
}
