//
//  Price.swift
//  
//
//  Created by Denis Dmitriev on 07.07.2023.
//

import Vapor

struct Price: Content {
    let price: Double
    let discount: Int8
    
    init(price: Double,
         discount: Int) {
        self.price = price
        self.discount = Int8(discount)
    }
    
    func calculateDiscountPrice() -> Double {
        return price.discount(Int(discount))
    }
}
