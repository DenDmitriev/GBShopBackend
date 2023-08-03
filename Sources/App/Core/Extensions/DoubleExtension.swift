//
//  File.swift
//  
//
//  Created by Denis Dmitriev on 03.08.2023.
//

import Foundation

extension Double {
    typealias Percent = Int
    
    /// Calculate discounted price
    /// - Parameter Discount: Int value in percent
    /// - Returns: Discounted price
    func discount(_ discount: Percent) -> Self {
        let part = 1 - Decimal(discount) / 100
        let result = part * Decimal(self)
        return NSDecimalNumber(decimal: result).doubleValue
    }
}
