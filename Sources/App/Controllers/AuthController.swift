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
    }
    
    /// Authorization in customer service user func
    ///
    /// Authorization: Basic post method post http://api/login
    ///
    /// - Parameter username: String email of user
    /// - Parameter password: String password of user
    /// - Returns: LoginResult model with value result: Int, user: User.
    func login(req: Request) async throws -> LoginResult {
        // try req.auth.require(User.self)
        guard let user = req.auth.get(User.self) else {
            return .init(result: .zero, errorMessage: "Неверный логин или пароль пользователя.")
        }
        return .init(result: 1, user: user)
    }
    
    /// Logout from customer service user func
    ///
    /// Post method post http://api/logout
    ///
    /// - Parameter id: UUID of user
    /// - Returns: LogoutResult model with value result: Int.
    func logout(req: Request) async throws -> LogoutResult {
        let logoutRequest = try req.content.decode(LogoutRequest.self)
        let userID = logoutRequest.id
        
        guard let user = try await User.find(userID, on: req.db) else {
            throw Abort(.notFound)
        }
        
        req.auth.logout(User.self)
        
        return .init(result: 1)
    }
}
