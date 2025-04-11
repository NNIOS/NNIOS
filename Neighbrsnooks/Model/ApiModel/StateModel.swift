//
//  StateModel.swift
//  NeighbrsNook Latest
//
//  Created by Rajat Rao on 22/02/24.
//

import Foundation


// MARK: - StateModel
 

struct StateModel: Codable {
    let status, message: String
    let nbdata: [stateData]
}

// MARK: - Nbdatum
struct stateData: Codable {
    let id, stateName: String

    enum CodingKeys: String, CodingKey {
        case id
        case stateName = "state_name"
    }
}
