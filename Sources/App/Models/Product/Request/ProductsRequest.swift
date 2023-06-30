//
//  ProductsRequest.swift
//  
//
//  Created by Denis Dmitriev on 30.06.2023.
//

import Vapor

struct ProductsRequest: Content {
    let page: Int
}
