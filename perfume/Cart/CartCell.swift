//
//  CartCell.swift
//  perfume
//
//  Created by Bassam Ramadan on 6/21/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import UIKit


class CartCell: UITableViewCell{
    
    @IBOutlet var gender: UILabel!
    @IBOutlet var type: UILabel!
    @IBOutlet var title: UILabel!
    @IBOutlet var size: UILabel!
    @IBOutlet var imagePath: UIImageView!
    @IBOutlet var quantity: UILabel!
    @IBOutlet var price: UILabel!
    @IBOutlet var priceAfterDiscount: UILabel!
    
    @IBOutlet var delet: UIButton!
    @IBOutlet var edit: UIButton!
    
    @IBOutlet var plus: UIButton!
    @IBOutlet var minus: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
