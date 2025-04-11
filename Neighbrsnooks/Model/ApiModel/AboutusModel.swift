//
//  AboutusModel.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 06/02/25.
//

import Foundation

// MARK: - Welcome
struct AboutusModel: Codable {
    let nbdata: [AbouusData]?
    let status, message: String?
}

// MARK: - Nbdatum
struct AbouusData: Codable {
    let aboutus: String?
}
