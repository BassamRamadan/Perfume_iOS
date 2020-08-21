//
//  FavoriteClass.swift
//  perfume
//
//  Created by Bassam Ramadan on 6/25/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import Foundation

class FavoriteModel: Codable{
    let code: Int?
    let message: String?
    let data: [Product]?
    
    init(code: Int?, message: String?, data: [Product]?) {
        self.code = code
        self.message = message
        self.data = data
    }
}
