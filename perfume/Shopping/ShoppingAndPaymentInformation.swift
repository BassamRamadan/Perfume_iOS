//
//  paymentInformation.swift
//  perfume
//
//  Created by Bassam Ramadan on 6/27/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Photos
class ShoppingAndPaymentInformation: common , CLLocationManagerDelegate{
    
     // MARK: - Outlets
    var CartId: Int?
    var parsingCost: String?
    var pagNumber = 1
    var addingValue: taxData?
    @IBOutlet var cost : UILabel!
    @IBOutlet var shipping : UILabel!
    @IBOutlet var tax : UILabel!
    @IBOutlet var totalCost : UILabel!
    @IBOutlet var promoCode : UITextField!
    
    @IBOutlet var handPayView : UIView!
    @IBOutlet var bankPayView : UIView!
    
    @IBOutlet var handPayIcon : UIImageView!
    @IBOutlet var bankPayIcon : UIImageView!
    

    var paymentType = "cach"
    @IBOutlet var attachementView : UIView!
    
    @IBOutlet var paymentInfoPage : UIView!
    @IBOutlet var shippingInfoPage : UIView!
    @IBOutlet var submit : UIButton!
    
    
    @IBOutlet var name : UITextField!
    @IBOutlet var phone : UITextField!
    @IBOutlet var area : UITextField!
    @IBOutlet var flatNumber : UITextField!
    @IBOutlet var buildingNumber : UITextField!
    
    @IBOutlet var banksTable : UITableView!
   
    let myPicController = UIImagePickerController()
    var image : UIImage?
    
    // MARk:- Map
    let geocoder = GMSGeocoder()
    @IBOutlet var mapView: GMSMapView!
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0
    // An array to hold the list of likely places.
    var likelyPlaces: [GMSPlace] = []
    let marker = GMSMarker()
    // The currently selected place.
    var selectedPlace: GMSPlace?
    var long:Double?
    var lat:Double?
    var banks = [bankAccount]()
    // MARK: - View Did Load
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation = locations.last
        
        showMarker(position: userLocation!.coordinate)
        self.locationManager.stopUpdatingLocation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        myPicController.delegate = self
        
        locationManager.delegate = self
        // add button to current location
        self.locationManager.startUpdatingLocation()
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 20)
        mapView.delegate = self
        
        setupBackButton()
        navigationItem.title = "معلومات الشحن"
        submit.setTitle("التالى", for: .normal)
        paymentInfoPage.isHidden = true
        Modules()
        getTax()
        getBank(){
            (data) in
            self.banks.removeAll()
            self.banks.append(contentsOf: data ?? [])
            self.banksTable.reloadData()
        }
    }
    fileprivate func setupData(){
        parsingCost = parsingCost?.replacingOccurrences(of: ",", with: "")
        cost.text = parsingCost ?? "0"
        tax.text = addingValue?.tax ?? "0"
        shipping.text = addingValue?.shipping ?? "0"
        
        let b = Double(tax.text ?? "") ?? 0.0
        let c = Double(shipping.text ?? "") ?? 0.0
        if let a = parsingCost{
            if let p = Double(a){
                let ans = p + b + c
                totalCost.text = "\(ans)".currencyFormatting()
            }
        }
        
    }
    @IBAction func handPayAction(sender: UIButton){
        if sender.tag == 1{
            handPayIcon.image = #imageLiteral(resourceName: "ic_radio_checked")
            bankPayIcon.image = #imageLiteral(resourceName: "ic_radio")
            handPayView.backgroundColor = .white
            bankPayView.backgroundColor = nil
        }else{
            bankPayIcon.image = #imageLiteral(resourceName: "ic_radio_checked")
            handPayIcon.image = #imageLiteral(resourceName: "ic_radio")
            bankPayView.backgroundColor = .white
            handPayView.backgroundColor = nil
        }
        attachementView.isHidden = sender.tag == 1
        banksTable.isHidden = sender.tag == 1
        self.paymentType = sender.tag == 1 ? "cach":"bank"
    }
    private func setupBackButton(){
        self.navigationItem.hidesBackButton = true
        let backBtn: UIButton = common.drowbackButton()
        let backButton = UIBarButtonItem(customView: backBtn)
        self.navigationItem.setRightBarButton(backButton, animated: true)
        backBtn.addTarget(self, action: #selector(back), for: UIControl.Event.touchUpInside)
    }
    @objc func back(){
        if pagNumber == 1{
            navigationController?.popViewController(animated: true)
        }else{
            navigationItem.title = "معلومات الشحن"
            paymentInfoPage.isHidden = true
            shippingInfoPage.isHidden = false
            submit.setTitle("التالى", for: .normal)
            pagNumber -= 1
        }
    }
    
    @IBAction func Next(sender: UIButton){
        if pagNumber == 2{
            UploadCart()
        }else{
            navigationItem.title = "معلومات الدفع"
            paymentInfoPage.isHidden = false
            shippingInfoPage.isHidden = true
            submit.setTitle("إتمام الشراء", for: .normal)
            pagNumber += 1
        }
    }
    func showMarker(position: CLLocationCoordinate2D){
        
        self.long = position.longitude
        self.lat = position.latitude
        geocoder.reverseGeocodeCoordinate(position) { (response, error) in
            guard let address = response?.firstResult(), let lines = address.lines else {
                return
            }
            self.marker.position = position
            self.marker.title = lines.joined(separator: "\n")
            self.marker.map = self.mapView
        //    self.addressOnMap.text = lines.joined(separator: "\n")
        }
        self.mapView.camera = GMSCameraPosition.camera(withLatitude: lat ?? 21.555940, longitude: long ?? 39.194628, zoom: 12.0)
    }
    
    @IBAction func gpsAction(_ sender: Any){
        self.mapView.isMyLocationEnabled = true
        //Location Manager code to fetch current location
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = 1.0
    }
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            // Show alert letting the user know they have to turn this on.
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied , .restricted , .authorizedAlways:
            print("denied")
        @unknown default:
            print("default")
        }
    }
    
    fileprivate func Modules(){
        name.delegate = self
        phone.delegate = self
        flatNumber.delegate = self
        area.delegate = self
        buildingNumber.delegate = self
        promoCode.delegate = self
        setModules(name)
        setModules(phone)
        setModules(flatNumber)
        setModules(area)
        setModules(buildingNumber)
        setModules(promoCode)
    }
    fileprivate func setModules(_ textField : UIView){
        textField.backgroundColor = .white
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 0.0
    }
    // MARK:- Alamofire
    fileprivate func getTax(){
        self.loading()
        let url = "https://services-apps.net/perfumecorner/public/api/get-configs"
        let headers = [
            "Content-Type": "application/json" ,
            "Accept" : "application/json",
        ]
        AlamofireRequests.getMethod(url: url, headers: headers) { (error, success, jsonData) in
            do {
                let decoder = JSONDecoder()
                if error == nil {
                    if success {
                        let dataReceived = try decoder.decode(Taxing.self, from: jsonData)
                        self.addingValue = dataReceived.data?.items
                        self.setupData()
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
    func UploadCart(){
        loading()
        let url = AppDelegate.LocalUrl + "/checkout"
        let headers = [
            "Accept" : "application/json",
            "Content-Type": "application/json",
            "Authorization": "Bearer " + (CashedData.getUserApiKey() ?? "")
        ]
        var info = [
            "cart_id":"\(CartId ?? 0)",
            "name":name.text ?? "",
            "lat": "\(lat ?? 0.0)",
            "lon": "\(long ?? 0.0)",
            "area":area.text ?? "",
            "building number":buildingNumber.text ?? "",
            "flat_number": flatNumber.text ?? "",
            "phone": phone.text ?? "",
            "payment_type":self.paymentType
            ]
        if promoCode.text != nil{
            info["promo_code"] = promoCode.text ?? ""
        }
        AlamofireRequests.uploadMethod(url: url, info: info, images: [self.image], imageName: "receipt_image", headers: headers){
                (error, success , jsonData) in
            do {
                let decoder = JSONDecoder()
                let dataRecived = try decoder.decode(ErrorHandle.self, from: jsonData)
                if error == nil{
                    if success{
                        
                        let storyboard = UIStoryboard(name: "Shopping", bundle: nil)
                        let linkingVC = storyboard.instantiateViewController(withIdentifier: "MoveToMain") as! UINavigationController
                        let appDelegate = UIApplication.shared.delegate
                        appDelegate?.window??.rootViewController = linkingVC
                        self.stopAnimating()
                    }
                    else  {
                        self.present(common.makeAlert(message: dataRecived.message ?? "" ), animated: true, completion: nil)
                        self.stopAnimating()
                    }
                }else{
                    let dataRecived = try decoder.decode(ErrorHandle.self, from: jsonData)
                    self.present(common.makeAlert(message: dataRecived.message ?? ""), animated: true, completion: nil)
                    self.stopAnimating()
                }
            } catch {
                self.present(common.makeAlert(message: "حدث خطأ بالرجاء التاكد من تسجيل الدخول "), animated: true, completion: nil)
                self.stopAnimating()
            }
        }
        
    }
    
}
extension ShoppingAndPaymentInformation: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    // MARK:- Pick Image
    @IBAction func pickImages(_ sender: UIButton) {
        checkPermission()
    }
    
    @objc  func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            self.image = image
            
        }
        self.dismiss(animated: true, completion: nil)
        
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
}
extension ShoppingAndPaymentInformation: GMSMapViewDelegate{
    //MARK - GMSMarker Dragging
    func mapView(_ mapView: GMSMapView, didBeginDragging marker: GMSMarker) {
        print("didBeginDragging")
    }
    func mapView(_ mapView: GMSMapView, didDrag marker: GMSMarker) {
        print("didDrag")
    }
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
        print("didEndDragging")
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D){
        print("didDrag")
        // mapView.clear()
        self.showMarker(position: coordinate)
    }
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        
    }
    
    
}
extension ShoppingAndPaymentInformation : UITextFieldDelegate {
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
extension ShoppingAndPaymentInformation :  UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return banks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "banks", for: indexPath) as! bankCell
        cell.name.text = banks[indexPath.row].bankName ?? ""
        cell.username.text = banks[indexPath.row].bankUsername ?? ""
        cell.account.text = banks[indexPath.row].bankNumber ?? ""
        cell.logo.sd_setImage(with: URL(string:  banks[indexPath.row].bankLogo ?? ""))
        return cell
    }
    


}
