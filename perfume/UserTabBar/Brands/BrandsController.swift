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
        
        self.getCommonCategory(AppDelegate.LocalUrl+"/brands"){
            (data) in
            self.Brands.removeAll()
            self.Brands.append(contentsOf: data)
            self.BrandsCollection.reloadData()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getCartItems(id: 1)
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
        
        openPerfumeResults(maps: ["brands_ids":[self.Brands[indexPath.row].id ?? 0]], pagTitle: self.Brands[indexPath.row].name ?? "")
    }
}
