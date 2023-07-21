//
//  GetReviewsRequest.swift
//  
//
//  Created by Denis Dmitriev on 05.07.2023.
//

import Vapor

struct GetReviewsRequest: Content {
    let productID: UUID
    let page: Int
    let per: Int
}
