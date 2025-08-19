//
//  LikeResponseModel.swift
//  Neighbrsnooks
//
//  Created by Irshad Malik on 05/07/25.
//

import Foundation

struct LikeResponseModel: Codable {
    let status: String
    let message: String
    let totalLikes: String
    let userLikeStatus: String

    enum CodingKeys: String, CodingKey {
        case status
        case message
        case totalLikes = "total_likes"
        case userLikeStatus = "user_like_status"
    }
}
