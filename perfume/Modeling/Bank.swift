//
//  Bank.swift
//  ezhelhaa
//
//  Created by Bassam Ramadan on 3/27/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import Foundation
struct Banks: Codable {
    let code: Int?
    let message: String?
    let data: [bankAccount]?
    
    init(code: Int, message: String, data: [bankAccount]?) {
        self.code = code
        self.message = message
        self.data = data
    }
}
struct bankAccount: Codable {
    init(bankName: String?, bankUsername: String?, bankNumber: String?, bankIban: String?,bankLogo: String?,id: Int?) {
        self.bankName = bankName
        self.bankUsername = bankUsername
        self.bankNumber = bankNumber
        self.bankIban = bankIban
        self.bankLogo = bankLogo
        self.id = id
    }
    let id: Int?
    let bankName,bankUsername,bankNumber,bankIban,bankLogo: String?
    enum CodingKeys: String,CodingKey{
        case bankLogo = "bank_logo_path"
        case bankName = "bank_name"
        case bankUsername = "bank_username"
        case bankNumber = "bank_account_number"
        case bankIban = "bank_iban"
        case id
    }
}
