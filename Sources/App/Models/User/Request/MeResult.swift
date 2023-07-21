//
//  File.swift
//  
//
//  Created by Denis Dmitriev on 04.07.2023.
//

import Vapor

struct MeResult: Content {
    let result: Int
    let user: User.Public?
    let errorMessage: String?
    
    init(result: Int, user: User.Public? = nil, errorMessage: String? = nil) {
        self.result = result
        self.user = user
        self.errorMessage = errorMessage
    }
}
