//
//  CreateCommentModel.swift
//  Neighbrsnooks
//
//  Created by Irshad Malik on 06/10/25.
//

import Foundation
struct CreateCommentModel: Codable {
    let status: Bool
    let code: Int
    let message: String
    let data: CommentDataClass
}

// MARK: - DataClass
struct CommentDataClass: Codable {
    let postID: String
    let userID: Int
    let parentID, message, updatedAt, createdAt: String
    let id: Int

    enum CodingKeys: String, CodingKey {
        case postID = "post_id"
        case userID = "user_id"
        case parentID = "parent_id"
        case message
        case updatedAt = "updated_at"
        case createdAt = "created_at"
        case id
    }
}
