//
//  CreateUser.swift
//  
//
//  Created by Denis Dmitriev on 27.06.2023.
//

import Fluent

struct CreateUser: AsyncMigration {
    typealias Key = User.Key
    
    func prepare(on database: FluentKit.Database) async throws {
        try await database.schema(User.schema)
            .id()
            .field(Key.login.fieldKey, .string, .required)
            .unique(on: Key.login.fieldKey)
            .field(Key.name.fieldKey, .string, .required)
            .field(Key.lastname.fieldKey, .string, .required)
            .field(Key.password.fieldKey, .string, .required)
            .field(Key.email.fieldKey, .string, .required)
            .field(Key.gender.fieldKey, .string, .required)
            .field(Key.creditCard.fieldKey, .string, .required)
            .field(Key.bio.fieldKey, .string, .required)
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema(User.schema).delete()
    }
}
