//
//  Receipt.swift
//  
//
//  Created by Denis Dmitriev on 24.07.2023.
//

import Vapor

struct ReceiptItem: Content {
    let name: String
    let count: Int
    let price: Double
}
