//
//  File.swift
//  
//
//  Created by Denis Dmitriev on 24.07.2023.
//

import Vapor

struct PaymentBasketRequest: Content {
    let userID: UUID
    let total: Double
}
