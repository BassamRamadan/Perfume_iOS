//
//  OrderPayment.swift
//  Joumla
//
//  Created by Bassam Ramadan on 2/20/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import UIKit
import SDWebImage
class OrderDetails: common , UIScrollViewDelegate{

    var OrderData : OrderDetailsData?
    @IBOutlet var ScrollView : UIScrollView!
    @IBOutlet var BagroundImage : UIImageView!
    // MARK:- Order Info Outlets
    var OrderId : Int?
    @IBOutlet var status : UILabel!
    @IBOutlet var status2 : UILabel!
    @IBOutlet var statusIcon : UIImageView!
    @IBOutlet var createdAt : UILabel!
    @IBOutlet var orederNumber : UILabel!
    @IBOutlet var cost : UILabel!
    @IBOutlet var shipping : UILabel!
    @IBOutlet var tax : UILabel!
    @IBOutlet var totalCost : UILabel!
    @IBOutlet var promoCode : UILabel!
    @IBOutlet var promoCodeValue : UILabel!
    // MARK:- Shipping Info Outlets
    var lat:Double?
    var long:Double?
    @IBOutlet var userName : UILabel!
    @IBOutlet var phone : UILabel!
    @IBOutlet var area : UILabel!
    @IBOutlet var buildingNumder : UILabel!
    @IBOutlet var flatNumber : UILabel!
    
    // MARK:- Payment Info Outlets
    @IBOutlet var receiptStack: UIStackView!
    var products = [Int]()
    @IBOutlet var paymentType : UILabel!
    @IBOutlet var productTable : UITableView!
    @IBOutlet var productTableHieght : NSLayoutConstraint!
    
     // MARK:- View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ScrollView.delegate = self
        getOrderDetails()
        self.navigationItem.hidesBackButton = true
    }
    @IBAction func back(sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    
    fileprivate func UpdateConstraints(){
      self.productTable.layoutIfNeeded()
        self.productTableHieght.constant = self.productTable.contentSize.height
    }
    func setupData(){
        status.text = Status(ApiStatus: OrderData?.status ?? "")
        status2.text = Status(ApiStatus: OrderData?.status ?? "")
        statusIcon.image = StatusIcon(ApiStatus: OrderData?.status ?? "")
        createdAt.text = OrderData?.createdAt ?? ""
        orederNumber.text = "\(OrderData?.id ?? 0)"
        totalCost.text = (OrderData?.totalCost ?? "").replacingOccurrences(of: "-", with: "")
        tax.text = (OrderData?.taxValue ?? "").replacingOccurrences(of: "-", with: "")
        shipping.text = (OrderData?.shippingValue ??  "").replacingOccurrences(of: "-", with: "")
        cost.text = getCost(totalCost.text ?? "0",tax.text ?? "0",shipping.text ?? "0")
        
        promoCode.text = OrderData?.promoCode ?? "كود الخصم"
        promoCodeValue.text = OrderData?.promoCodeValue ?? "0"
        
        userName.text = OrderData?.name ?? ""
        phone.text = OrderData?.phone ?? ""
        area.text = OrderData?.area ?? ""
        buildingNumder.text = OrderData?.buildingNumber ?? ""
        flatNumber.text = OrderData?.flatNumber ?? ""
        
        receiptStack.isHidden = OrderData?.paymentType ?? "" == "cach"
        paymentType.text = PaymentType(type: OrderData?.paymentType ?? "")
    }
    func getCost(_ totalCost: String,_ taxValue: String,_ shippingValue: String)-> String{
        var sum = 0.0
        if let a = totalCost.toDouble(){
            sum += a
        }
        if let b = taxValue.toDouble(){
            sum -= b
        }
        if let c = shippingValue.toDouble(){
            sum -= c
        }
        return "\(sum)"
    }
    func PaymentType(type: String)-> String{
        if type == "cach"{
            return "الدفع النقدى"
        }else if type == "bank"{
            return "التحويل البنكى"
        }else{
            return ""
        }
    }
    func Status(ApiStatus : String)-> String{
        switch ApiStatus {
        case "pending":
            return "قيد المعاينة"
        case "completed":
            return "مكتمل "
        case "rejected":
            return "تم الرفض"
        default:
            return "جارى الشحن"
        }
    }
    func StatusIcon(ApiStatus : String)-> UIImage{
        switch ApiStatus {
        case "pending":
            return #imageLiteral(resourceName: "status_pending")
        case "completed":
            return #imageLiteral(resourceName: "status_delivered")
        case "rejected":
            return #imageLiteral(resourceName: "ic_no_cancel")
        default:
            return #imageLiteral(resourceName: "status_charging")
        }
    }
     // MARK:- Actions
    @IBAction func ShowLocation(){
        let myAddress = "\(OrderData?.lat ?? ""),\(OrderData?.lon ?? "")"
        if let url = URL(string:"http://maps.apple.com/?ll=\(myAddress)") {
            UIApplication.shared.open(url)
        }
    }
    @IBAction func ShowReceiptImage(){
        let showAlert = UIAlertController(title: "إيصال التحويل", message: nil, preferredStyle: .alert)
        let imageView = UIImageView(frame: CGRect(x: 10, y: 50, width: 250, height: 230))
        imageView.sd_setImage(with: URL(string: self.OrderData?.receiptImagePath ?? ""))
        showAlert.view.addSubview(imageView)
        let height = NSLayoutConstraint(item: showAlert.view as Any, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 320)
        let width = NSLayoutConstraint(item: showAlert.view as Any, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 250)
        showAlert.view.addConstraint(height)
        showAlert.view.addConstraint(width)
        showAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            // your actions here...
        }))
        self.present(showAlert, animated: true, completion: nil)
    }
    
    
     // MARK:- Alamofire
    func getOrderDetails(){
        loading()
        let url = "https://services-apps.net/perfumecorner/public/api/my-orders/\(self.OrderId ?? 0)"
        let headers = [
            "Authorization": "Bearer " + (CashedData.getUserApiKey() ?? "")
        ]
        AlamofireRequests.getMethod(url: url, headers:headers) { (error, success , jsonData) in
            do {
                let decoder = JSONDecoder()
                if error == nil{
                    let dataRecived = try decoder.decode(userOrderDetails.self, from: jsonData)
                    if success{
                        
                        self.OrderData = dataRecived.data
                        self.setupData()
                        self.productTable.reloadData()
                        self.UpdateConstraints()
                    }
                    else  {
                        self.present(common.makeAlert(message: dataRecived.message ?? ""), animated: true, completion: nil)
                    }
                    self.stopAnimating()
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
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        BagroundImage.transform = CGAffineTransform(translationX: 0, y: ((ScrollView.contentOffset.y/2)+22) * -1)
    }
}
extension OrderDetails : UITableViewDataSource , UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.OrderData?.products?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetails", for: indexPath) as! newResultsCell
       
        let cellData = self.OrderData?.products?[indexPath.row].product
        
        cell.imagePath.sd_setImage(with: URL(string: cellData?.imagePath ?? ""))
        if cellData?.genders?.count ?? 0 > 0{
            cell.gender.text = cellData?.genders?[0].name ?? ""
        }
        if cellData?.types?.count ?? 0 > 0{
            cell.type.text = cellData?.types?[0].name ?? ""
        }
        if cellData?.prices?.count ?? 0 > 0{
            cell.price.text = cellData?.prices?[0].price ?? "0"
            cell.priceAfterDiscount.text = getPriceAfterDiscount(price: cellData?.prices?[0].price ?? "0", discount: cellData?.prices?[0].discount ?? "0")
            cell.size.text = cellData?.prices?[0].size ?? ""
        }
        cell.title.text = "\(cellData?.brand?.name ?? "") \(cellData?.name ?? "") \(cellData?.concentration?.name ?? "")"
        
        cell.quantity.text = self.OrderData?.products?[indexPath.row].quantity ?? "0"
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
