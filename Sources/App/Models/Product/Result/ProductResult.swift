//
//  ProductResult.swift
//  
//
//  Created by Denis Dmitriev on 29.06.2023.
//

import Vapor

struct ProductResult: Content {
    let result: Int
    let product: Product?
    let errorMessage: String?

    init(result: Int,
         product: Product? = nil,
         errorMessage: String? = nil) {
        self.result = result
        self.product = product
        self.errorMessage = errorMessage
    }
}
