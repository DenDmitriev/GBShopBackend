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
    let products: [ProductResult]?
    let errorMessage: String?
    
    init(result: Int,
         page: Int? = nil,
         products: [ProductResult]? = nil,
         errorMessage: String? = nil) {
        self.result = result
        self.page = page
        self.products = products
        self.errorMessage = errorMessage
    }
    
    struct ProductResult: Codable {
        let id: UUID?
        let name: String
        let price: Float
        
        static func fubric(_ product: Product) -> ProductResult {
            return ProductResult(id: product.id, name: product.name, price: product.price)
        }
    }
}
