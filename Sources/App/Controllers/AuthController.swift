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
    
    /**
     Check authorization user func
     
     The function is waiting for a request :

            GET /me HTTP/1.1
            Host: <API_URL>
            Authorization: Bearer <Token>
     
     - Returns: If the user token is valid, sends the result with the `MeResult` model.
     */
    func me(req: Request) async throws -> MeResult {
        let user = try req.auth.require(User.self)
        return .init(result: 1, user: User.Public(from: user))
    }
    
    /**
     Authorization in customer service user func
     
     The function is waiting for a request:
     
            POST /login HTTP/1.1
            Host: <API_URL>
            Authorization: Basic <Data>
     
     - Parameter Username: some@mail.com
     - Parameter Password: password
     
     - Returns: If authorization is successful, then the function sends `LoginResult` model.
     */
    func login(req: Request) async throws -> LoginResult {
        guard let user = req.auth.get(User.self) else {
            return .init(result: .zero, errorMessage: "Неверный логин или пароль пользователя.")
        }
        let token = try user.generateToken()
        try await token.save(on: req.db)
        let login = User.Login(from: user, with: token.value)
        
        return .init(result: 1, user: login)
    }
    
    /**
     Logout from customer service
     
     Remove token and cache user. Post method http://api/logout:
     
     - Parameter id: UUID of user
     - Returns: `LogoutResult` model with value result: Int.
     */
    func logout(req: Request) async throws -> LogoutResult {
        let logoutRequest = try req.query.decode(LogoutRequest.self)
        let id = logoutRequest.id
        
        guard
            let user = try await User.find(id, on: req.db),
            let userID = user.id
        else {
            return .init(result: 0, errorMessage: "Пользователь не зарегистрирован.")
        }
        
        try await UserToken.query(on: req.db)
            .filter(\.$user.$id == userID)
            .delete()
        
        req.auth.logout(User.self)
        
        return .init(result: 1)
    }
}
