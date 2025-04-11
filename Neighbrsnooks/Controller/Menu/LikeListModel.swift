//
//  LikeListModel.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 18/06/24.
//

import Foundation

// MARK: - Welcome
struct LikeListModel: Codable {
    let status, message: String?
    let totalEmojis: Int?
    let listdata: [LikeListData]

    enum CodingKeys: String, CodingKey {
        case status, message
        case totalEmojis = "total_emojis"
        case listdata
    }
}

// MARK: - Listdatum
struct LikeListData: Codable {
    let postid, userid, username: String?
    let userpic: String?
    let neighbrhood, emoji, emojiunicode, createon: String?
}

