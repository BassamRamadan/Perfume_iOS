//
//  perfumeDetails.swift
//  perfume
//
//  Created by Bassam Ramadan on 8/3/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import UIKit

class perfumeDetails: ContentViewController{
    
    @IBOutlet var RelatedCollection: UICollectionView!
    
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var topView: UIView!
    @IBOutlet var gender: UILabel!
    @IBOutlet var type: UILabel!
    @IBOutlet var price: UILabel!
    @IBOutlet var priceAfterDiscount: UILabel!
    @IBOutlet var discount: UILabel!
    @IBOutlet var details: UILabel!
    
    @IBOutlet var favoriteButton: UIButton!
    
    @IBOutlet var infoStack: UIStackView!
    @IBOutlet var infoBrand: UILabel!
    @IBOutlet var infoGender: UILabel!
    @IBOutlet var infoType: UILabel!
    @IBOutlet var infoConcentration: UILabel!
    
    @IBOutlet var infoBtn: UIButton!
    @IBOutlet var descriptionBtn: UIButton!
    @IBOutlet var infoUnderline: UIView!
    @IBOutlet var descriptionUnderline: UIView!
    @IBOutlet var descriptionlabel: UILabel!
    
    @IBOutlet var infoTableView: UITableView!
    @IBOutlet var infoTableViewHeight: NSLayoutConstraint!
    
    var RelatedProducts = [Product]()
    var horizontalScrollView: UIScrollView!
    var productDetails : Product? = nil
    var selectedSizeId = -1
    var selectedSizeIndex = 0
    var numberOfVc = 1
    // MARK:- View did load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupHorizontalScrollView()
        setupBackButtonWithDismiss()
        
        getOneProduct(id: productDetails?.id ?? 0){
            (data) in
            self.productDetails = data
            self.setData()
            self.infoTableView.reloadData(completion: {
                self.updateTableConstrainst()
            })
            self.stopAnimating()
        }
        getProducts(maps: ["brands_ids":[productDetails?.brand?.id ?? 0]]){
            (data , nextPageUrl,total)  in
            self.RelatedProducts.removeAll()
            self.RelatedProducts.append(contentsOf: data ?? [])
            for (i,x) in self.RelatedProducts.enumerated(){
                if self.productDetails?.id == x.id{
                    self.RelatedProducts.remove(at: i)
                    self.RelatedCollection.reloadData()
                    break
                }
                if i == self.RelatedProducts.count{
                    self.RelatedCollection.reloadData()
                }
            }
            
        }
        getFavorite{
            (data) in
            for x in data ?? []{
                if self.productDetails?.id == x.id{
                    self.favoriteButton.setImage(#imageLiteral(resourceName: "ic_favorite_active"), for: .normal)
                    break
                }
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getCartItems(id: -1)
        getCartItems(id: 4)
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.updateTableConstrainst()
    }
    @IBAction func AddFavorite(sender: UIButton){
        if favoriteButton.imageView?.image == #imageLiteral(resourceName: "ic_favorite_active"){
            AddToFavorite(productId: self.productDetails?.id ?? 0, alertText: "تم الإزالة"){
                (_) in
                self.favoriteButton.setImage(#imageLiteral(resourceName: "ic_myfav"), for: .normal)
            }
        }else{
            AddToFavorite(productId: self.productDetails?.id ?? 0, alertText: "تم الإضافة"){
                (_) in
                self.favoriteButton.setImage(#imageLiteral(resourceName: "ic_favorite_active"), for: .normal)
            }
        }
    }
    @IBAction func AddCart(sender: UIButton){
        if self.productDetails?.prices?.count ?? 0 > 0{
            AddToCart(productId: self.productDetails?.id,
                      productPriceId: self.productDetails?.prices?[selectedSizeIndex].id){
                        (ok) in
                        self.getCartItems(id: 4)
            }
        }else{
            self.present(common.makeAlert(message: "لم يتم إضافة سعر لهذا المنتج حاليا"), animated: true, completion: nil)
        }
    }
    @IBAction func infoAndDescriptionTapped(sender: UIButton){
        
        UIView.animate(withDuration: 0.5, animations: {
              sender.setTitleColor(UIColor(named: "very dark blue"), for: .normal)
                if sender == self.infoBtn{
                    self.descriptionBtn.setTitleColor(UIColor(named: "gray text"), for: .normal)
                    self.infoUnderline.backgroundColor = UIColor(named: "dark Magenta")
                    self.descriptionUnderline.backgroundColor = nil
                    self.descriptionlabel.isHidden = true
                    self.infoStack.isHidden = false
                }else{
                    self.infoBtn.setTitleColor(UIColor(named: "gray text"), for: .normal)
                    self.infoUnderline.backgroundColor = nil
                    self.descriptionUnderline.backgroundColor = UIColor(named: "dark Magenta")
                    self.descriptionlabel.isHidden = false
                    self.infoStack.isHidden = true
                }
             }
        )
    }
    fileprivate func updateTableConstrainst(){
        infoTableView.layoutIfNeeded()
        infoTableViewHeight.constant = infoTableView.contentSize.height
    }
    fileprivate func setupHorizontalScrollView(){
        horizontalScrollView = UIScrollView(frame: .init(x: 0, y: 0, width: view.frame.width, height: 280))
        horizontalScrollView.delegate = self
        horizontalScrollView.isPagingEnabled = true
        horizontalScrollView.showsHorizontalScrollIndicator = false
        horizontalScrollView.showsVerticalScrollIndicator = false
        topView.addSubview(horizontalScrollView)
        let items = HorizontalItemList(inView: self.topView,arrangedSubviews: productDetails?.images ?? [])
        horizontalScrollView.addSubview(items)
        items.fillSuperview()
        
        pageControl.numberOfPages = productDetails?.images?.count ?? 0
        pageControl.subviews.forEach {
            $0.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }
    }
    override func viewDidLayoutSubviews() {
        pageControl.subviews.forEach {
            $0.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }
    }
    
    fileprivate func setData(){
        details.text = "\(productDetails?.brand?.name ?? "") \(productDetails?.name ?? "") \(productDetails?.concentration?.name ?? "")"
        if productDetails?.types?.count ?? 0 > 0{
            type.text = productDetails?.types?[0].name ?? ""
            infoType.text = ":   "+(productDetails?.types?[0].name ?? "لم يحدد")
        }
        if productDetails?.genders?.count ?? 0 > 0{
            gender.text = productDetails?.genders?[0].name ?? ""
        }
        if productDetails?.prices?.count ?? 0 > 0{
            discount.text = (productDetails?.prices?[selectedSizeIndex].discount ?? "0.0").replacingOccurrences(of: ".00", with: "")+"%"
            price.text = productDetails?.prices?[selectedSizeIndex].price ?? "0.0"
            priceAfterDiscount.text = getPriceAfterDiscount(price: productDetails?.prices?[selectedSizeIndex].price ?? "0", discount: productDetails?.prices?[selectedSizeIndex].discount ?? "0")
            selectedSizeId = productDetails?.prices?[selectedSizeIndex].id ?? 0
        }
        infoBrand.text = ":   "+(productDetails?.brand?.name ?? "لم يحدد")
        infoGender.text = ":   "+collectTypes()
        infoConcentration.text = ":   "+(productDetails?.concentration?.name ?? "لم يحدد")
        descriptionlabel.text = productDetails?.productDescription ?? "لا يوجد وصف حاليا"
    }
    func collectTypes() -> String{
        var str = ""
        for x in productDetails?.genders ?? []{
            str += x.name ?? ""
            str += ", "
        }
        if str != ""{
            str.popLast()
            str.popLast()
        }else{
            str = "لم يحدد"
        }
        return str
    }
}
extension perfumeDetails: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == RelatedCollection {
            return RelatedProducts.count
        }
        return productDetails?.prices?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == RelatedCollection {
             return CGSize(width: (collectionView.frame.size.width-20-10)/1.7, height: 350)
        }
        let size = productDetails?.prices?[indexPath.row].size ?? ""
        let width: CGFloat = size.widthOfString(usingFont: UIFont(name: "SefidUI-Bold", size: 14)!)
        return CGSize(width: width+50, height: 44)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == RelatedCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "perfumeResults", for: indexPath) as! perfumeResultsCell
            
            let cellData = self.RelatedProducts[indexPath.row]
            
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
        
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sizes", for: indexPath) as! sizeCell
            
            cell.size.text = productDetails?.prices?[indexPath.row].size ?? ""
            if productDetails?.prices?[indexPath.row].id ?? 0 == self.selectedSizeId {
                cell.backgroundColor = UIColor(named: "dark Magenta")
            }else{
                cell.backgroundColor = UIColor(named: "gray text")
            }
            
            if indexPath.row == 0 && selectedSizeIndex == 0{
                cell.backgroundColor = UIColor(named: "dark Magenta")
            }
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if collectionView == RelatedCollection {
            let storyboard = UIStoryboard(name: "perfumeDetails", bundle: nil)
            let linkingVC = storyboard.instantiateViewController(withIdentifier: "perfumeDetails")  as! UINavigationController
            let VC = linkingVC.viewControllers[0] as! perfumeDetails
            VC.productDetails = RelatedProducts[indexPath.row]
            self.navigationController?.pushViewController(VC, animated: true)
        }else{
            self.selectedSizeIndex = indexPath.row
            self.setData()
            collectionView.reloadData()
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 10, bottom: 0, right: 10)
    }
    
}
extension perfumeDetails: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == horizontalScrollView{
            let pagWidth = scrollView.bounds.width
            pageControl.currentPage = Int(scrollView.contentOffset.x / pagWidth)
        }
    }
}
extension perfumeDetails: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productDetails?.fields?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "info", for: indexPath) as! infoCell
        cell.key.text = productDetails?.fields?[indexPath.row].name ?? ""
        cell.value.text = collectText(values: productDetails?.fields?[indexPath.row].values ?? [])
        cell.value.numberOfLines = 0
        
        return cell
    }
    func collectText(values: [Value]) -> String{
        var result = ""
        for item in values{
            result += (item.value ?? "") + ", "
        }
        if result != ""{
            result.popLast()
            result.popLast()
        }
        return result
    }
}
