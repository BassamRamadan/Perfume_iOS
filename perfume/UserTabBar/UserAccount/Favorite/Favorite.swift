//
//  Favorite.swift
//  perfume
//
//  Created by Bassam Ramadan on 4/25/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import UIKit

class Favorite: common{

    @IBOutlet var favoriteTable: UITableView!
    @IBOutlet var itemCount: UILabel!
    
    var favoriteItems = [Product]()
    var noData = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let nav = navigationController {
            nav.setNavigationBarHidden(true, animated: true)
            nav.setToolbarHidden(true, animated: true)
        }
        self.itemCount.text = "\(favoriteItems.count)"
        self.noData = (favoriteItems.count == 0)
        self.favoriteTable.reloadData()
    }
  
    
    @IBAction func back(sender: UIButton){
        if let nav = navigationController {
            nav.setNavigationBarHidden(false, animated: true)
            nav.setToolbarHidden(false, animated: true)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func AddNewPerfumeToCart(sender: UIButton){
        AddToCart(productId: self.favoriteItems[sender.tag].id,
                  productPriceId: self.favoriteItems[sender.tag].prices?[0].id){
                    (ok)  in
                    
        }
        
    }
    @IBAction func Delet(sender: UIButton){
        let alert = UIAlertController(title: "تنبيه", message: "هل تريد الحذف بالفعل" , preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "لا أوافق", style: .default, handler: { action in
        }))
        alert.addAction(UIAlertAction(title: "موافق", style: .default, handler: { action in
            self.AddToFavorite(productId: self.favoriteItems[sender.tag].id ?? 0, alertText: "تم الحذف بنجاح"){
                (ok) in
                self.favoriteItems.remove(at: sender.tag)
                self.itemCount.text = "\(self.favoriteItems.count)"
                self.favoriteTable.reloadData()
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}
extension Favorite: UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.noData{
            return 1
        }
        return self.favoriteItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.noData{
          let cell = tableView.dequeueReusableCell(withIdentifier: "noData", for: indexPath)
          return cell
        }
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Favorite", for: indexPath) as! newResultsCell
        
        let cellData = self.favoriteItems[indexPath.row]
        cell.imagePath.sd_setImage(with: URL(string: cellData.imagePath ?? ""))
        if cellData.genders?.count ?? 0 > 0{
            cell.gender.text = cellData.genders?[0].name ?? ""
        }
        if cellData.types?.count ?? 0 > 0{
            cell.type.text = cellData.types?[0].name ?? ""
        }
        if cellData.prices?.count ?? 0 > 0{
            cell.price.text = cellData.prices?[0].price ?? "0"
            
            cell.priceAfterDiscount.text = getPriceAfterDiscount(price: cellData.prices?[0].price ?? "0", discount: cellData.prices?[0].discount ?? "0")
            
            cell.discount.text = (cellData.prices?[0].discount ?? "0").replacingOccurrences(of: ".00", with: "")+"%"
        }
        cell.title.text = "\(cellData.brand?.name ?? "") \(cellData.name ?? "") \(cellData.concentration?.name ?? "")"
        
        cell.AddToCart.tag = indexPath.row
        cell.removeItem.tag = indexPath.row
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let storyboard = UIStoryboard(name: "perfumeDetails", bundle: nil)
        let linkingVC = storyboard.instantiateViewController(withIdentifier: "perfumeDetails")  as! UINavigationController
        let VC = linkingVC.viewControllers[0] as! perfumeDetails
        VC.productDetails = self.favoriteItems[indexPath.row]
        AppDelegate.firstBadge[4] = true
        self.present(linkingVC, animated: true)
        
    }
    
}
