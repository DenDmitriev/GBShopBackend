//
//  Metadata.swift
//  
//
//  Created by Denis Dmitriev on 05.07.2023.
//

import Vapor

struct Metadata: Content {
    let page: Int
    let per: Int
    let total: Int
}
