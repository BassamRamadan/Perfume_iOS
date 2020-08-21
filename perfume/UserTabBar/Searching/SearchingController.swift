//
//  SearchingController.swift
//  perfume
//
//  Created by Bassam Ramadan on 6/21/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import UIKit

class SearchingController: ContentViewController {
    // MARK:- Outlets
    @IBOutlet var wordsCollection: UICollectionView!
    var textArray: Array<publicFilteringData> = []
    @IBOutlet var moreViewsPerfumes: UITableView!
    @IBOutlet var moreViewsPerfumesHeight: NSLayoutConstraint!
    
    var moreViewsResults: Array<Product> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        wordsCollection.delegate = self
        wordsCollection.dataSource = self
        AppDelegate.firstBadge[2] = true


        getFourMainCategory()
        self.getProducts(maps: ["most_viewed":true]){
            (data , nextPageUrl) in
            self.moreViewsResults.removeAll()
            self.moreViewsResults.append(contentsOf: data ?? [])
            self.moreViewsPerfumes.reloadData()
            self.moreViewsUpdateConstraints()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getCartItems(id: 2)
    }
    fileprivate func getFourMainCategory() {
        self.getBrands(){
            (data) in
            self.ConvertToField("ماركة العطر", data)
        }
        self.getGenders(){
            (data) in
            self.ConvertToField("الجنس", data)
        }
        self.getTypes(){
            (data) in
            self.ConvertToField("النوع", data)
        }
        self.getConcentrations(){
            (data) in
            self.ConvertToField("التركيز", data)
        }
    }
    
    fileprivate func ConvertToField(_ name: String,_ data: [publicFilteringData]) {
        guard data.count != 0 else{
            return
        }
        self.textArray.append(contentsOf: data)
        self.wordsCollection.reloadData()
        self.wordsCollection.scrollToItem(at: NSIndexPath(item: self.textArray.count - 1, section: 0) as IndexPath, at: .right, animated: false)
    }
    func moreViewsUpdateConstraints(){
        moreViewsPerfumes.layoutIfNeeded()
        moreViewsPerfumesHeight.constant = moreViewsPerfumes.contentSize.height
    }
    // MARK:-  Actions
    @IBAction func toResults(sender: UIButton){
        
        let storyboard = UIStoryboard(name: "perfumeResults", bundle: nil)
        let linkingVC = storyboard.instantiateViewController(withIdentifier: "perfumeNav")  as! UINavigationController
        let linkVC = linkingVC.viewControllers[0] as! perfumeResults
       
        linkVC.maps = ["most_viewed":true]
        linkVC.pagTitle = "الأكثر مشاهدة"
        
        
        self.present(linkingVC, animated: true, completion: nil)
    }
    @IBAction func AddMoreViewsPerfumeToCart(sender: UIButton){
        
        if self.moreViewsResults[sender.tag].prices?.count ?? 0 > 0{
            AddToCart(productId: self.moreViewsResults[sender.tag].id,
                      productPriceId: self.moreViewsResults[sender.tag].prices?[0].id){
                        (ok) in
                        self.getCartItems(id: 2)
            }
        }else{
            self.present(common.makeAlert(message: "لم يتم إضافة سعر لهذا المنتج حاليا"), animated: true, completion: nil)
        }
    }
}
extension SearchingController: UICollectionViewDelegate,UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return textArray.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel(frame: CGRect.zero)
        label.text = textArray[indexPath.item].name
        label.sizeToFit()
        return CGSize(width: label.frame.width + 80, height: 50)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchId", for: indexPath) as! SearchingCell
        cell.word.text = textArray[indexPath.row].name
        return cell
    }
    
    
    
    
}
extension SearchingController: UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return min(self.moreViewsResults.count,4)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       
        let cellId = "moreViewsPerfumes"
        let cellData = self.moreViewsResults[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! newResultsCell
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let storyboard = UIStoryboard(name: "perfumeDetails", bundle: nil)
        let linkingVC = storyboard.instantiateViewController(withIdentifier: "perfumeDetails")  as! UINavigationController
        let VC = linkingVC.viewControllers[0] as! perfumeDetails
        VC.productDetails = self.moreViewsResults[indexPath.row]
        self.present(linkingVC, animated: true)
    }
}
