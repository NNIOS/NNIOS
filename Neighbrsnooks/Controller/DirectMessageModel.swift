//
//  DirectMessageModel.swift
//  NeighbrsNook Latest
//
//  Created by Mac on 30/04/24.
//

import Foundation

// MARK: - Welcome
struct DirectMessageModel: Codable {
    let status, messages: String
    let nbdata: [DirectMessageData]
}

// MARK: - Nbdatum
struct DirectMessageData: Codable {
    let id, username: String
    let userpic: String
    let dttime: String
}
