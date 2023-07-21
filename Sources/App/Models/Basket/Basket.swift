//
//  Basket.swift
//  
//
//  Created by Denis Dmitriev on 07.07.2023.
//

import Vapor
import Fluent

final class Basket: Model, Content {
    static let schema = "baskets"
    
    @ID(key: .id) var id: UUID?
    
    @Field(key: Keys.products.fieldKey) var products: [Product.IDValue]
    @Field(key: Keys.discount.fieldKey) var discount: Int
    
    @Parent(key: Keys.user.fieldKey) var user: User
    
    enum Keys: String {
        case products
        case user = "user_id"
        case discount
        
        var fieldKey: FieldKey {
            return FieldKey(stringLiteral: self.rawValue)
        }
        
        var validationKey: ValidationKey {
            return ValidationKey(stringLiteral: self.rawValue)
        }
    }
    
    init() {}
    
    init(id: UUID? = nil,
         productIDs: [Product.IDValue]?,
         userID: User.IDValue,
         discount: Int?) {
        self.id = id
        self.products = productIDs ?? []
        self.$user.id = userID
        self.discount = discount ?? .zero
    }
}

extension Basket: Validatable {
    static func validations(_ validations: inout Vapor.Validations) {
        validations.add(Keys.discount.validationKey, as: Int.self, is: .range(0...100))
    }
}

extension Basket {
    struct Public: Content {
        let userID: UUID
        let products: [Product.Public]
        let total: Price
    }
}
