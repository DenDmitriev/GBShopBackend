//
//  File.swift
//  
//
//  Created by Denis Dmitriev on 03.07.2023.
//

import Fluent
import Vapor

final class UserToken: Model, Content {
    static let schema = "user_tokens"
    
    @ID(key: .id) var id: UUID?
    
    @Field(key: "value")  var value: String
    
    @Parent(key: "user_id") var user: User
    
    @Field(key: "expires_at") var expiresAt: Date?
    
    init() { }
    
    init(id: UUID? = nil, value: String, userID: User.IDValue, expiresAt: Date?) {
        self.id = id
        self.value = value
        self.$user.id = userID
        self.expiresAt = expiresAt
    }
}

extension UserToken {
    struct Migration: AsyncMigration {
        var name: String { "CreateUserToken" }
        
        func prepare(on database: Database) async throws {
            try await database.schema("user_tokens")
                .id()
                .field("value", .string, .required)
                .field("user_id", .uuid, .required, .references("users", "id"))
                .field("expires_at", .date, .required)
                .unique(on: "value")
                .create()
        }
        
        func revert(on database: Database) async throws {
            try await database.schema("user_tokens").delete()
        }
    }
}

extension UserToken: ModelTokenAuthenticatable {
    static let valueKey = \UserToken.$value
    static let userKey = \UserToken.$user
    
    var isValid: Bool {
        guard let expiryDate = expiresAt else {
            return true
        }
        
        return expiryDate > Date()
    }
}
