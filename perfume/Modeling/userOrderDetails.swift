//
//  OrderDetails.swift
//  perfume
//
//  Created by Bassam Ramadan on 5/18/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import Foundation
// MARK: - Welcome
class userOrderDetails: Codable {
    let code: Int?
    let message: String?
    let data: OrderDetailsData?
    
    init(code: Int?, message: String?, data: OrderDetailsData?) {
        self.code = code
        self.message = message
        self.data = data
    }
}

// MARK: - DataClass
class OrderDetailsData: Codable {
    let id: Int?
    let userID, cartID, lat, lon: String?
    let name, phone, area, buildingNumber: String?
    let flatNumber: String?
    let promoCode: String?
    let paymentType: String?
    let receiptImage: String?
    let status, taxValue, shippingValue, promoCodeValue: String?
    let totalCost, datumCreatedAt, createdAt, receiptImagePath: String?
    let products: [productsData]?
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case cartID = "cart_id"
        case lat, lon, name, phone, area
        case buildingNumber = "building_number"
        case flatNumber = "flat_number"
        case promoCode = "promo_code"
        case paymentType = "payment_type"
        case receiptImage = "receipt_image"
        case status , products
        case taxValue = "tax_value"
        case shippingValue = "shipping_value"
        case promoCodeValue = "promo_code_value"
        case totalCost = "total_cost"
        case datumCreatedAt = "created_at"
        case createdAt
        case receiptImagePath = "receipt_image_path"
    }
    
    init(id: Int?, userID: String?, cartID: String?, lat: String?, lon: String?, name: String?, phone: String?, area: String?, buildingNumber: String?, flatNumber: String?, promoCode: String?, paymentType: String?, receiptImage: String?, status: String?, taxValue: String?, shippingValue: String?, promoCodeValue: String?, totalCost: String?, datumCreatedAt: String?, createdAt: String?, receiptImagePath: String?,products: [productsData]?) {
        self.id = id
        self.userID = userID
        self.cartID = cartID
        self.lat = lat
        self.lon = lon
        self.name = name
        self.phone = phone
        self.area = area
        self.buildingNumber = buildingNumber
        self.flatNumber = flatNumber
        self.promoCode = promoCode
        self.paymentType = paymentType
        self.receiptImage = receiptImage
        self.status = status
        self.taxValue = taxValue
        self.shippingValue = shippingValue
        self.promoCodeValue = promoCodeValue
        self.totalCost = totalCost
        self.datumCreatedAt = datumCreatedAt
        self.createdAt = createdAt
        self.receiptImagePath = receiptImagePath
        self.products = products
    }
}
class productsData: Codable {
    
    let id: Int?
    let productId,cartId,size,price,discount,quantity: String?
    let product: Product?
    
    enum CodingKeys: String, CodingKey {
        case id,size,price,discount,quantity,product
        case productId = "product_id"
        case cartId = "cart_id"
    }
    
    
    init(id: Int?, productId: String?, cartId: String?, size: String?, price: String?, discount: String?, quantity: String?, product: Product?) {
        self.id = id
        self.productId = productId
        self.cartId = cartId
        self.size = size
        self.price = price
        self.discount = discount
        self.quantity = quantity
        self.product = product
    }
}
