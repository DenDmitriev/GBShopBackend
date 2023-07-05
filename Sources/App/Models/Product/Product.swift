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
    
    @OptionalParent(key: Key.category.fieldKey) var category: ProductCategory?
    @Children(for: \.$product) var reviews: [Review]
    
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
         categoryID: UUID? = nil) {
        self.id = id
        self.name = name
        self.price = price
        self.description = description
        self.$category.id = categoryID
    }
}

extension Product {
    struct Public: Content {
        let id: UUID?
        let name: String
        let price: Float
        let description: String
        let categoryID: UUID?
        
        static func makePublicProduct(_ product: Product) -> Public {
            return Public(id: product.id,
                          name: product.name,
                          price: product.price,
                          description: product.description,
                          categoryID: product.id)
        }
    }
}
