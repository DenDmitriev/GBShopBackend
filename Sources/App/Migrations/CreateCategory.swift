//
//  CreateCategory.swift
//  
//
//  Created by Denis Dmitriev on 29.06.2023.
//

import Fluent

struct CreateCategory: AsyncMigration {
    typealias Key = Category.Keys
    
    func prepare(on database: FluentKit.Database) async throws {
        try await database.schema(Category.schema)
            .id()
            .field(Key.name.fieldKey, .string, .required)
            .field(Key.description.fieldKey, .string, .required)
            .unique(on: Key.name.fieldKey)
            .create()
    }
    
    func revert(on database: Database) async throws {
//        try await database.schema("products_category").delete()
        try await database.schema(Category.schema).delete()
    }
    
}
