//
//  OrderService.swift
//  
//
//  Created by Denis Dmitriev on 24.07.2023.
//

import Vapor
import Fluent

class OrderService {
    
    let database: Database
    
    init(database: Database) {
        self.database = database
    }
    
    func payment(user: User, order: [Product: Int], total: Double) throws -> ReceiptResult {
        guard checkTotal(order: order, total: total) else { throw PaymentError.total }
        let receipt = order.map { product, count in
            let discountedPrice = product.price.discount(Int(product.discount))
            return ReceiptItem(name: product.name, count: count, price: discountedPrice)
        }
        let mockReceiptResult = ReceiptResult(result: 1, receipt: receipt, total: total, error: nil)
        if mockReceiptResult.result == 1 {
            removeBasket(of: user)
        }
        return mockReceiptResult
    }
    
    private func checkTotal(order: [Product: Int], total: Double) -> Bool {
        let checkTotal: Double = order.map { product, count in
            let priceForOne = product.price.discount(Int(product.discount))
            let price = Decimal(priceForOne) * Decimal(count)
            return NSDecimalNumber(decimal: price).doubleValue
        }.reduce(0) { partialResult, price in
            partialResult + price
        }
        print(total, checkTotal)
        
        return total == checkTotal
    }
    
    private func removeBasket(of user: User) {
        let _ = user.basket?.delete(on: database)
    }
}
