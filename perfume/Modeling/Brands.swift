//
//  Brands.swift
//  perfume
//
//  Created by Bassam Ramadan on 6/13/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import Foundation

// MARK: - Brands
class publicFiltering: Codable {
    let code: Int?
    let message: String?
    let data: [BrandsData]?
    
    init(code: Int?, message: String?, data: [BrandsData]?) {
        self.code = code
        self.message = message
        self.data = data
    }
}

// MARK: - BrandsData
class BrandsData: Codable {
    let id: Int?
    let name: String?
    let productsCount: Int?
    let imagePath: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, productsCount
        case imagePath = "image_path"
    }
    
    init(id: Int?, name: String?, productsCount: Int?, imagePath: String?) {
        self.id = id
        self.name = name
        self.productsCount = productsCount
        self.imagePath = imagePath
    }
}
