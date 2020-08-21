//
//  imagesController.swift
//  perfume
//
//  Created by Bassam Ramadan on 4/17/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import UIKit

class imagesController: common {

    @IBOutlet var pageControl: UIPageControl!
    
    @IBOutlet var img1: UIImageView!
    @IBOutlet var discount1: UILabel!
    @IBOutlet var description1: UILabel!
    
    
    @IBOutlet var img2: UIImageView!
    @IBOutlet var discount2: UILabel!
    @IBOutlet var description2: UILabel!
    
    @IBOutlet var img3: UIImageView!
    @IBOutlet var discount3: UILabel!
    @IBOutlet var description3: UILabel!
    
    var BannersArr = [BannerDetails]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pageControl.numberOfPages = 0
        getBanners()
    }
    override func viewDidLayoutSubviews() {
        pageControl.subviews.forEach {
            $0.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }
    }
    func setupData(){
        if BannersArr.count > 0{
            img1.sd_setImage(with: URL(string: BannersArr[0].imagePath ?? ""))
            discount1.text = BannersArr[0].discount ?? "0"
            description1.text = BannersArr[0].description ?? ""
        }
        
        if BannersArr.count > 1{
            img2.sd_setImage(with: URL(string: BannersArr[1].imagePath ?? ""))
            discount2.text = BannersArr[1].discount ?? "0"
            description2.text = BannersArr[1].description ?? ""
        }
        
        if BannersArr.count > 2{
            img3.sd_setImage(with: URL(string: BannersArr[2].imagePath ?? ""))
            discount3.text = BannersArr[2].discount ?? "0"
            description3.text = BannersArr[2].description ?? ""
        }
       
       
        pageControl.subviews.forEach {
            $0.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }
        
        
    }
    
    // MARK:- Alamofire
    fileprivate func getBanners(){
        self.loading()
        let url = "https://services-apps.net/perfumecorner/public/api/banners"
        let headers = [
            "Content-Type": "application/json" ,
            "Accept" : "application/json",
        ]
        AlamofireRequests.getMethod(url: url, headers: headers) { (error, success, jsonData) in
            do {
                let decoder = JSONDecoder()
                if error == nil {
                    if success {
                        let dataReceived = try decoder.decode(Banners.self, from: jsonData)
                        self.BannersArr.removeAll()
                        self.BannersArr.append(contentsOf: dataReceived.data ?? [])
                        self.pageControl.numberOfPages = max(3, dataReceived.data?.count ?? 0)
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
}
extension imagesController: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let pagWidth = scrollView.bounds.width
        pageControl.currentPage = Int(scrollView.contentOffset.x / pagWidth)
    }
}
