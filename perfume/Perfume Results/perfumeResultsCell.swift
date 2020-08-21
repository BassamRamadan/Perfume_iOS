//
//  perfumeResultsCell.swift
//  perfume
//
//  Created by Bassam Ramadan on 6/21/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import UIKit

class perfumeResultsCell: UICollectionViewCell {
    
    @IBOutlet var gender: UILabel!
    @IBOutlet var type: UILabel!
    @IBOutlet var title: UILabel!
    @IBOutlet var imagePath: UIImageView!
    @IBOutlet var price: UILabel!
    @IBOutlet var priceAfterDiscount: UILabel!
    @IBOutlet var discount: UILabel!
    @IBOutlet var AddToCart: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
class noDataCell: UICollectionViewCell {
    
    @IBOutlet var noData: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
