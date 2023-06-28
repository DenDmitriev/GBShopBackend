//
//  LogoutRequest.swift
//  
//
//  Created by Denis Dmitriev on 28.06.2023.
//

import Vapor

struct LogoutRequest: Content {
    let id: UUID
}
