//
//  CategoryResult.swift
//  
//
//  Created by Denis Dmitriev on 30.06.2023.
//

import Vapor

struct CategoryResult: Content {
    let result: Int
    let category: ProductCategory?
    let errorMessage: String?
    
    init(result: Int,
         category: ProductCategory? = nil,
         errorMessage: String? = nil) {
        self.result = result
        self.category = category
        self.errorMessage = errorMessage
    }
}
