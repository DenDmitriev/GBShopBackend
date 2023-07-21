//
//  ChangeUserDataResult.swift
//  GBShop
//
//  Created by Denis Dmitriev on 23.06.2023.
//

import Vapor

struct ChangeUserDataResult: Content {
    let result: Int
    let user: User?
    let userMessage: String?
    let errorMessage: String?
    
    init(result: Int,
         user: User? = nil,
         userMessage: String? = nil,
         errorMessage: String? = nil) {
        self.result = result
        self.user = user
        self.userMessage = userMessage
        self.errorMessage = errorMessage
    }
}
