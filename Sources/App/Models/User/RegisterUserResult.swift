//
//  RegisterUserResult.swift
//  GBShop
//
//  Created by Denis Dmitriev on 23.06.2023.
//

import Vapor

struct RegisterUserResult: Content {
    let result: Int
    let userMessage: String?
    let errorMessage: String?
    
    init(result: Int, userMessage: String? = nil, errorMessage: String? = nil) {
        self.result = result
        self.userMessage = userMessage
        self.errorMessage = errorMessage
    }
}
