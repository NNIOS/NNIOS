//
//  HomeBookayModel.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 11/11/24.
//

import Foundation

// MARK: - Welcome
struct HomeBookayModel: Codable {
    let status, message: String?
    var totalLike, totalBokay, likeStatus, bokayStatus: Int?

    enum CodingKeys: String, CodingKey {
        case status, message
        case totalLike = "total_like"
        case totalBokay = "total_bokay"
        case likeStatus = "like_status"
        case bokayStatus = "bokay_status"
    }
}

