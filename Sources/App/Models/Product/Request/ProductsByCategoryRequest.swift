//
//  ProductsRequest.swift
//  
//
//  Created by Denis Dmitriev on 29.06.2023.
//

import Vapor

struct ProductsByCategoryRequest: Content {
    let page: Int
    let per: Int
    let category: UUID?
}
