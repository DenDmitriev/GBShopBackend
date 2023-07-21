//
//  DeleteReviewResult.swift
//  
//
//  Created by Denis Dmitriev on 05.07.2023.
//

import Vapor

struct DeleteReviewResult: Content {
    let result: Int
    let errorMessage: String?
    
    init(result: Int,
         errorMessage: String? = nil) {
        self.result = result
        self.errorMessage = errorMessage
    }
}
