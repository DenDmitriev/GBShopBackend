//
//  PaymentResult.swift
//  
//
//  Created by Denis Dmitriev on 24.07.2023.
//

import Vapor

struct PaymentResult: Content {
    let result: Int
    let receipt: [ReceiptItem]?
    let total: Double?
    let errorMessage: String?
    
    init(result: Int,
         receipt: [ReceiptItem]? = nil,
         total: Double? = nil,
         errorMessage: String? = nil) {
        self.result = result
        self.receipt = receipt
        self.total = total
        self.errorMessage = errorMessage
    }
}
