//
//  NeighbourModel.swift
//  NeighbrsNook Latest
//
//  Created by Rajat Rao on 21/02/24.
//

import Foundation

// MARK: - Welcome
struct NeighbourModel: Codable {
    let status, message: String
    let nbdata: [NeighbourData]
}

// MARK: - Nbdatum
struct NeighbourData: Codable {
    let id, memberTitle: String

    enum CodingKeys: String, CodingKey {
        case id
        case memberTitle = "member_title"
    }
}
