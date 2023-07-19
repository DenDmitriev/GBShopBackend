//
//  File.swift
//  
//
//  Created by Denis Dmitriev on 26.06.2023.
//

import Fluent
import Vapor

final class User: Model, Content, Codable {
    static let schema = "users"
    
    @ID(key: .id) var id: UUID?
    
    @Field(key: Key.name.fieldKey) var name: String
    @Field(key: Key.passwordHash.fieldKey) var passwordHash: String
    @Field(key: Key.email.fieldKey) var email: String
    @Field(key: Key.creditCard.fieldKey) var creditCard: String
    
    @OptionalChild(for: \.$user) var basket: Basket?
    @Children(for: \.$user) var reviews: [Review]
    
    enum Key: String {
        case id = "id"
        case name = "name"
        case passwordHash = "password_hash"
        case email = "email"
        case creditCard = "credit_card"
        
        var fieldKey: FieldKey {
            return FieldKey(stringLiteral: self.rawValue)
        }
    }
    
    init() { }
    
    init(id: UUID? = nil,
         name: String,
         passwordHash: String,
         email: String,
         creditCard: String) {
        self.id = id
        self.name = name
        self.passwordHash = passwordHash
        self.email = email
        self.creditCard = creditCard
    }
}

extension User {
    struct Public: Content {
        var id: UUID?
        var name: String
        var email: String
        var creditCard: String
        
        init(from user: User) {
            self.id = user.id
            self.name = user.name
            self.email = user.email
            self.creditCard = user.creditCard
        }
    }
    
    struct Login: Content {
        var id: UUID?
        var name: String
        var email: String
        var creditCard: String
        var token: String
        
        init(from user: User, with token: String) {
            self.id = user.id
            self.name = user.name
            self.email = user.email
            self.creditCard = user.creditCard
            self.token = token
        }
    }
    
    struct Create: Content {
        var name: String
        var email: String
        var password: String
        var confirmPassword: String
        var creditCard: String
    }
    
    struct Update: Content {
        var id: UUID
        var name: String
        var email: String
        var creditCard: String
    }
}

extension User.Create: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("name", as: String.self, is: !.empty)
        validations.add("email", as: String.self, is: .email)
        validations.add("password", as: String.self, is: .count(8...))
        validations.add("creditCard", as: String.self, is: .count(14...16) && .alphanumeric)
    }
}

extension User.Update: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("name", as: String.self, is: !.empty)
        validations.add("email", as: String.self, is: .email)
        validations.add("creditCard", as: String.self, is: .count(14...16) && .alphanumeric)
    }
}

extension User: ModelAuthenticatable {
    static let usernameKey = \User.$email
    static let passwordHashKey = \User.$passwordHash
    
    func verify(password: String) throws -> Bool {
        try Bcrypt.verify(password, created: self.passwordHash)
    }
}

extension User {
    func generateToken() throws -> UserToken {
        let calendar = Calendar(identifier: .gregorian)
        let expiryDate = calendar.date(byAdding: .day, value: 1, to: Date())
        
        return try .init(
            value: [UInt8].random(count: 16).base64,
            userID: self.requireID(),
            expiresAt: expiryDate
        )
    }
}
