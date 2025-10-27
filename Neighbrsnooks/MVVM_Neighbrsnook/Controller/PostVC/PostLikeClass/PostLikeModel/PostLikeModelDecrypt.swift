//
//  PostLikeModelDecrypt.swift
//  Neighbrsnooks
//
//  Created by Irshad Malik on 07/10/25.
//

import Foundation

struct PostLikeDecryptModel: Codable {
    let data: PostLikeDecryptData
}

// MARK: - Data Wrapper
struct PostLikeDecryptData: Codable {
    let status: Bool
    let code: Int
    let message: String
    let data: PostLikeInnerData
}

// MARK: - Inner Data
struct PostLikeInnerData: Codable {
    let totalLikes: Int
    let likeStatus: Bool
    let emojiType: String

    enum CodingKeys: String, CodingKey {
        case totalLikes = "total_likes"
        case likeStatus = "like_status"
        case emojiType = "emoji_type"
    }
}
