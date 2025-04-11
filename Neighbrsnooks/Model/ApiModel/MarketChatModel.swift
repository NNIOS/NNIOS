//
//  MarketChatModel.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 12/09/24.
//

import Foundation

// MARK: - Welcome
struct MarketChatModel: Codable {
    let messages: [MarketChatData]?
}

// MARK: - Message
struct MarketChatData: Codable {
    let id, pID, senderID, receiverID: Int?
    let subject, message: String?
    let readStatus: Int?
    let senderUserpic: String?
    let createdAts, updatedAts, sendertype: String?

    enum CodingKeys: String, CodingKey {
        case id
        case pID = "p_id"
        case senderID = "sender_id"
        case receiverID = "receiver_id"
        case subject, message
        case readStatus = "read_status"
        case senderUserpic = "sender_userpic"
        case createdAts = "created_ats"
        case updatedAts = "updated_ats"
        case sendertype
    }
}
