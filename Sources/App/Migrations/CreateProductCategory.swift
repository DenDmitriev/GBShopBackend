//
//  CreateProductCategory.swift
//  
//
//  Created by Denis Dmitriev on 29.06.2023.
//

import Fluent

struct CreateProductCategory: AsyncMigration {
    typealias Key = ProductCategory.Keys
    
    func prepare(on database: FluentKit.Database) async throws {
        try await database.schema(ProductCategory.schema)
            .id()
            .field(Key.name.fieldKey, .string, .required)
            .field(Key.description.fieldKey, .string, .required)
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema(ProductCategory.schema).delete()
    }
    
}
