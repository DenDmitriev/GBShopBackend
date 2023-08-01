//
//  Receipt.swift
//  
//
//  Created by Denis Dmitriev on 24.07.2023.
//

import Vapor

struct ReceiptResult: Content {
    let result: Int
    let receipt: [ReceiptItem]?
    let total: Double
    let error: String?
}

