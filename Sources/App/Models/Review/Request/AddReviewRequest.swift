//
//  AddReviewRequest.swift
//  
//
//  Created by Denis Dmitriev on 05.07.2023.
//

import Vapor

struct AddReviewRequest: Content {
    let userID: UUID
    let review: String
    let productID: UUID
    let rating: Int
}
