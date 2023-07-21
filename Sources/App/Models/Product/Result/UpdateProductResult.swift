//
//  UpdateProductResult.swift
//  
//
//  Created by Denis Dmitriev on 30.06.2023.
//

import Vapor

struct UpdateProductResult: Content {
    let result: Int
    let errorMessage: String?
    
    init(result: Int,
         errorMessage: String? = nil) {
        self.result = result
        self.errorMessage = errorMessage
    }
}
