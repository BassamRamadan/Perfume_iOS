//
//  Products.swift
//  perfume
//
//  Created by Bassam Ramadan on 6/21/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import Foundation

// MARK: - Welcome
class Products: Codable {
    let code: Int?
    let message: String?
    let data: ProductsData?
    
    init(code: Int?, message: String?, data: ProductsData?) {
        self.code = code
        self.message = message
        self.data = data
        
    }
}

// MARK: - DataClass
class ProductsData: Codable {
    let products: [Product]?
    let nextPageUrl: String?
    enum CodingKeys: String, CodingKey {
        case products = "data"
        case nextPageUrl = "next_page_url"
    }
    init(products: [Product]?,nextPageUrl: String?) {
        self.products = products
        self.nextPageUrl = nextPageUrl
    }
}
class oneProduct: Codable {
    let code: Int?
    let message: String?
    let data: oneProductDetails?
    
    init(code: Int?, message: String?, data: oneProductDetails?) {
        self.code = code
        self.message = message
        self.data = data
    }
}
class oneProductDetails: Codable {
    let product: Product?
    init(product: Product?) {
        self.product = product
    }
}
