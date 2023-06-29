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
    
    @Field(key: Key.login.fieldKey) var login: String
    @Field(key: Key.name.fieldKey) var name: String
    @Field(key: Key.lastname.fieldKey) var lastname: String
    @Field(key: Key.password.fieldKey) var password: String
    @Field(key: Key.email.fieldKey) var email: String
    @Field(key: Key.gender.fieldKey) var gender: String
    @Field(key: Key.creditCard.fieldKey) var creditCard: String
    @Field(key: Key.bio.fieldKey) var bio: String
    
    enum Key: String {
        case id = "id"
        case login = "login"
        case name = "name"
        case lastname = "lastname"
        case password = "password"
        case email = "email"
        case gender = "gender"
        case creditCard = "credit_card"
        case bio = "bio"
        
        var fieldKey: FieldKey {
            return FieldKey(stringLiteral: self.rawValue)
        }
    }
    
    init() { }
    
    init(id: UUID? = nil,
         login: String,
         name: String,
         lastname: String,
         password: String,
         email: String,
         gender: String,
         creditCard: String,
         bio: String) {
        self.id = id
        self.login = login
        self.name = name
        self.lastname = lastname
        self.password = password
        self.email = email
        self.gender = gender
        self.creditCard = creditCard
        self.bio = bio
    }
}
