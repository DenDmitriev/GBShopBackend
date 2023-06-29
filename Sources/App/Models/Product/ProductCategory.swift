//
//  File.swift
//  
//
//  Created by Denis Dmitriev on 29.06.2023.
//

import Fluent
import Vapor

final class ProductCategory: Model, Content, Codable {
    static let schema = "products_category"
    static let productPerPage: Int = 10
    
    @ID(key: .id) var id: UUID?
    
    @Field(key: Keys.name.fieldKey) var name: String
    @Field(key: Keys.description.fieldKey) var description: String
    
    @Children(for: \.$category) var products: [Product]
    
    enum Keys: String {
        case name
        case description
        
        var fieldKey: FieldKey {
            return FieldKey(stringLiteral: self.rawValue)
        }
    }
}
