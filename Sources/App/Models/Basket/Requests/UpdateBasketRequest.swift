//
//  AddToBasketRequest.swift
//  
//
//  Created by Denis Dmitriev on 07.07.2023.
//

import Vapor

struct UpdateBasketRequest: Content {
    let userID: UUID
    let productID: UUID
    let count: Int
}
