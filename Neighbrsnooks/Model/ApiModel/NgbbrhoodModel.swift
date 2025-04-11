//
//  NgbbrhoodModel.swift
//  NeighbrsNook Latest
//
//  Created by Rajat Rao on 27/02/24.
//

import Foundation

// MARK: - Welcome
struct NgbbrhoodModel: Codable {
    let status: String?
    var data: [NeighbrhdData]
}

// MARK: - Datum
struct NeighbrhdData: Codable {
    let nbdID, nbdName, distance: String?

    enum CodingKeys: String, CodingKey {
        case nbdID = "nbd_id"
        case nbdName = "nbd_name"
        case distance
    }
}
