//
//  ReviewController.swift
//  
//
//  Created by Denis Dmitriev on 05.07.2023.
//

import Fluent
import Vapor

struct ReviewController: RouteCollection {
    func boot(routes: Vapor.RoutesBuilder) throws {
        let reviews = routes.grouped("reviews")
        reviews.post("add", use: addReview)
        reviews.get("get", use: getReviews)
        
        reviews.group(":id") { review in
            review.delete(use: deleteReview)
        }
    }
    
    /**
     Add review func
     
     Post method on path http://api/reviews/add
     
     - Parameter userID: UUID user reviewer
     - Parameter productID: UUID of product
     - Parameter review: String with number of characters from 0 to 280
     - Parameter rating: Int with value from 1 to 5
     - Returns: `AddReviewResult` model
     */
    func addReview(req: Request) async throws -> AddReviewResult {
        let addReview = try req.content.decode(Review.AddReview.self)
        // TODO: add check for exist product and user
        
        let review = Review(value: addReview.review,
                            userID: addReview.userID,
                            productID: addReview.productID,
                            rating: addReview.rating)
        do {
            try await review.create(on: req.db)
            return .init(result: 1)
        } catch {
            return .init(result: .zero)
        }
    }
    
    /**
     Delete review func
     
     Delete method on path http://api/reviews/<review_id>
     
     - Returns: `DeleteReviewResult` model
     */
    func deleteReview(req: Request) async throws -> DeleteReviewResult {
        guard let review = try await Review.find(req.parameters.get("id"), on: req.db)
        else {
            return .init(result: 0, errorMessage: "Не удалось найти отзыв.")
        }
        
        try await review.delete(on: req.db)
        
        return .init(result: 1)
    }
    
    /**
     Get review func
     
     Get method on path http://api/reviews/get
     
     - Parameter productID: UUID of product
     - Parameter page: Int page numbers start at 1
     - Parameter per: Int element per page
     - Returns: `GetReviewsResult` model
     */
    func getReviews(req: Request) async throws -> GetReviewsResult {
        let getReviewRequest = try req.query.decode(GetReviewsRequest.self)
        
        let productID = getReviewRequest.productID
        guard let product = try await Product.find(productID, on: req.db)
        else {
            return .init(result: 0, errorMessage: "Не удалось найти продукт с отзывами.")
        }
        let page = getReviewRequest.page
        let per = getReviewRequest.per
        
        let reviews = try await product.$reviews
            .query(on: req.db)
            .with(\.$user)
            .sort(\.$createdAt)
            .page(withIndex: page, size: per)
        
        
        let publicReviews = reviews
            .map { Review.Public.makePublicReviews(review: $0) }
            .items
        
        let total = try await product.$reviews.get(on: req.db).count
        let metadata = Metadata(page: page, per: per, total: total)
        
        return .init(result: 1, reviews: publicReviews, metadata: metadata)
    }
}

