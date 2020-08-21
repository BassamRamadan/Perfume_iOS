//
//  signUp.swift
//  perfume
//
//  Created by Bassam Ramadan on 5/17/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import Foundation

// MARK: - Welcome
class SignUp : Codable{
    let code: Int?
    let message: String?
    let data: SignUpData?
    
    init(code: Int?, message: String?, data: SignUpData?) {
        self.code = code
        self.message = message
        self.data = data
    }
}

// MARK: - DataClass
class SignUpData : Codable{
    let username, email, createdAt: String?
    let id: Int?
    let accessToken,firebase,status: String?
    let imagePath: String?
    
    enum CodingKeys: String, CodingKey {
        case username, email
        case createdAt = "created_at"
        case id,firebase,status
        case accessToken = "access_token"
        case imagePath = "image_path"
    }
    
    init(username: String?, email: String?, createdAt: String?, id: Int?, accessToken: String?, imagePath: String?,firebase: String?,status: String?) {
        self.username = username
        self.email = email
        self.createdAt = createdAt
        self.id = id
        self.accessToken = accessToken
        self.imagePath = imagePath
        self.status = status
        self.firebase = firebase
    }
}
