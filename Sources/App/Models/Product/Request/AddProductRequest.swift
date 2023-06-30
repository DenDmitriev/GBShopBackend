//
//  AddProductRequest.swift
//  
//
//  Created by Denis Dmitriev on 30.06.2023.
//

import Vapor

struct AddProductRequest: Content {
    let id: UUID
    let name: String
    let price: Float
    let description: String
    let categoryID: UUID?
}
