//
//  File.swift
//  
//
//  Created by Denis Dmitriev on 28.06.2023.
//

import Vapor

struct LoginRequest: Content {
    let email: String
    let password: String
}
