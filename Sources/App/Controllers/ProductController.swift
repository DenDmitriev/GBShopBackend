//
//  ProductController.swift
//  
//
//  Created by Denis Dmitriev on 29.06.2023.
//

import Fluent
import Vapor

struct ProductController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let products = routes.grouped("products")
        products.get("categories", use: categories)
        products.get("category", use: productsByCategory)
        products.get("product", use: product)
    }
    
    /// Products by page from category
    ///
    /// Path method get http://api/products/category
    /// - Parameter page: Int page number
    /// - Parameter category: UUID of category
    /// - Returns: ProductsResult model with value result: Int, page: Int, products: [Product]
    func productsByCategory(req: Request) async throws -> ProductsResult {
        let productsRequest = try req.query.decode(ProductsRequest.self)
        let page = productsRequest.page
        let categoryID = productsRequest.category
        
        guard let category = try await ProductCategory.find(categoryID, on: req.db) else {
            return .init(result: 0, errorMessage: "Такой категории товаров не существует.")
        }
        
        let products = try await category.$products.get(on: req.db)
        
        guard !products.isEmpty else {
            return .init(result: 0, errorMessage: "Не удалось найти товары в категории \(category.name)")
        }
        
        let productPerPage = ProductCategory.productPerPage
        
        guard products.count >= page * productPerPage else {
            return .init(result: 0, errorMessage: "Количество товаров меньше чем страниц.")
        }
        
        let startIndex = page * productPerPage
        var endIndex = startIndex + productPerPage
        if endIndex > products.count {
            endIndex = (products.count - 1)
        }
        let slice = products[startIndex..<endIndex]
        let productsOnPage = Array(slice)
            .map { ProductsResult.ProductResult.fubric($0) }
        
        return .init(result: 1, page: page, products: productsOnPage)
    }
    
    /// Product by id
    ///
    /// Path method get http://api/products/product
    /// - Parameter id: UUID of product
    /// - Returns: ProductResult model with value result: Int, product: Product.
    func product(req: Request) async throws -> ProductResult {
        let productRequest = try req.query.decode(ProductRequest.self)
        let productId = productRequest.id
        
        guard let product = try await Product.find(productId, on: req.db) else {
            return .init(result: 0, errorMessage: "Такого товара не существует.")
        }
        
        return .init(result: 1, product: product)
    }
    
    /// Categories
    ///
    /// Path method get http://api/products/categories
    /// - Returns: All Categories array
    func categories(req: Request) async throws -> [ProductCategory] {
        try await ProductCategory.query(on: req.db).all()
    }
}
