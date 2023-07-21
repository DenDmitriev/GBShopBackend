//
//  GetBasketRequest.swift
//  
//
//  Created by Denis Dmitriev on 07.07.2023.
//

import Vapor

struct GetBasketRequest: Content {
    let userID: UUID
}
