//
//  GroupChatListModel.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 07/06/24.
//

import Foundation

// MARK: - Welcome
struct GroupChatListModel: Codable {
    let status, message: String?
    let data: [GroupChatData]
}

// MARK: - Datum
struct GroupChatData: Codable {
    let id, name, message, date: String?
    let userpic: String?
    let type: String?
}
