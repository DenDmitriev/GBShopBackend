//
//  File.swift
//  
//
//  Created by Denis Dmitriev on 30.06.2023.
//

import Fluent
import Vapor

struct CategoryController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let categories = routes.grouped("categories")
        categories.get("all", use: all)
        categories.post("add", use: add)
        categories.group(":id") { category in
            category.delete(use: delete)
            category.get(use: self.category)
        }
    }
    
    /**
     Categories
     
     Path method get http://api/categories/all
     - Returns: All Categories array
     */
    func all(req: Request) async throws -> [ProductCategory] {
        try await ProductCategory.query(on: req.db).all() // .with(\.$products)
    }
    
    /**
     Add new category method
     
     Path method post http://api/categories/add
     - Parameter id: UUID of product
     - Parameter name: Name of product
     - Parameter description: Description of product
     - Parameter products: Leave blank
     - Returns: AddCategoryResult with value result: Int, category: ProductCategory.
     */
    func add(req: Request) async throws -> AddCategoryResult {
        let category = try req.content.decode(ProductCategory.self)
        guard ((try await ProductCategory.find(category.id, on: req.db)) == nil) else {
            return .init(result: 0, errorMessage: "Категория уже существует")
        }
        guard ((try await ProductCategory.query(on: req.db)
            .filter(\.$name == category.name)
            .first()) == nil)
        else {
            return .init(result: 0, errorMessage: "Категория c названием \(category.name) уже существует")
        }
        try await category.create(on: req.db)
        return .init(result: 1, category: category)
    }
    
    /**
     Category by id
     
     Path method get http://api/categories/<category_id>
     - Parameter id: UUID of category
     - Returns: ProductResult model with value result: Int, product: Product.
     */
    func category(req: Request) async throws -> CategoryResult {
        guard
            let request = req.parameters.get("id"),
            let id = UUID(uuidString: request)
        else {
            throw Abort(.badRequest)
        }
        
        guard let category = try await ProductCategory.find(id, on: req.db) else {
            return .init(result: 0, errorMessage: "Такой категории не существует.")
        }
        
        return .init(result: 1, category: category)
    }
    
    /**
     Delete category by id
     
     Path method delete http://api/products/<category_id>
     - Returns: HTTPStatus
     */
    func delete(req: Request) async throws -> HTTPStatus {
        guard let category = try await ProductCategory.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await category.delete(on: req.db)
        return .noContent
    }
}
