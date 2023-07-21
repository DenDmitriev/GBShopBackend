//
//  BasketResult.swift
//  
//
//  Created by Denis Dmitriev on 07.07.2023.
//

import Vapor

struct BasketResult: Content {
    let result: Int
    let basket: Basket.Public?
    let errorMessage: String?
    
    init(result: Int,
         basket: Basket.Public? = nil,
         errorMessage: String? = nil) {
        self.result = result
        self.basket = basket
        self.errorMessage = errorMessage
    }
}
