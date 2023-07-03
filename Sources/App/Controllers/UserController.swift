//
//  UserController.swift
//  
//
//  Created by Denis Dmitriev on 27.06.2023.
//

import Fluent
import Vapor

struct UserController: RouteCollection {
    func boot(routes: Vapor.RoutesBuilder) throws {
        let users = routes.grouped("users")
        users.post("register", use: register)
        users.post("update", use: update)
        
        users.group(":id") { user in
            user.get(use: self.user)
            user.put(use: update)
            user.delete(use: delete)
        }
    }
    
    /// Get user func by id
    ///
    /// Path method get http://api/users/<user_id>
    /// - Returns: User model
    func user(req: Request) async throws -> User {
        guard let id = req.parameters.get("id") else {
            throw Abort(.internalServerError)
        }
        let user = try await User.find(UUID(id), on: req.db)
            .unwrap(or: Abort(.notFound))
            .get()
        return user
    }
    
    /// Delete user func by id
    ///
    /// Path method delete http://api/users/<user_id>
    /// - Returns: HTTPStatus
    func delete(req: Request) async throws -> HTTPStatus {
        guard let user = try await User.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await user.delete(on: req.db)
        return .noContent
    }
    
    /// Registration new user func
    ///
    /// Path method post http://api/users/register
    ///
    /// - Parameter name: String name of user
    /// - Parameter password: String password of user
    /// - Parameter confirmPassword: String confirmPassword of user
    /// - Parameter email: String email of user
    /// - Parameter creditCard: String number credit card of user
    /// - Returns: RegisterUserResult model with value result: Int, userMessage: String
    func register(req: Request) async throws -> RegisterUserResult {
        do {
            try User.Create.validate(content: req)
        } catch let error {
            guard let validationsError = error as? Vapor.ValidationsError else {
                return .init(result: 0, errorMessage: error.localizedDescription)
            }
            return .init(result: 0, errorMessage: validationsError.description)
        }
        
        let create = try req.content.decode(User.Create.self)
        
        guard create.password == create.confirmPassword else {
            return .init(result: 0, errorMessage: "Пароль и пароль подтверждения не совпадают.")
        }
        
        guard
            try await User.query(on: req.db)
                .filter(\.$email == create.email)
                .first() == nil
        else {
            return .init(result: .zero, errorMessage: "Пользователь с email \(create.email) уже существует. Выберите другой.")
        }
        
        let user = try User(name: create.name,
                            passwordHash: Bcrypt.hash(create.password),
                            email: create.email,
                            creditCard: create.creditCard)
        try await user.save(on: req.db)
        return RegisterUserResult(result: 1,
                                  userID: user.id?.uuidString,
                                  userMessage: "Регистрация \(user.name) прошла успешно!")
    }
    
    /// Update user func
    ///
    /// Update witput password
    /// Path method post http://api/users/update or put http://api/users/<user_id>
    ///
    /// - Parameter id: UUID user for find in database. This value can't update
    /// - Parameter email: String email of user
    /// - Parameter password: String password of user
    /// - Parameter confirmPassword: String confirmPassword of user
    /// - Parameter creditCard: String number credit card of user
    /// - Returns: ChangeUserDataResult model with value result: Int
    func update(req: Request) async throws -> ChangeUserDataResult {
        do {
            try User.Update.validate(content: req)
        } catch let error {
            guard let validationsError = error as? Vapor.ValidationsError else {
                return .init(result: 0, errorMessage: error.localizedDescription)
            }
            return .init(result: 0, errorMessage: validationsError.description)
        }
        
        let update = try req.content.decode(User.Update.self)
        
        guard
            let user = try await User.find(update.id, on: req.db)
        else {
            return .init(result: 0, errorMessage: "Пользователь не найден.")
        }
        
        user.name = update.name
        user.email = update.email
        user.creditCard = update.creditCard
        
        try await user.update(on: req.db)
        
        return .init(result: 1, user: user)
    }
}
