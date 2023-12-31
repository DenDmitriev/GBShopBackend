//
//  Review.swift
//  
//
//  Created by Denis Dmitriev on 05.07.2023.
//

import Fluent
import Vapor

final class Review: Model, Content {
    static let schema = "reviews"
    
    @ID(key: .id) var id: UUID?
    
    @Field(key: Key.value.fieldKey) var value: String
    @Field(key: Key.rating.fieldKey) var rating: Int
    @Timestamp(key: Key.createdAt.fieldKey, on: .create) var createdAt: Date?
    
    @Parent(key: Key.user.fieldKey) var user: User
    @Parent(key: Key.product.fieldKey) var product: Product
    
    enum Key: String {
        case user = "user_id"
        case value
        case product = "product_id"
        case createdAt = "created_at"
        case rating
        
        var fieldKey: FieldKey {
            return FieldKey(stringLiteral: self.rawValue)
        }
    }
    
    init() {}
    
    init(id: UUID? = nil,
         value: String,
         userID: User.IDValue,
         productID: Product.IDValue,
         rating: Int) {
        self.id = id
        self.value = value
        self.rating = rating
        self.$user.id = userID
        self.$product.id = productID
    }
    
}

extension Review {
    struct Public: Content {
        let id: UUID?
        let reviewer: String
        let review: String
        let rating: Int
        let productID: UUID?
        let createdAt: Date?
        
        static func makePublicReviews(review: Review) -> Public {
            return .init(id: review.id,
                         reviewer: review.user.name,
                         review: review.value,
                         rating: review.rating,
                         productID: review.$product.id,
                         createdAt: review.createdAt)
        }
    }
    
    struct AddReview: Content {
        let userID: UUID
        let review: String
        let productID: UUID
        let rating: Int
    }
}

extension Review: Validatable {
    static func validations(_ validations: inout Vapor.Validations) {
        validations.add("rating", as: Int.self, is: .range(1...5))
        validations.add("value", as: String.self, is: .count(0...280))
    }
}
