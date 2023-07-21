//
//  DeleteReviewRequest.swift
//  
//
//  Created by Denis Dmitriev on 05.07.2023.
//

import Vapor

struct DeleteReviewRequest: Content {
    let reviewID: UUID
}
