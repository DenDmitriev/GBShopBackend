//
//  LogoutResult.swift
//  GBShop
//
//  Created by Denis Dmitriev on 23.06.2023.
//

import Vapor

struct LogoutResult: Content {
    let result: Int
    let errorMessage: String?
    
    init(result: Int, errorMessage: String? = nil) {
        self.result = result
        self.errorMessage = errorMessage
    }
}
