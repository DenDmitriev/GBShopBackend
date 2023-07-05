//
//  GetReviewsResult.swift
//  
//
//  Created by Denis Dmitriev on 05.07.2023.
//

import Vapor

struct GetReviewsResult: Content {
    let result: Int
    let page: Int?
    let reviews: [Review.Public]?
    let errorMessage: String?
    
    init(result: Int,
         page: Int? = nil,
         reviews: [Review.Public]? = nil,
         errorMessage: String? = nil) {
        self.result = result
        self.page = page
        self.reviews = reviews
        self.errorMessage = errorMessage
    }
}
