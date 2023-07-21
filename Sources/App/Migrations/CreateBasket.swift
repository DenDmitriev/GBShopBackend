//
//  CreateBasket.swift
//  
//
//  Created by Denis Dmitriev on 07.07.2023.
//

import Fluent

struct CreateBasket: AsyncMigration {
    typealias Key = Basket.Keys
    
    func prepare(on database: Database) async throws {
        try await database.schema(Basket.schema)
            .id()
            .field(Key.products.fieldKey, .array(of: .uuid), .required)
            .field(Key.discount.fieldKey, .int8, .required)
            .field(Key.user.fieldKey, .uuid, .required, .references(User.schema, "id"))
            .unique(on: Key.user.fieldKey)
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema(Basket.schema).delete()
    }
}
