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
    
    @Field(key: CodingKeys.login.fieldKey) var login: String
    @Field(key: CodingKeys.name.fieldKey) var name: String
    @Field(key: CodingKeys.lastname.fieldKey) var lastname: String
    @Field(key: CodingKeys.password.fieldKey) var password: String
    @Field(key: CodingKeys.email.fieldKey) var email: String
    @Field(key: CodingKeys.gender.fieldKey) var gender: String
    @Field(key: CodingKeys.creditCard.fieldKey) var creditCard: String
    @Field(key: CodingKeys.bio.fieldKey) var bio: String
    
    enum CodingKeys: String, CodingKey {
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
            return FieldKey(stringLiteral: self.stringValue)
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
