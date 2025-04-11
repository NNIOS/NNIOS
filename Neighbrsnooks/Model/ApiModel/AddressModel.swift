//
//  AddressModel.swift
//  NeighbrsNook Latest
//
//  Created by Rajat Rao on 27/02/24.
//

import Foundation

// MARK: - Welcome
struct AddressModel: Codable {
    let status: String?
    let data: [AddressData]
    let message: String?
}

// MARK: - Datum
struct AddressData: Codable {
    let nbdID, nbdName, distance: String

    enum CodingKeys: String, CodingKey {
        case nbdID = "nbd_id"
        case nbdName = "nbd_name"
        case distance
    }
}

