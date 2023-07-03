//
//  ProductsResult.swift
//  
//
//  Created by Denis Dmitriev on 29.06.2023.
//

import Vapor

struct ProductsResult: Content {
    let result: Int
    let page: Int?
    let products: [Product]?
    let errorMessage: String?
    
    init(result: Int,
         page: Int? = nil,
         products: [Product]? = nil,
         errorMessage: String? = nil) {
        self.result = result
        self.page = page
        self.products = products
        self.errorMessage = errorMessage
    }
}
