//
//  PostCommentLikeModel.swift
//  Neighbrsnooks
//
//  Created by Irshad Malik on 07/10/25.
//

import Foundation
struct PostCommentLikeModel: Codable {
    let status: Bool
    let code: Int
    let message: String
    let authLiked: Bool
    let likeCount: Int

    enum CodingKeys: String, CodingKey {
        case status, code, message
        case authLiked = "auth_liked"
        case likeCount = "like_count"
    }
}
