//
//  GroupChatModel.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 07/06/24.
//

import Foundation

// MARK: - Welcome
struct GroupChatModel: Codable {
    let status, message: String?
    let data: [GroupMessageData]
}

// MARK: - Datum
struct GroupMessageData: Codable {
    let id, name, message, date: String?
}
