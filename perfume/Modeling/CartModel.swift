//
//  CartModel.swift
//  perfume
//
//  Created by Bassam Ramadan on 6/21/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import Foundation

// MARK: - Welcome
class CartModel: Codable {
    let code: Int?
    let message: String?
    let data: CartData?
    
    init(code: Int?, message: String?, data: CartData?) {
        self.code = code
        self.message = message
        self.data = data
    }
}

// MARK: - DataClass
class CartData: Codable {
    let cartID: Int?
    let totalCost: String?
    let items: [Item]?
    
    enum CodingKeys: String, CodingKey {
        case cartID = "cart_id"
        case totalCost, items
    }
    
    init(cartID: Int?, totalCost: String?, items: [Item]?) {
        self.cartID = cartID
        self.totalCost = totalCost
        self.items = items
    }
}

// MARK: - Item
class Item: Codable {
    let id: Int?
    let productID, cartID, size, price: String?
    let discount, quantity: String?
    let product: Product?
    
    enum CodingKeys: String, CodingKey {
        case id
        case productID = "product_id"
        case cartID = "cart_id"
        case size, price, discount, quantity, product
    }
    
    init(id: Int?, productID: String?, cartID: String?, size: String?, price: String?, discount: String?, quantity: String?, product: Product?) {
        self.id = id
        self.productID = productID
        self.cartID = cartID
        self.size = size
        self.price = price
        self.discount = discount
        self.quantity = quantity
        self.product = product
    }
}

// MARK: - Product
class Product: Codable {
    let id: Int?
    let name, image, productDescription, views: String?
    let status: Bool?
    let categoryID, brandID, concentrationID: String?
    let imagePath: String?
    let images: [Image]?
    let types: [Concentration]?
    let genders: [Brand]?
    let brand: Brand?
    let concentration: Concentration?
    let prices: [Price]?
    let fields: [FieldsData]?
    let pivot: pivotData?
    enum CodingKeys: String, CodingKey {
        case id, name, image
        case productDescription = "description"
        case views, status
        case categoryID = "category_id"
        case brandID = "brand_id"
        case concentrationID = "concentration_id"
        case imagePath = "image_path"
        case fields = "product_fields"
        case images, types, genders, brand, concentration, prices , pivot
    }
    
    init(id: Int?, name: String?, image: String?, productDescription: String?, views: String?, status: Bool?, categoryID: String?, brandID: String?, concentrationID: String?, imagePath: String?, images: [Image]?, types: [Concentration]?, genders: [Brand]?, brand: Brand?, concentration: Concentration?, prices: [Price]?, fields: [FieldsData]?,pivot: pivotData?) {
        self.id = id
        self.name = name
        self.image = image
        self.productDescription = productDescription
        self.views = views
        self.status = status
        self.categoryID = categoryID
        self.brandID = brandID
        self.concentrationID = concentrationID
        self.imagePath = imagePath
        self.images = images
        self.types = types
        self.genders = genders
        self.brand = brand
        self.concentration = concentration
        self.prices = prices
        self.fields = fields
        self.pivot = pivot
    }
}

// MARK: - Brand
class Brand: Codable {
    let id: Int?
    let name: String?
    let imagePath: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case imagePath = "image_path"
    }
    
    init(id: Int?, name: String?, imagePath: String?) {
        self.id = id
        self.name = name
        self.imagePath = imagePath
    }
}

// MARK: - Concentration
class Concentration: Codable {
    let id: Int?
    let name: String?
    
    init(id: Int?, name: String?) {
        self.id = id
        self.name = name
    }
}

// MARK: - Image
class Image: Codable {
    let id: Int?
    let productID: String?
    let imagePath: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case productID = "product_id"
        case imagePath = "image_path"
    }
    
    init(id: Int?, productID: String?, imagePath: String?) {
        self.id = id
        self.productID = productID
        self.imagePath = imagePath
    }
}

// MARK: - Price
class Price: Codable {
    let id: Int?
    let productID, size, price, discount: String?
    let createdAt, updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case productID = "product_id"
        case size, price, discount
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    init(id: Int?, productID: String?, size: String?, price: String?, discount: String?, createdAt: String?, updatedAt: String?) {
        self.id = id
        self.productID = productID
        self.size = size
        self.price = price
        self.discount = discount
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

class pivotData: Codable{
    let quantity: String?
    init(quantity: String?) {
        self.quantity = quantity
    }
}
