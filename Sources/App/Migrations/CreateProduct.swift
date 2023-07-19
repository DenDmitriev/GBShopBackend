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
            .field(Key.category.fieldKey, .uuid, .references(Category.schema, "id"))
            .field(Key.name.fieldKey, .string, .required)
            .field(Key.price.fieldKey, .double, .required)
            .field(Key.discount.fieldKey, .int8, .required)
            .field(Key.description.fieldKey, .string, .required)
            .field(Key.image.fieldKey, .string, .required)
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema(Product.schema).delete()
    }
}
