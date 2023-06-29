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
    
    @Parent(key: Key.category.fieldKey) var category: ProductCategory
    
    enum Key: String {
        case id
        case name
        case price
        case description
        case category = "category_id"
        
        var fieldKey: FieldKey {
            return FieldKey(stringLiteral: self.rawValue)
        }
    }
    
    init() {}
    
    init(id: UUID? = nil,
         name: String,
         price: Float,
         description: String,
         categoryID: ProductCategory.IDValue) {
        self.id = id
        self.name = name
        self.price = price
        self.description = description
        self.$category.id = categoryID
    }
}
