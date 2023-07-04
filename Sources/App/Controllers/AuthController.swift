//
//  AuthController.swift
//  
//
//  Created by Denis Dmitriev on 02.07.2023.
//

import Fluent
import Vapor

struct AuthController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let passwordProtected = routes.grouped(User.authenticator())
        passwordProtected.post("login", use: login)
        passwordProtected.post("logout", use: logout)
        
        let tokenProtected = routes.grouped(UserToken.authenticator())
        tokenProtected.get("me", use: me)
    }
    
    /// Check authorization user func
    ///
    /// Authorization: Bearer get method post http://api/me
    ///
    /// - Parameter token: user token
    /// - Returns: MeResult model
    func me(req: Request) async throws -> MeResult {
        let user = try req.auth.require(User.self)
        return .init(result: 1, user: User.Public(from: user))
    }
    
    /// Authorization in customer service user func
    ///
    /// Authorization: Basic post method post http://api/login
    ///
    /// - Parameter username: String email of user
    /// - Parameter password: String password of user
    /// - Returns: LoginResult model with value result: Int, user: User.
    func login(req: Request) async throws -> LoginResult {
        guard let user = req.auth.get(User.self) else {
            return .init(result: .zero, errorMessage: "Неверный логин или пароль пользователя.")
        }
        let token = try user.generateToken()
        try await token.save(on: req.db)
        let login = User.Login(from: user, with: token.value)
        
        return .init(result: 1, user: login)
    }
    
    /// Logout from customer service user func
    ///
    /// Post method post http://api/logout
    ///
    /// - Parameter id: UUID of user
    /// - Returns: LogoutResult model with value result: Int.
    func logout(req: Request) async throws -> LogoutResult {
        req.auth.logout(User.self)
        return .init(result: 1)
    }
}
