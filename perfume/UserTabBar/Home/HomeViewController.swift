//
//  HomeViewController.swift
//  perfume
//
//  Created by Bassam Ramadan on 4/17/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import UIKit

class HomeViewController: ContentViewController{

    @IBOutlet var perfumeTypes: UICollectionView!
    @IBOutlet var newPerfumes: UITableView!
    @IBOutlet var newPerfumesHeight: NSLayoutConstraint!
    @IBOutlet var moreViewsPerfumes: UITableView!
    @IBOutlet var moreViewsPerfumesHeight: NSLayoutConstraint!
    
    var Genders: Array<publicFilteringData> = []
    var newResults: Array<Product> = []
    var moreViewsResults: Array<Product> = []
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "الرئيسية"
        AppDelegate.firstBadge[0] = true
        getGenders()
        self.getProducts(maps: [:]){
            (data , nextPageUrl,total) in
            self.newResults.removeAll()
            self.newResults.append(contentsOf: data ?? [])
            self.newPerfumes.reloadData()
            self.updateConstraints()
        }
        self.getProducts(maps: ["most_viewed":true]){
            (data , nextPageUrl,total) in
            self.moreViewsResults.removeAll()
            self.moreViewsResults.append(contentsOf: data ?? [])
            self.moreViewsPerfumes.reloadData()
            self.moreViewsUpdateConstraints()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getCartItems(id: 0)
    }
    
    func updateConstraints(){
        newPerfumes.layoutIfNeeded()
        newPerfumesHeight.constant = newPerfumes.contentSize.height
    }
    func moreViewsUpdateConstraints(){
        moreViewsPerfumes.layoutIfNeeded()
        moreViewsPerfumesHeight.constant = moreViewsPerfumes.contentSize.height
    }
    // MARK:-  Actions
    @IBAction func toResults(sender: UIButton){
        openPerfumeResults(maps: sender.tag == 2 ? ["most_viewed":true] : [:], pagTitle: sender.tag == 2 ?  "جديد وحصرى": "الأكثر مشاهدة")
    }
    // MARK:-  Alamofire
    fileprivate func getGenders(){
        self.loading()
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
                        self.Genders.removeAll()
                        self.Genders.append(contentsOf: dataReceived.data ?? [])
                        self.perfumeTypes.reloadData()
                       
                        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPerfumeResults"{
            if let des = segue.destination as? UINavigationController{
                let linkVC = des.viewControllers[0] as! perfumeResults
                linkVC.maps = ["genders":[self.Genders[sender as! Int].id ?? 0]]
                linkVC.pagTitle = self.Genders[sender as! Int].name ?? ""
            }
        }
    }
    @IBAction func AddNewPerfumeToCart(sender: UIButton){
        if self.newResults[sender.tag].prices?.count ?? 0 > 0{
            AddToCart(productId: self.newResults[sender.tag].id,
            productPriceId: self.newResults[sender.tag].prices?[0].id){
                        (ok)  in
                self.getCartItems(id: 0)
            }
        }else{
             self.present(common.makeAlert(message: "لم يتم إضافة سعر لهذا المنتج حاليا"), animated: true, completion: nil)
        }
        
    }
    @IBAction func AddMoreViewsPerfumeToCart(sender: UIButton){
        if self.moreViewsResults[sender.tag].prices?.count ?? 0 > 0{
            AddToCart(productId: self.moreViewsResults[sender.tag].id,
                      productPriceId: self.moreViewsResults[sender.tag].prices?[0].id){
                        (ok)  in
                        self.getCartItems(id: 0)
            }
        }else{
            self.present(common.makeAlert(message: "لم يتم إضافة سعر لهذا المنتج حاليا"), animated: true, completion: nil)
        }
        
    }
}
extension HomeViewController: UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.Genders.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 180, height: collectionView.contentSize.height)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "perfumeTypes", for: indexPath) as! HomeCollectionCell
        cell.genderImage.setDefaultImage(url: self.Genders[indexPath.row].imagePath ?? "")
        cell.genderName.text = self.Genders[indexPath.row].name ?? ""
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        performSegue(withIdentifier: "toPerfumeResults", sender: indexPath.row)
    }
    
}
extension HomeViewController: UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == newPerfumes {
            return min(self.newResults.count,4)
        }else{
            return min(self.moreViewsResults.count,4)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cellId = "newPerfumes"
        var cellData : Product!
        if tableView == newPerfumes {
            cellId = "newPerfumes"
            cellData = self.newResults[indexPath.row]
        }else{
            cellId = "moreViewsPerfumes"
            cellData = self.moreViewsResults[indexPath.row]
        }
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
        
        var cellData : Product!
        if tableView == newPerfumes {
            cellData = self.newResults[indexPath.row]
        }else{
            cellData = self.moreViewsResults[indexPath.row]
        }
        
        openPerfumeDetails(productDetails: cellData)
    }
}
