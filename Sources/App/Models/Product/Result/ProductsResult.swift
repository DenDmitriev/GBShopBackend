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
    let products: [Product.Public]?
    let errorMessage: String?
    let metadata: Metadata?
    
    init(result: Int,
         page: Int? = nil,
         products: [Product.Public]? = nil,
         errorMessage: String? = nil,
         metadata: Metadata? = nil) {
        self.result = result
        self.page = page
        self.products = products
        self.errorMessage = errorMessage
        self.metadata = metadata
    }
}
