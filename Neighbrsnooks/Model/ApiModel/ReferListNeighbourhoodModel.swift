//
//  ReferListNeighbourhoodModel.swift
//  Neighbrsnooks
//
//  Created by Irshad Malik on 15/10/25.
//

import Foundation
struct ReferListNeighbourhoodModel: Codable {
    let success: Bool
    let data: [ReferListData]
}

// MARK: - ReferListData
struct ReferListData: Codable {
    let name: String
    let id: String
}
