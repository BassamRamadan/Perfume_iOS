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
    var cartEditedItem = [Int]()
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
            for (i,x) in (data?.items?.enumerated())!{
                self.cartEditedItem.append(Int(x.quantity ?? "0") ?? 0)
                print(self.cartEditedItem[i])
                if i == (data?.items?.count ?? 0)-1{
                    self.totalCost.text = self.CartItems?.totalCost ?? "0.0"
                    self.CartTable.reloadData()
                }
            }
        }
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        hidesBottomBarWhenPushed = true
    }
    // MARK:- Actions
    @IBAction func Minus(sender : UIButton){
        cartEditedItem[sender.tag] -= 1
        let prices = self.CartItems?.items?[sender.tag]
        let price = getPriceAfterDiscount(price: prices?.price ?? "", discount: prices?.discount ?? "")
        self.totalCost.text = getSum(self.totalCost.text ?? "",price, "-")
        CartTable.reloadData()
    }
    
    @IBAction func Plus(sender : UIButton){
        cartEditedItem[sender.tag] += 1
        let prices = self.CartItems?.items?[sender.tag]
        let price = getPriceAfterDiscount(price: prices?.price ?? "", discount: prices?.discount ?? "")
        self.totalCost.text = getSum(self.totalCost.text ?? "",price, "+")
        CartTable.reloadData()
    }
   
    @IBAction func Delet(sender: UIButton){
        let alert = UIAlertController(title: "تنبيه", message: "هل تريد الحذف بالفعل" , preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "لا أوافق", style: .default, handler: { action in
        }))
        alert.addAction(UIAlertAction(title: "موافق", style: .default, handler: { action in
            self.EditAndDeletItem(CartId: self.CartItems?.cartID, CartItemId: self.CartItems?.items?[sender.tag].id,isEditing: false)
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
        EditAndDeletItem(CartId: CartItems?.cartID ?? 0, CartItemId: 1)
        
    }
    func getSum(_ total: String,_ price: String,_ op: String) -> String{
        var IntPrice:Double? = Double(total.replacingOccurrences(of: ",", with: ""))
        let IntDiscount:Double? = Double(price)
        if let p = IntDiscount{
            if op == "+"{
                IntPrice = (IntPrice ?? 0.0) + (p)
            }else{
                IntPrice = (IntPrice ?? 0.0) - (p)
            }
        }
        return "\(IntPrice ?? 0.0)"
    }
    
    // MARK:- Alamofire
    
    func EditAndDeletItem(CartId: Int? , CartItemId: Int?,isEditing: Bool = true){
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
        if isEditing{
            // is Editing
            var items = [cartItemsAfterUpdat]()
            for (i,x) in (self.CartItems?.items?.enumerated())!{
                items.append(.init(id: x.id ?? 0, quantity: cartEditedItem[i]))
            }
            let AllData = cartAfterUpdat(cart_id: CartId ?? 0,items: items)
            let data = try! JSONEncoder.init().encode(AllData)
            let dictionaryy = try! JSONSerialization.jsonObject(with: data) as! [String: Any]
            info = dictionaryy
            url = AppDelegate.LocalUrl + "/edit-cart-item"
        }
        AlamofireRequests.PostMethod(methodType: "POST", url: url, info: info, headers: headers){
            (error, success, jsonData) in
            do {
                let decoder = JSONDecoder()
                if error == nil {
                    if success {
                        self.stopAnimating()
                        if isEditing{
                            self.goToNextPage()
                        }else{
                            self.getCartItems()
                        }
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
    func goToNextPage(){
        let storyboard = UIStoryboard(name: "Shopping", bundle: nil)
        let linkingVC = storyboard.instantiateViewController(withIdentifier: "Shopping") as! ShoppingAndPaymentInformation
        linkingVC.CartId = self.CartItems?.cartID
        linkingVC.parsingCost = self.CartItems?.totalCost
        
        linkingVC.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(linkingVC, animated: true)
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
        cell.quantity.text = "\(cartEditedItem[indexPath.row])"
        cell.size.text = cellData?.size ?? ""
        
        cell.price.text = cellData?.price ?? "0"
        cell.priceAfterDiscount.text = getPriceAfterDiscount(price: cellData?.price ?? "0", discount: cellData?.discount ?? "0")
        
        cell.delet.tag = indexPath.row
        cell.plus.tag = indexPath.row
        cell.minus.tag = indexPath.row
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}
struct cartAfterUpdat: Codable{
    internal init(cart_id: Int, items: [cartItemsAfterUpdat]) {
        self.cart_id = cart_id
        self.items = items
    }
    
    let cart_id: Int
    let items: [cartItemsAfterUpdat]
    
}
struct cartItemsAfterUpdat: Codable{
    internal init(id: Int, quantity: Int) {
        self.id = id
        self.quantity = quantity
    }
    
    let id,quantity: Int
}
