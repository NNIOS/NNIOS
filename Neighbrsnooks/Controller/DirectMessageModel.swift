//
//  DirectMessageModel.swift
//  NeighbrsNook Latest
//
//  Created by Mac on 30/04/24.
//

import Foundation

// MARK: - 
struct DirectMessageModel: Codable {
    let status: String?
    let messages: String?
    let nbdata: [DirectMessageData]?
}

struct DirectMessageData: Codable {
    var id: String?
    let username: String?
    let userpic: String?
    let dttime: String?
}

