//
//  Orders.swift
//  perfume
//
//  Created by Bassam Ramadan on 5/18/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import Foundation

// MARK: - Welcome
class userOrders: Codable {
    let code: Int?
    let message: String?
    let data: [OrdersData]?
    
    init(code: Int?, message: String?, data: [OrdersData]?) {
        self.code = code
        self.message = message
        self.data = data
    }
}

// MARK: - Datum
class OrdersData: Codable {
    let id: Int?
    let userID, cartID, lat, lon: String?
    let name, phone, area, buildingNumber: String?
    let flatNumber: String?
    let promoCode: String?
    let paymentType: String?
    let receiptImage: String?
    let status, totalCost, datumCreatedAt, createdAt: String?
    
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
        case status
        case totalCost = "total_cost"
        case datumCreatedAt = "created_at"
        case createdAt
    }
    
    init(id: Int?, userID: String?, cartID: String?, lat: String?, lon: String?, name: String?, phone: String?, area: String?, buildingNumber: String?, flatNumber: String?, promoCode: String?, paymentType: String?, receiptImage: String?, status: String?, totalCost: String?, datumCreatedAt: String?, createdAt: String?) {
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
        self.totalCost = totalCost
        self.datumCreatedAt = datumCreatedAt
        self.createdAt = createdAt
    }
}

