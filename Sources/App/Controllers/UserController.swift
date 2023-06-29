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
        users.get("all", use: index)
        users.post("register", use: register)
        users.post("update", use: update)
        users.post("authorization", use: auth)
        users.post("logout", use: logout)
        
        users.group(":id") { user in
            user.get(use: show)
            user.put(use: update)
            user.delete(use: delete)
        }
    }
    
    /// All users get func
    ///
    /// Path method post http://api/users/all
    /// - Returns: All users in Array Users models
    func index(req: Request) async throws -> [User] {
        try await User.query(on: req.db).all()
    }
    
    /// Get user func by id
    ///
    /// Path method get http://api/users/<user_id>
    /// - Returns: User model
    func show(req: Request) async throws -> User {
        guard let id = req.parameters.get("id") else {
            throw Abort(.internalServerError)
        }
        let user = try await User.find(UUID(id), on: req.db)
            .unwrap(or: Abort(.notFound))
            .get()
        return user
    }
    
    /// Dekete user func by id
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
    /// - Parameter id: UUID user
    /// - Parameter login: String login of user
    /// - Parameter name: String name of user
    /// - Parameter lastname: String lastname of user
    /// - Parameter password: String password of user
    /// - Parameter email: String email of user
    /// - Parameter gender: String gender of user
    /// - Parameter creditCard: String number credit card of user
    /// - Parameter bio: String bio of user
    /// - Returns: RegisterUserResult model with value result: Int, userMessage: String
    func register(req: Request) async throws -> RegisterUserResult {
        let user = try req.content.decode(User.self)
        if ((try await User.find(user.id, on: req.db)) != nil) {
            return .init(result: .zero, errorMessage: "Пользователь уже зарегистрирован.")
        }
        if let user = try await User.query(on: req.db)
            .filter(\.$login == user.login)
            .first() {
            return .init(result: .zero, errorMessage: "Пользователь с логином \(user.login) уже существует. Выберите другой.")
        }
        try await user.save(on: req.db)
        return RegisterUserResult(result: 1, userMessage: "Регистрация \(user.name) прошла успешно!")
    }
    
    /// Update user func
    ///
    /// Path method post http://api/users/update or put http://api/users/<user_id>
    ///
    /// - Parameter id: UUID user for find in database. This value can't update
    /// - Parameter login: String login of user
    /// - Parameter name: String name of user
    /// - Parameter lastname: String lastname of user
    /// - Parameter password: String password of user
    /// - Parameter email: String email of user
    /// - Parameter gender: String gender of user
    /// - Parameter creditCard: String number credit card of user
    /// - Parameter bio: String bio of user
    /// - Returns: ChangeUserDataResult model with value result: Int
    func update(req: Request) async throws -> ChangeUserDataResult {
        let updatedUser = try req.content.decode(User.self)
//        guard let user = try await User.find(req.parameters.get("id"), on: req.db) else {
//            throw Abort(.notFound)
//        }
        guard
            let user = try await User.find(updatedUser.id, on: req.db)
        else {
            throw Abort(.notFound)
        }
        user.login = updatedUser.login
        user.name = updatedUser.name
        user.lastname = updatedUser.lastname
        user.password = updatedUser.password
        user.email = updatedUser.email
        user.gender = updatedUser.gender
        user.creditCard = updatedUser.creditCard
        user.bio = updatedUser.bio
        try await user.update(on: req.db)
        return .init(result: 1)
    }
    
    /// Authorization in customer service user func
    ///
    /// Path method post http://api/users/authorization
    ///
    /// - Parameter login: String login of user
    /// - Parameter password: String password of user
    /// - Returns: LoginResult model with value result: Int, user: User.
    func auth(req: Request) async throws -> LoginResult {
        let loginRequest = try req.content.decode(LoginRequest.self)
        guard let user = try await User.query(on: req.db)
            .filter(\.$login == loginRequest.login)
            .filter(\.$password == loginRequest.password)
            .first()
        else {
            return .init(result: .zero, errorMessage: "Неверный логин или пароль пользователя.")
        }
        // TODO: add auth func in Customer Service
        return .init(result: 1, user: user)
    }
    
    /// Logout from customer service user func
    ///
    /// Path method post http://api/users/logout
    ///
    /// - Parameter id: UUID of user
    /// - Returns: LogoutResult model with value result: Int.
    func logout(req: Request) async throws -> LogoutResult {
//        let logoutRequest = try req.content.decode(LogoutRequest.self)
//        let userID = logoutRequest.id
//        guard let user = try await User.find(userID, on: req.db) else {
//            throw Abort(.notFound)
//        }
        // TODO: add logout func in Customer Service
        return .init(result: 1)
    }
}
