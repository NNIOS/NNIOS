//
//  CountryModel.swift
//  NeighbrsNook Latest
//
//  Created by Rajat Rao on 22/02/24.
//

import Foundation

// MARK: - Welcome
struct CountryModel: Codable {
    let status, message: String
    let nbdata: [countryData]
}

// MARK: - Nbdatum
struct countryData: Codable {
    let id, countryname: String
}
