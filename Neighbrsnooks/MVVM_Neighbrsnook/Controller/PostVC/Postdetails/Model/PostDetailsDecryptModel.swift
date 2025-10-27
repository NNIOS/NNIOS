//
//  PostDetailsDecryptModel.swift
//  Neighbrsnooks
//
//  Created by Irshad Malik on 06/10/25.
//

import Foundation
// MARK: - postDetailsdecryptModel
struct postDetailsdecryptModel: Codable {
    let data: PostDetailsData
}

// MARK: - PostDetailsData
struct PostDetailsData: Codable {
    let status: Bool
    let code: Int
    let message: String
    let data: PostDetailsInnerData
}

// MARK: - PostDetailsInnerData
struct PostDetailsInnerData: Codable {
    let posts: [PostDetailsPost]
}

// MARK: - PostDetailsPost
struct PostDetailsPost: Codable {
    let id, userID: Int
    let neighborhoodID: String
    let description: String
    let createdAt: String
    let updatedAt: String
    let userFullName: String
    let userpic: String
    let postType: String
    let media: [PostDetailsMedia]
    let status, authLike, authFavorites, authEmoji: Bool
    let authEmojiCode: String
    let totallike, totalEmojis, totcomment: Int

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case neighborhoodID = "neighborhood_id"
        case description
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case userFullName = "user_full_name"
        case userpic
        case postType = "post type"
        case media, status
        case authLike = "auth_like"
        case authFavorites = "auth_favorites"
        case authEmoji = "auth_emoji"
        case authEmojiCode = "auth_emoji_code"
        case totallike
        case totalEmojis = "total_emojis"
        case totcomment
    }
}

// MARK: - PostDetailsMedia
struct PostDetailsMedia: Codable {
    let img: String?
    let video: String?
}
