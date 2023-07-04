//
//  File.swift
//  
//
//  Created by Denis Dmitriev on 29.06.2023.
//

import Fluent

struct CreateProduct: AsyncMigration {
    typealias Key = Product.Key
    
    func prepare(on database: Database) async throws {
        try await database.schema(Product.schema)
            .id()
            .field(Key.category.fieldKey, .uuid)
            .field(Key.name.fieldKey, .string, .required)
            .field(Key.price.fieldKey, .float, .required)
            .field(Key.description.fieldKey, .string, .required)
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema(Product.schema).delete()
    }
}
