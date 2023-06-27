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
    
    @Field(key: "login") var login: String
    @Field(key: "name") var name: String
    @Field(key: "lastname") var lastname: String
    @Field(key: "password") var password: String
    @Field(key: "email") var email: String
    @Field(key: "gender") var gender: String
    @Field(key: "credit_card") var creditCard: String
    @Field(key: "bio") var bio: String
    
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