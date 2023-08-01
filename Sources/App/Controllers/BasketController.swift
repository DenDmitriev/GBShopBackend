//
//  BasketController.swift
//  
//
//  Created by Denis Dmitriev on 07.07.2023.
//

import Vapor
import Fluent

struct BasketController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let baskets = routes.grouped("baskets")
        baskets.get("get", use: getBasket)
        baskets.post("add", use: addToBasket)
        baskets.post("delete", use: deleteFromBasket)
        baskets.post("payment", use: payment)
    }
    
    /**
     Add product to user basket
     
     Post method by path  http://api/baskets/add
     - Parameter userID: UUID of user
     - Parameter productID: UUID product
     - Parameter count: count products
     - Returns: `UpdateBasketResult` model
     */
    func addToBasket(req: Request) async throws -> UpdateBasketResult {
        let addToBasketRequest = try req.content.decode(UpdateBasketRequest.self)
        guard
            let user = try await User.find(addToBasketRequest.userID, on: req.db)
        else {
            return .init(result: 0, errorMessage: "Пользователь не найден.")
        }
        let productIDs = [Product.IDValue](repeating: addToBasketRequest.productID,
                                           count: addToBasketRequest.count)
        
        if try await user.$basket.get(on: req.db) == nil {
            try await createBasket(with: productIDs, for: user, on: req.db)
        } else {
            try await updateBasket(with: addToBasketRequest.productID, for: user, with: .add, on: req.db)
        }
        
        return .init(result: 1, userMessage: "Товар успешно добавлен в корзину.")
    }
    
    /**
     Delete product from user basket
     
     Post method by path  http://api/baskets/delete
     - Parameter userID: UUID of user
     - Parameter productID: UUID product
     - Parameter count: count products
     - Returns: `UpdateBasketResult` model
     */
    func deleteFromBasket(req: Request) async throws -> UpdateBasketResult {
        let deleteFromBasketRequest = try req.content.decode(UpdateBasketRequest.self)
        guard
            let user = try await User.find(deleteFromBasketRequest.userID, on: req.db)
        else {
            return .init(result: 0, errorMessage: "Пользователь не найден.")
        }
        
        try await updateBasket(with: deleteFromBasketRequest.productID, for: user, with: .delete, on: req.db)
        
        return .init(result: 1, userMessage: "Товар успешно удален из корзины.")
    }
    
    /**
     Get user basket
     
     Get method by path  http://api/baskets/get
     - Parameter userID: UUID of user
     - Returns: `BasketResult` model
     */
    func getBasket(req: Request) async throws -> BasketResult {
        let getBasketRequest = try req.query.decode(GetBasketRequest.self)
        guard let user = try await User.find(getBasketRequest.userID, on: req.db)
        else {
            return .init(result: 0, errorMessage: "Пользователь не найден.")
        }
        guard let basket = try await user.$basket.get(on: req.db)
        else {
            return .init(result: 0, errorMessage: "У пользователя корзины нет.")
        }
        
        let basketPublic = try await makeBasketPublic(from: basket, on: req.db)
        return .init(result: 1, basket: basketPublic)
    }
    
    /**
     Payment user basket
     
     Post method by path  http://api/baskets/payment
     - Parameter userID: UUID of user
     - Returns: `PaymentResult` model
     */
    func payment(req: Request) async throws -> PaymentResult {
        let paymentRequest = try req.content.decode(PaymentBasketRequest.self)
        guard
            let user = try await User.find(paymentRequest.userID, on: req.db),
            let basket = try await user.$basket.get(on: req.db)
        else {
            return .init(result: .zero, errorMessage: "Basket is empty")
        }
        
        let order = try await createOrder(from: basket, in: req.db)
        let totalPrice = try await totalPrice(for: basket, in: req.db)
        let totalWithDiscount = totalPrice.calculateDiscountPrice()
        
        let orderService = OrderService(database: req.db)
        let paymentResult = try orderService.payment(user: user, order: order, total: totalWithDiscount)
        
        return .init(result: paymentResult.result,
                     receipt: paymentResult.receipt,
                     total: paymentResult.total,
                     errorMessage: paymentResult.error)
    }
    
    // MARK: Private Functions
    
    private func createOrder(from basket: Basket, in database: Database) async throws -> [Product: Int] {
        var order: [Product: Int] = [:]
        
        for productID in basket.products {
            let product = try await Product.find(productID, on: database)
            guard let product = product else { continue }
            if var count = order[product] {
                count += 1
                order[product] = count
            } else {
                order[product] = 1
            }
        }
        
        return order
    }
    
    private enum Action {
        case add, delete
    }
    
    private func updateBasket(with productID: Product.IDValue,
                              for user: User,
                              with action: Action,
                              on database: Database) async throws {
        
        let basket = try await user.$basket.get(on: database)
        switch action {
        case .add:
            basket?.products.append(productID)
        case .delete:
            if let index = basket?.products.firstIndex(of: productID) {
                basket?.products.remove(at: index)
            }
        }
        
        try await basket?.update(on: database)
    }
    
    
    private func createBasket(with productIDs: [Product.IDValue],
                              for user: User,
                              on database: Database) async throws {
        guard let userID = user.id
        else {
            throw Abort(.notFound)
        }
        let basket = Basket(productIDs: productIDs, userID: userID, discount: .zero)
        try await user.$basket.create(basket, on: database)
    }
    
    private func makeBasketPublic(from basket: Basket, on database: Database) async throws -> Basket.Public {
        let total = try await totalPrice(for: basket, in: database)
        
        var products: [Product] = []
        for productID in basket.products {
            if let product = try await Product.find(productID, on: database) {
                products.append(product)
            }
        }
        let publicProduct = products.map { product in
            Product.Public.makePublicProduct(product)
        }
        
        return Basket.Public(userID: basket.$user.id,
                      products: publicProduct,
                      total: total)
    }
    
    private func totalPrice(for basket: Basket, in database: Database) async throws -> Price {
        var total: Decimal = .zero
        var notAvailable: [Product.IDValue] = []
        for id in basket.products {
            do {
                if let product = try await Product.find(id, on: database) {
                    total += Decimal(product.price)
                } else {
                    notAvailable.append(id)
                }
            } catch let error {
                print(error.localizedDescription)
                continue
            }
        }
        
        try await removeNotAvailable(products: notAvailable, from: basket, in: database)
        
        let totalDouble = NSDecimalNumber(decimal: total)
            .doubleValue
        
        let basketPrice = Price(price: totalDouble, discount: basket.discount)
        
        return basketPrice
    }
    
    private func removeNotAvailable(products: [Product.IDValue],
                                    from basket: Basket,
                                    in database: Database) async throws {
        products.forEach { id in
            basket.products.removeAll { $0 == id }
        }
        try await basket.update(on: database)
    }
}
