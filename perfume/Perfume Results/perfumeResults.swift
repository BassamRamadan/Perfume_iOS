//
//  perfumeResults.swift
//  perfume
//
//  Created by Bassam Ramadan on 4/20/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import UIKit

class perfumeResults: common {

    @IBOutlet var ResultsCollection: UICollectionView!
    @IBOutlet var FilterButton: UIButton!
    @IBOutlet var ResultsCount: UILabel!
    var productsResults: Array<Product> = []
    var nextPageUrl = AppDelegate.LocalUrl + "/products"
    var maps: Dictionary<String,Any> = [:]
    var pagTitle: String = ""
    var noData = false
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = pagTitle
        FilterButton.isHidden = pagTitle == "النتائج"
        setupBackButtonWithDismiss()
        getMoreProducts()
    }
    // MARK:- Actions
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if pagTitle != "النتائج"{
            AppDelegate.fieldPriceId.removeAll()
        }
    }
    func getMoreProducts(){
        getProducts(url: nextPageUrl,maps: maps){
            (data , nextPageUrl) in
            self.nextPageUrl = nextPageUrl
            self.noData = data?.count ?? 0 == 0
            self.productsResults.append(contentsOf: data ?? [])
            self.ResultsCount.text = "\(self.productsResults.count)"
            self.ResultsCollection.reloadData()
        }
    }
    @IBAction func AddToCart(sender: UIButton){
        if self.productsResults[sender.tag].prices?.count ?? 0 > 0{
            AddToCart(productId: self.productsResults[sender.tag].id,
                productPriceId: self.productsResults[sender.tag].prices?[0].id){
                        (ok) in
            }
        }else{
            self.present(common.makeAlert(message: "لم يتم إضافة سعر لهذا المنتج حاليا"), animated: true, completion: nil)
        }
    }
    
    @IBAction func toFiltering(){
        let storyboard = UIStoryboard(name: "Filtering", bundle: nil)
        let linkingNavigation = storyboard.instantiateViewController(withIdentifier: "FilteringNav") as! UINavigationController
        linkingNavigation.modalPresentationStyle = .fullScreen
        self.present(linkingNavigation,animated: true,completion: nil)
    }
    
    // MARK:- Alamofire
    
    
}
extension perfumeResults: UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if noData{
            return 1
        }
        return self.productsResults.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if noData{
            return CGSize(width: (collectionView.frame.size.width-15-20), height: 350)
        }
        return CGSize(width: (collectionView.frame.size.width-15-20)/2, height: 350)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if noData{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "noData", for: indexPath) as! noDataCell
            
            cell.noData.text = "لا يوجد بيانات متطابقة حاليا"
            return cell
        }
        if indexPath.row == self.productsResults.count - 1{
            getMoreProducts()
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "perfumeResults", for: indexPath) as! perfumeResultsCell
        
        let cellData = self.productsResults[indexPath.row]
        
        cell.imagePath.setDefaultImage(url: cellData.imagePath ?? "")
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
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 10, left: 10, bottom: 0, right: 10)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "perfumeDetails", bundle: nil)
        let linkingVC = storyboard.instantiateViewController(withIdentifier: "perfumeDetails")  as! UINavigationController
        let VC = linkingVC.viewControllers[0] as! perfumeDetails
        VC.productDetails = self.productsResults[indexPath.row]
        self.present(linkingVC, animated: true)
        
    }
}
