//
//  PostLikeStatusDecrypt.swift
//  Neighbrsnooks
//
//  Created by Irshad Malik on 08/10/25.
//

import Foundation

struct PostLikeStatus: Codable {
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let status: Bool
    let code: Int
    let message: String
    let totalLikes: Int
    let authLike: Bool
    let data: [Datum]

    enum CodingKeys: String, CodingKey {
        case status, code, message
        case totalLikes = "total_likes"
        case authLike = "auth_like"
        case data
    }
}

// MARK: - Datum
struct Datum: Codable {
    let userID: Int
    let name: String
    let neighborhoodID: Int
    let neighborhoodName: String
    let userpic: String
    let emojiCode: String

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case name
        case neighborhoodID = "neighborhood_id"
        case neighborhoodName = "neighborhood_name"
        case userpic
        case emojiCode = "emoji_code"
    }
}
