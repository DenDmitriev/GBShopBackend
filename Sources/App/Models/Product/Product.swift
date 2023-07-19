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
    
    @Field(key: Key.name.fieldKey) var name: String
    @Field(key: Key.price.fieldKey) var price: Double
    @Field(key: Key.discount.fieldKey) var discount: Int8
    @Field(key: Key.description.fieldKey) var description: String
    @Field(key: Key.image.fieldKey) var image: String
    
    @OptionalParent(key: Key.category.fieldKey) var category: Category?
    @Children(for: \.$product) var reviews: [Review]
    
    enum Key: String {
        case id
        case name
        case price
        case description
        case discount
        case image
        case category = "category_id"
        
        var fieldKey: FieldKey {
            return FieldKey(stringLiteral: self.rawValue)
        }
        
        var validationKey: ValidationKey {
            return ValidationKey(stringLiteral: self.rawValue)
        }
    }
    
    init() {}
    
    init(id: UUID? = nil,
         name: String,
         price: Double,
         discount: Int8?,
         description: String,
         image: String,
         categoryID: UUID? = nil) {
        self.id = id
        self.name = name
        self.price = price
        self.discount = discount ?? .zero
        self.description = description
        self.image = image
        self.$category.id = categoryID
    }
}

extension Product {
    struct Public: Content {
        let id: UUID?
        let name: String
        let price: Price
        let description: String
        let image: String
        let categoryID: UUID?
        
        static func makePublicProduct(_ product: Product) -> Public {
            return Public(id: product.id,
                          name: product.name,
                          price: Price(price: product.price,
                                       discount: Int(product.discount)),
                          description: product.description,
                          image: product.image,
                          categoryID: product.id)
        }
    }
    
    struct AddProduct: Content {
        let name: String
        let price: Double
        let discount: Int8
        let description: String
        let image: String
        let categoryID: UUID?
    }
    
    struct UpdateProduct: Content {
        let id: UUID
        let name: String
        let price: Double
        let discount: Int8
        let description: String
        let image: String
        let categoryID: UUID
    }
}

extension Product: Validatable {
    static func validations(_ validations: inout Vapor.Validations) {
        validations.add(Key.discount.validationKey, as: Int8.self, is: .range(0...100))
        validations.add(Key.image.validationKey, as: String.self, is: .url)
    }
}
