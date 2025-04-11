//
//  ProffessionModel.swift
//  NeighbrsNook Latest
//
//  Created by Rajat Rao on 20/02/24.
//

import Foundation

// MARK: - Welcome
struct ProffessionModel: Codable {
    let status, message: String
    let nbdata: [AddProjectData]
}

// MARK: - Nbdatum
struct AddProjectData: Codable {
    let id, memberTitle: String
    

    enum CodingKeys: String, CodingKey {
        case id
        case memberTitle = "member_title"
    }
}



