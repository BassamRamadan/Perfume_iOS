//
//  Fields.swift
//  perfume
//
//  Created by Bassam Ramadan on 6/13/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import Foundation

// MARK: - Welcome
class Fields: Codable {
    let code: Int?
    let message: String?
    let data: [FieldsData]?
    
    init(code: Int?, message: String?, data: [FieldsData]?) {
        self.code = code
        self.message = message
        self.data = data
    }
}

// MARK: - Datum
class FieldsData: Codable {
    let id: Int?
    let name: String?
    let values: [Value]?
    let fieldValue: Value?
    let field: FieldsData?
    enum CodingKeys: String, CodingKey {
        case fieldValue = "field_value"
        case values = "selected_values"
        case name , id , field
    }
    
    init(id: Int?, name: String?, values: [Value]?,fieldValue: Value? = nil,field: FieldsData? = nil) {
        self.id = id
        self.name = name
        self.values = values
        self.fieldValue = fieldValue
        self.field = field
    }
}

// MARK: - Value
class Value: Codable {
    let id: Int?
    let value: String?
    let productsCount: Int?
    init(id: Int?, value: String?,productsCount: Int? = nil) {
        self.id = id
        self.value = value
        self.productsCount = productsCount
    }
}
