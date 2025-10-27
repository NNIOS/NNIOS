//
//  DecryptedNeighborhoodModel.swift
//  Neighbrsnooks
//
//  Created by Irshad Malik on 20/09/25.
//

import Foundation

struct DecryptedNeighborhoodModel: Codable {
    let data: DecryptedNeighborhoodInnerData?
}

struct DecryptedNeighborhoodInnerData: Codable {
    let code: Int?
    let message: String?
    let status: IntOrBoolOrString
    let data: [NeighborhoodData]?
}


struct NeighborhoodData: Codable {
    let id: Int
    let name: String
}
