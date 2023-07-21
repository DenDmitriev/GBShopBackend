//
//  ProductCategory.swift
//  
//
//  Created by Denis Dmitriev on 29.06.2023.
//

import Fluent
import Vapor

final class Category: Model, Content, Codable {
    static let schema = "categories"
    
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
    
    init() { }
    
    init(id: UUID? = nil,
         name: String,
         description: String) {
        self.id = id
        self.name = name
        self.description = description
    }
}

extension Category {
    struct AddProductCategory: Content {
        let name: String
        let description: String
    }
}
