//
//  MessageModel.swift
//  NeighbrsNook Latest
//
//  Created by Mac on 02/05/24.
//

import Foundation

// MARK: - Welcome
struct MessageModel: Codable {
    let status, messages: String?
    let nbdata: [ChatMessageData]
}

// MARK: - Nbdatum
struct ChatMessageData: Codable {
    let id, type, message, subject: String?
    let userpic: String?
    let dttime: String?
}
