//
//  CreateUser.swift
//  
//
//  Created by Denis Dmitriev on 27.06.2023.
//

import Fluent

struct CreateUser: AsyncMigration {
    typealias FieldKeys = User.CodingKeys
    
    func prepare(on database: FluentKit.Database) async throws {
        try await database.schema(User.schema)
            .id()
            .field(FieldKeys.login.fieldKey, .string, .required)
            .field(FieldKeys.name.fieldKey, .string, .required)
            .field(FieldKeys.lastname.fieldKey, .string, .required)
            .field(FieldKeys.password.fieldKey, .string, .required)
            .field(FieldKeys.email.fieldKey, .string, .required)
            .field(FieldKeys.gender.fieldKey, .string, .required)
            .field(FieldKeys.creditCard.fieldKey, .string, .required)
            .field(FieldKeys.bio.fieldKey, .string, .required)
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema(User.schema).delete()
    }
}
