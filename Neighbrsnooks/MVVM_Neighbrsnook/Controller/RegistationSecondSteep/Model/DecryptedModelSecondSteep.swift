//
//  DecryptedModelSecondSteep.swift
//  Neighbrsnooks
//
//  Created by Irshad Malik on 22/09/25.
//

import Foundation



// MARK: - DecryptedModelSecondSteep
struct DecryptedModelSecondSteep: Codable {
    let data: SecondSteepData
}

// MARK: - SecondSteepData
struct SecondSteepData: Codable {
    let status: Bool
    let code: Int
    let message: String
    let data: DataSecond
}

// MARK: - DataSecond
struct DataSecond: Codable {
    let user: Int
    let neighbourhood: String
    let mailResponse: Int

    enum CodingKeys: String, CodingKey {
        case user, neighbourhood
        case mailResponse = "Mail Response"
    }
}
