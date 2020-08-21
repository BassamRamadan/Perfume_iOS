//
//  HomeCell.swift
//  perfume
//
//  Created by Bassam Ramadan on 4/17/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import UIKit

class HomeCell: UITableViewCell {

    @IBOutlet var title: UIButton!
    @IBOutlet var arrow: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


}
class HomeCollectionCell: UICollectionViewCell {
    
    @IBOutlet var genderName: UILabel!
    @IBOutlet var genderImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
class newResultsCell: UITableViewCell {
    @IBOutlet var quantity: UILabel!
    @IBOutlet var size: UILabel!
    @IBOutlet var gender: UILabel!
    @IBOutlet var type: UILabel!
    @IBOutlet var title: UILabel!
    @IBOutlet var imagePath: UIImageView!
    @IBOutlet var price: UILabel!
    @IBOutlet var priceAfterDiscount: UILabel!
    @IBOutlet var discount: UILabel!
    @IBOutlet var AddToCart: UIButton!
    @IBOutlet var removeItem: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
