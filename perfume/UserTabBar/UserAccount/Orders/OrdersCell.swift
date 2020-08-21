//
//  OrdersCell.swift
//  perfume
//
//  Created by Bassam Ramadan on 5/18/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import UIKit

class OrdersCell: UITableViewCell {
    @IBOutlet var totalCost: UILabel!
    @IBOutlet var createdAt: UILabel!
    @IBOutlet var status: UILabel!
    @IBOutlet var id: UILabel!
    @IBOutlet var icon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
