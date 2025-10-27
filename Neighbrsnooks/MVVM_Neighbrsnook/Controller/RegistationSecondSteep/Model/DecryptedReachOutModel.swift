//
//  DecryptedReachOutModel.swift
//  Neighbrsnooks
//
//  Created by Irshad Malik on 22/09/25.
//

import Foundation

// MARK: - Welcome
struct DecryptedReachOutModel: Codable {
    let data: DecryptedReachOutData
}

// MARK: - WelcomeData
struct DecryptedReachOutData: Codable {
    let status: IntOrBoolOrString
    let code: Int
    let message: String
    let data: DataData
}

// MARK: - DataData
struct DataData: Codable {
    let id: Int
    let token: String
}
