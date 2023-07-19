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
        products.get("category", use: category)
        products.post("add", use: add)
        products.post("update", use: update)
        products.group(":id") { product in
            product.get(use: self.product)
            product.delete(use: delete)
        }
    }
    
    /**
     Products by page from category
     
     Path method get http://api/products/category
     - Parameter page: Int page numbers start at 1
     - Parameter per: Int element per page
     - Parameter category: UUID of category
     - Returns: ProductsResult model with value result: Int, page: Int, products: [Product]
     */
    func category(req: Request) async throws -> ProductsResult {
        let productsRequest = try req.query.decode(ProductsByCategoryRequest.self)

        let categoryID = productsRequest.category
        
        guard let category = try await Category.find(categoryID, on: req.db) else {
            return .init(result: 0, errorMessage: "Такой категории товаров не существует.")
        }
        
        let per = productsRequest.per
        let page = productsRequest.page
        let products = try await category.$products
            .query(on: req.db)
            .page(withIndex: page, size: per)
        
        let publicProducts = products
            .map { Product.Public.makePublicProduct($0) }
            .items
        
        let total = try await category.$products.get(on: req.db).count
        let metadata = Metadata(page: page, per: per, total: total)
        
        return .init(result: 1, page: page, products: publicProducts, metadata: metadata)
    }
    
    /**
     Product by id
     
     Path method get http://api/products/<product_id>
     - Parameter id: UUID of product
     - Returns: ProductResult model with value result: Int, product: Product.
     */
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
    
    /**
     Add new product method to category
     
     Path method post http://api/products/add
     - Parameter id: UUID of product
     - Parameter name: Name of product
     - Parameter price: Double type price product
     - Parameter discount: Int8 Price discount
     - Parameter description: Description product
     - Parameter categoryID: ID category for product
     - Returns: AddProductResult with value result: Int.
     */
    func add(req: Request) async throws -> AddProductResult {
        let addProduct = try req.content.decode(Product.AddProduct.self)
        
        let categoryID = addProduct.categoryID
        guard let category = try await Category.find(categoryID, on: req.db)
        else {
            return .init(result: 0, errorMessage: "Такой категории товаров не существует.")
        }
        
        guard try await Product.query(on: req.db)
            .filter(\.$name == addProduct.name)
            .first() == nil
        else {
            return .init(result: 0, errorMessage: "Такой товар уже существует.")
        }
        let product = Product(name: addProduct.name,
                              price: addProduct.price,
                              discount: addProduct.discount,
                              description: addProduct.description,
                              image: addProduct.image,
                              categoryID: category.id)
        try await product.create(on: req.db)
        return .init(result: 1)
    }
    
    /**
     Update product method
     
     Path method post http://api/products/update
     - Parameter id: UUID of product
     - Parameter name: Name of product
     - Parameter price: Price product
     - Parameter discount: Int8 Price discount
     - Parameter description: Description product
     - Parameter categoryID: ID category for product
     - Returns: AddProductResult with value result: Int.
     */
    func update(req: Request) async throws -> UpdateProductResult {
        let productRequest = try req.content.decode(Product.UpdateProduct.self)
        guard let product = try await Product.find(productRequest.id, on: req.db)
        else {
            return .init(result: 0, errorMessage: "Такого продукта не существует.")
        }
        product.name = productRequest.name
        product.price = productRequest.price
        product.discount = productRequest.discount
        product.description = productRequest.description
        product.$category.id = productRequest.categoryID
        try await product.save(on: req.db)
        return .init(result: 1)
    }
    
    /**
     Delete product by id
     
     Path method delete http://api/products/<product_id>
     - Returns: HTTPStatus
     */
    func delete(req: Request) async throws -> HTTPStatus {
        guard let product = try await Product.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await product.delete(on: req.db)
        return .noContent
    }
}
