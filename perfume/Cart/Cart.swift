//
//  Cart.swift
//  perfume
//
//  Created by Bassam Ramadan on 4/20/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import UIKit
import SDWebImage
class Cart: common {

    @IBOutlet var CartTable: UITableView!
    @IBOutlet var totalCost: UILabel!
    var CartItems: CartData?
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "العربة"
        setupBackButtonWithDismiss()
        getCartItems()
    }
    func getCartItems(){
        getCart{
            (data) in
            self.CartItems = data
            self.totalCost.text = self.CartItems?.totalCost ?? "0.0"
            self.CartTable.reloadData()
        }
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        hidesBottomBarWhenPushed = true
    }
    // MARK:- Actions
    @IBAction func Minus(sender : UIButton){
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let cell = CartTable.cellForRow(at: indexPath) as! CartCell
        cell.edit.isHidden = false
        var x = Int((cell.quantity.text)!)
        x = x! - 1
        x = max(x!,1)
        cell.quantity.text = "\(x!)"
    }
    
    @IBAction func Plus(sender : UIButton){
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let cell = CartTable.cellForRow(at: indexPath) as! CartCell
        cell.edit.isHidden = false
        var x = Int((cell.quantity.text)!)
        x = x! + 1
        cell.quantity.text = "\(x!)"
    }
    
    @IBAction func Edit(sender: UIButton){
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let cell = CartTable.cellForRow(at: indexPath) as! CartCell
        self.EditAndDeletItem(CartId: self.CartItems?.cartID, CartItemId: self.CartItems?.items?[sender.tag].id,quantity: cell.quantity?.text)
    }
    @IBAction func Delet(sender: UIButton){
        let alert = UIAlertController(title: "تنبيه", message: "هل تريد الحذف بالفعل" , preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "لا أوافق", style: .default, handler: { action in
        }))
        alert.addAction(UIAlertAction(title: "موافق", style: .default, handler: { action in
            self.EditAndDeletItem(CartId: self.CartItems?.cartID, CartItemId: self.CartItems?.items?[sender.tag].id)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toShopping"{
            if let des = segue.destination as? UINavigationController{
                let linkVC = des.viewControllers[0] as! ShoppingAndPaymentInformation
                linkVC.CartId = self.CartItems?.cartID
            }
        }
    }
    @IBAction func Next(sender : UIButton){
        if self.CartItems?.items?.count ?? 0 == 0{
            return
        }
        
        let storyboard = UIStoryboard(name: "Shopping", bundle: nil)
        let linkingVC = storyboard.instantiateViewController(withIdentifier: "Shopping") as! ShoppingAndPaymentInformation
        linkingVC.CartId = self.CartItems?.cartID
        linkingVC.parsingCost = self.CartItems?.totalCost
        
        linkingVC.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(linkingVC, animated: true)
    }
    
    // MARK:- Alamofire
    
    func EditAndDeletItem(CartId: Int? , CartItemId: Int?,quantity: String? = nil){
        self.loading()
        var url = AppDelegate.LocalUrl + "/delete-cart-item"
        let headers = [
            "Content-Type": "application/json" ,
            "Accept" : "application/json",
            "Authorization": "Bearer " + (CashedData.getUserApiKey() ?? "")
        ]
        var info:[String : Any] = [
            "cart_id": CartId ?? 0,
            "cart_item_id": CartItemId ?? 0
        ]
        if quantity != nil {
            // is Editing
            info = [
                "cart_id": CartId ?? 0,
                "item_id": CartItemId ?? 0,
                "quantity": (quantity ?? "0")
                ]
            url = AppDelegate.LocalUrl + "/edit-cart-item"
        }
        AlamofireRequests.PostMethod(methodType: "POST", url: url, info: info, headers: headers){
            (error, success, jsonData) in
            do {
                let decoder = JSONDecoder()
                if error == nil {
                    if success {
                        self.stopAnimating()
                        self.getCartItems()
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
extension Cart: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.CartItems?.items?.count ?? 0 == 0{
            return 1
        }
        return self.CartItems?.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // no Items in Cart
        if self.CartItems?.items?.count ?? 0 == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "noData", for: indexPath)
            return cell
        }
        
        // items of Cart
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cart", for: indexPath) as! CartCell
        
        let cellData = self.CartItems?.items?[indexPath.row]
        
        cell.imagePath.sd_setImage(with: URL(string: cellData?.product?.imagePath ?? ""))
        
        if cellData?.product?.genders?.count ?? 0 > 0{
            cell.gender.text = cellData?.product?.genders?[0].name ?? ""
        }
        if cellData?.product?.types?.count ?? 0 > 0{
            cell.type.text = cellData?.product?.types?[0].name ?? ""
        }
        cell.title.text = "\(cellData?.product?.brand?.name ?? "") \(cellData?.product?.name ?? "") \(cellData?.product?.concentration?.name ?? "")"
        cell.quantity.text = cellData?.quantity ?? ""
        cell.size.text = cellData?.size ?? ""
        
        cell.price.text = cellData?.price ?? "0"
        cell.priceAfterDiscount.text = getPriceAfterDiscount(price: cellData?.price ?? "0", discount: cellData?.discount ?? "0")
        
        cell.delet.tag = indexPath.row
        cell.edit.tag = indexPath.row
        cell.edit.isHidden = true
        
        cell.plus.tag = indexPath.row
        cell.minus.tag = indexPath.row
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}
