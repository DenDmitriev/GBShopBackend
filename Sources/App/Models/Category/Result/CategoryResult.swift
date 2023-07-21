//
//  CategoryResult.swift
//  
//
//  Created by Denis Dmitriev on 30.06.2023.
//

import Vapor

struct CategoryResult: Content {
    let result: Int
    let category: Category?
    let errorMessage: String?
    
    init(result: Int,
         category: Category? = nil,
         errorMessage: String? = nil) {
        self.result = result
        self.category = category
        self.errorMessage = errorMessage
    }
}
