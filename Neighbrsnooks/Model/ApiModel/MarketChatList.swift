//
//  MarketChatList.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 11/09/24.
//

import Foundation

// MARK: - Welcome
struct MarketChatList: Codable {
    let chats: [MarketChatListData]?
}

// MARK: - Chat
struct MarketChatListData: Codable {
    let senderID, productID: Int?
    let senderName: String?
    let senderUserpic: String?
    let neighborhood: String?
    let readStatus, readCount: Int?

    enum CodingKeys: String, CodingKey {
        case senderID = "sender_id"
        case productID = "product_id"
        case senderName = "sender_name"
        case senderUserpic = "sender_userpic"
        case neighborhood
        case readStatus = "read_status"
        case readCount = "read_count"
    }
}
