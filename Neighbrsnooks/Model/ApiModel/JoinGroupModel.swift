//
//  JoinGroupModel.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 04/06/24.
//

import Foundation

// MARK: - Welcome
struct JoinGroupModel: Codable {
    let status, message, joinStatus: String?

    enum CodingKeys: String, CodingKey {
        case status, message 
        case joinStatus = "join_status"
    }
}

