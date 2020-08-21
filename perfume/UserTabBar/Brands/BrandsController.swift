//
//  Markets.swift
//  perfume
//
//  Created by Bassam Ramadan on 4/25/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import UIKit

class BrandsController: ContentViewController {

    var Brands: Array<publicFilteringData> = []
    
    @IBOutlet var BrandsCollection: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AppDelegate.firstBadge[1] = true
        getBrands()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getCartItems(id: 1)
    }
    // MARK:- Alamofire
    fileprivate func getBrands(){
        self.loading()
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
                        self.Brands.removeAll()
                        self.Brands.append(contentsOf: dataReceived.data ?? [])
                        self.BrandsCollection.reloadData()
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
extension BrandsController: UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.Brands.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.contentSize.width-10)/2, height: 170)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BrandsCell", for: indexPath) as! BrandsCell
        
        cell.BrandName.text = self.Brands[indexPath.row].name ?? ""
        cell.BrandImage.sd_setImage(with: URL(string: self.Brands[indexPath.row].imagePath ?? ""))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let storyboard = UIStoryboard(name: "perfumeResults", bundle: nil)
        let linkingVC = storyboard.instantiateViewController(withIdentifier: "perfumeNav")  as! UINavigationController
        let linkVC = linkingVC.viewControllers[0] as! perfumeResults
        linkVC.maps = ["brands_ids":[self.Brands[indexPath.row].id ?? 0]]
        linkVC.pagTitle = self.Brands[indexPath.row].name ?? ""
        self.present(linkingVC, animated: true, completion: nil)
    }
}
