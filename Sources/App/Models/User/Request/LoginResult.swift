//
//  LoginResult.swift
//  GBShop
//
//  Created by Denis Dmitriev on 23.06.2023.
//

import Vapor

struct LoginResult: Content {
    let result: Int
    let user: User.Login?
    let errorMessage: String?
    
    init(result: Int, user: User.Login? = nil, errorMessage: String? = nil) {
        self.result = result
        self.user = user
        self.errorMessage = errorMessage
    }
}
