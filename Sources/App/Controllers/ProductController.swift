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
        products.get("all", use: all)
        products.get("category", use: category)
        products.post("add", use: add)
        products.post("update", use: update)
        products.group(":id") { product in
            product.get(use: self.product)
            product.delete(use: delete)
        }
    }
    
    /// Products by page
    ///
    /// Path method get http://api/products/all
    /// - Parameter page: Int page number
    /// - Returns: ProductsResult model with value result: Int, page: Int, products: [Product]
    func all(req: Request) async throws -> ProductsResult {
        let productsRequest = try req.query.decode(ProductsRequest.self)
        let page = productsRequest.page
        let products = try await Product.query(on: req.db).all()
        let perPage = ProductCategory.productPerPage
        
        guard products.count >= page * perPage else {
            return .init(result: 0, errorMessage: "Количество товаров меньше чем страниц.")
        }
        let productsOnPage = sliceProducts(products: products, page: page, perPage: perPage)
//            .map { ProductsResult.ProductResult.fubric($0) }
        return .init(result: 1, page: page, products: productsOnPage)
    }
    
    /// Products by page from category
    ///
    /// Path method get http://api/products/category
    /// - Parameter page: Int page number
    /// - Parameter category: UUID of category
    /// - Returns: ProductsResult model with value result: Int, page: Int, products: [Product]
    func category(req: Request) async throws -> ProductsResult {
        let productsRequest = try req.query.decode(ProductsByCategoryRequest.self)
        let page = productsRequest.page
        let categoryID = productsRequest.category
        
        guard let category = try await ProductCategory.find(categoryID, on: req.db) else {
            return .init(result: 0, errorMessage: "Такой категории товаров не существует.")
        }
        
        let products = try await category.$products.get(on: req.db)
        
        guard !products.isEmpty else {
            return .init(result: 0, errorMessage: "Не удалось найти товары в категории \(category.name)")
        }
        
        let perPage = ProductCategory.productPerPage
        
        guard products.count >= page * perPage else {
            return .init(result: 0, errorMessage: "Количество товаров меньше чем страниц.")
        }
        
        let productsOnPage = sliceProducts(products: products, page: page, perPage: perPage)
//            .map { ProductsResult.ProductResult.fubric($0) }
        
        return .init(result: 1, page: page, products: productsOnPage)
    }
    
    /// Product by id
    ///
    /// Path method get http://api/products/<product_id>
    /// - Parameter id: UUID of product
    /// - Returns: ProductResult model with value result: Int, product: Product.
    func product(req: Request) async throws -> ProductResult {
        guard
            let request = req.parameters.get("id"),
            let id = UUID(uuidString: request)
        else {
            throw Abort(.badRequest)
        }
        
        guard let product = try await Product.find(id, on: req.db) else {
            return .init(result: 0, errorMessage: "Такого товара не существует.")
        }
        
        return .init(result: 1, product: product)
    }
    
    /// Add new product method to category
    ///
    /// Path method post http://api/products/add
    /// - Parameter id: UUID of product
    /// - Parameter name: Name of product
    /// - Parameter price: Price product
    /// - Parameter description: Description product
    /// - Parameter categoryID: ID category for product
    /// - Returns: AddProductResult with value result: Int.
    func add(req: Request) async throws -> AddProductResult {
        let productRequest = try req.content.decode(AddProductRequest.self)
        let categoryID = productRequest.categoryID
        guard
            let category = try await ProductCategory.find(categoryID, on: req.db)
        else {
            return .init(result: 0, errorMessage: "Такой категории товаров не существует.")
        }
        guard ((try await Product.find(productRequest.id, on: req.db)) == nil) else {
            return .init(result: 0, errorMessage: "Такой товар уже существует.")
        }
        let product = Product(id: productRequest.id,
                              name: productRequest.name,
                              price: productRequest.price,
                              description: productRequest.description,
                              categoryID: category.id)
        try await product.create(on: req.db)
        return .init(result: 1)
    }
    
    /// Update product method
    ///
    /// Path method post http://api/products/update
    /// - Parameter id: UUID of product
    /// - Parameter name: Name of product
    /// - Parameter price: Price product
    /// - Parameter description: Description product
    /// - Parameter categoryID: ID category for product
    /// - Returns: AddProductResult with value result: Int.
    func update(req: Request) async throws -> UpdateProductResult {
        let productRequest = try req.content.decode(AddProductRequest.self)
        guard let product = try await Product.find(productRequest.id, on: req.db) else {
            return .init(result: 0, errorMessage: "Такого продукта не существует.")
        }
        product.name = productRequest.name
        product.price = productRequest.price
        product.description = productRequest.description
        product.$category.id = productRequest.categoryID
        try await product.save(on: req.db)
        return .init(result: 1)
    }
    
    /// Delete product by id
    ///
    /// Path method delete http://api/products/<product_id>
    /// - Returns: HTTPStatus
    func delete(req: Request) async throws -> HTTPStatus {
        guard let product = try await Product.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await product.delete(on: req.db)
        return .noContent
    }
    
    // MARK: - Private functions
    
    private func sliceProducts(products: [Product], page: Int, perPage: Int) -> [Product] {
        guard products.count >= page * perPage else {
            return []
        }
        
        let startIndex = page * perPage
        var endIndex = startIndex + perPage
        if endIndex > products.count {
            endIndex = products.count
        }
        let slice = products[startIndex..<endIndex]
        let productsOnPage = Array(slice)
        return productsOnPage
    }
}
