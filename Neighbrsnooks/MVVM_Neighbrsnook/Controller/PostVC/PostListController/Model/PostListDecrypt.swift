//
//  PostListDecrypt.swift
//  Neighbrsnooks
//
//  Created by Irshad Malik on 08/10/25.
//

import Foundation



// MARK: - PostListDecrypt
struct PostListDecrypt: Codable {
    let data: PostListResponseData
}

// MARK: - PostListResponseData
struct PostListResponseData: Codable {
    let status: Bool
    let code: Int
    let message: String
    let data: PostListInnerData
}

// MARK: - PostListInnerData
struct PostListInnerData: Codable {
    let verifiedStatus: Bool
    let postCount: Int
    let currentPage: Int
    let lastPage: Int
    let perPage: Int
    let total: Int
    let posts: [PostItem]

    enum CodingKeys: String, CodingKey {
        case verifiedStatus = "verified_status"
        case postCount = "post_count"
        case currentPage = "current_page"
        case lastPage = "last_page"
        case perPage = "per_page"
        case total
        case posts
    }
}

// MARK: - PostItem
struct PostItem: Codable {
    let id: Int
    let userID: Int
    let neighborhoodID: String?
    let postDescription: String
    let createdAt: String
    let updatedAt: String
    let userFullName: String
    let userpic: String
    let postType: String
    let media: [PostMedia]
    let status: Bool
    let authLike: Bool
    let authFavorites: Bool
    let authEmoji: Bool
    let authEmojiCode: String
    let totallike: Int
    let totalEmojis: Int
    let totcomment: Int

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case neighborhoodID = "neighborhood_id"
        case postDescription = "description"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case userFullName = "user_full_name"
        case userpic
        case postType = "post type" // ✅ handles key with space
        case media
        case status
        case authLike = "auth_like"
        case authFavorites = "auth_favorites"
        case authEmoji = "auth_emoji"
        case authEmojiCode = "auth_emoji_code"
        case totallike
        case totalEmojis = "total_emojis"
        case totcomment
    }

    // ✅ Computed property for title
    var postTitle: String {
        if !postType.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return postType
        } else {
            return String(postDescription.prefix(40))
        }
    }
}

// MARK: - PostMedia
struct PostMedia: Codable {
    let img: String?
    let video: String?
}
