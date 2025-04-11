//
//  PublicDirectoryModel.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 03/10/24.
//

import Foundation

// MARK: - Welcome
struct PublicDirectoryModel: Codable {
    let status, message, neighbrhood: String?
    let listdata: [PublicDirecData]?
}

// MARK: - Listdatum
struct PublicDirecData: Codable {
    let id, type, name, number1: String?
    let number2, lat, long, address: String?
    let website: String?
}
