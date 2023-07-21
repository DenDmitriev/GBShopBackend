//
//  RegisterUserResult.swift
//  GBShop
//
//  Created by Denis Dmitriev on 23.06.2023.
//

import Vapor

struct RegisterUserResult: Content {
    let result: Int
    let userID: String?
    let userMessage: String?
    let errorMessage: String?
    
    init(result: Int,
         userID: String? = nil,
         userMessage: String? = nil,
         errorMessage: String? = nil) {
        self.result = result
        self.userID = userID
        self.userMessage = userMessage
        self.errorMessage = errorMessage
    }
}
