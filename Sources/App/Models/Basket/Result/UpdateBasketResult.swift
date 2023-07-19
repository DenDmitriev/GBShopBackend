//
//  AddToBasketResult.swift
//  
//
//  Created by Denis Dmitriev on 07.07.2023.
//

import Vapor

struct UpdateBasketResult: Content {
    let result: Int
    let userMessage: String?
    let errorMessage: String?
    
    init(result: Int,
         userMessage: String? = nil,
         errorMessage: String? = nil) {
        self.result = result
        self.userMessage = userMessage
        self.errorMessage = errorMessage
    }
}
