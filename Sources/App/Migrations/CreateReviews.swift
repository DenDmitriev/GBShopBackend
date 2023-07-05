//
//  CreateReviews.swift
//  
//
//  Created by Denis Dmitriev on 05.07.2023.
//

import Fluent

struct CreateReviews: AsyncMigration {
    typealias Key = Review.Key
    
    func prepare(on database: Database) async throws {
        try await database.schema(Review.schema)
            .id()
            .field(Key.user.fieldKey, .uuid, .required)
            .field(Key.product.fieldKey, .uuid, .required)
            .field(Key.value.fieldKey, .string, .required)
            .field(Key.rating.fieldKey, .int8, .required)
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema(Review.schema).delete()
    }
}
