//
//  Product.swift
//  
//
//  Created by Denis Dmitriev on 26.06.2023.
//

import Fluent
import Vapor

final class Product: Model, Content, Codable {
    static let schema = "products"
    
    @ID(key: .id) var id: UUID?
    
    @Field(key: "name") var name: String
    @Field(key: "price") var price: Float
    @Field(key: "description") var description: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case price
        case description
    }
    
    init() {}
    
    init(id: UUID? = nil, name: String, price: Float, description: String) {
        self.id = id
        self.name = name
        self.price = price
        self.description = description
    }
}
