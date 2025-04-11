//
//  cityModel.swift
//  NeighbrsNook Latest
//
//  Created by Rajat Rao on 22/02/24.
//

import Foundation
 
// MARK: - cityModel
struct cityModel: Codable {
    let status, message: String
    let nbdata: [cityData]
}

// MARK: - Nbdatum
struct cityData: Codable {
    let id, cityName: String

    enum CodingKeys: String, CodingKey {
        case id
        case cityName = "city_name"
    }
}
