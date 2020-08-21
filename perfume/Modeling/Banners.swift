//
//  Banners.swift
//  perfume
//
//  Created by Bassam Ramadan on 5/13/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import Foundation

// MARK: - Welcome
class Banners: Codable {
    let code: Int?
    let message: String?
    let data: [BannerDetails]?
    
    init(code: Int?, message: String?, data: [BannerDetails]?) {
        self.code = code
        self.message = message
        self.data = data
    }
}

// MARK: - Datum
class BannerDetails: Codable {
    let id: Int?
    let description, discount: String?
    let imagePath: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case description = "description"
        case discount
        case imagePath = "image_path"
    }
    
    init(id: Int?, description: String?, discount: String?, imagePath: String?) {
        self.id = id
        self.description = description
        self.discount = discount
        self.imagePath = imagePath
    }
}
