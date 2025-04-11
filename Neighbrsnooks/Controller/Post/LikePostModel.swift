//
//  LikePostModel.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 14/06/24.
//

import Foundation

// MARK: - Welcome
import Foundation

// MARK: - Welcome
struct LikePostModel: Codable {
    let status, message: String?
    let totalLike: Int?

    enum CodingKeys: String, CodingKey {
        case status, message
        case totalLike = "total_like"
    }
}
