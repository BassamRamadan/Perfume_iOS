//
//  taxClass.swift
//  perfume
//
//  Created by Bassam Ramadan on 6/27/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import Foundation

// MARK: - Welcome
class Taxing: Codable {
    let code: Int?
    let message: String?
    let data: items?
    
    init(code: Int?, message: String?, data: items?) {
        self.code = code
        self.message = message
        self.data = data
    }
}
class items: Codable {
    let items: taxData?
    init(items: taxData?) {
        self.items = items
    }
}
// MARK: - Items
class taxData: Codable {
    let id: Int?
    let shipping, tax, phone, whatsapp: String?
    let createdAt: String?
    let updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id, shipping, tax, phone, whatsapp
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    init(id: Int?, shipping: String?, tax: String?, phone: String?, whatsapp: String?, createdAt: String?, updatedAt: String?) {
        self.id = id
        self.shipping = shipping
        self.tax = tax
        self.phone = phone
        self.whatsapp = whatsapp
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
