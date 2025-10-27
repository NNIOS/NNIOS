//
//  ProfileUpdateDataModel.swift
//  Neighbrsnooks
//
//  Created by Irshad Malik on 29/09/25.
//

import Foundation
struct ProfileUpdateDataModel: Codable {
    let status: Bool
    let code: Int
    let message, data: String
}



// MARK: - DataDecrypt Model

struct ProfileUpdateDataModelDecrypt: Codable {
    let data: ProfileUpdateDataDecrypt
}

// MARK: - ProfileUpdateDataDecrypt
struct ProfileUpdateDataDecrypt: Codable {
    let status: Bool
    let code: Int
    let message: String
    let data: DataDecrypt
}

// MARK: - DataDecrypt
struct DataDecrypt: Codable {
    let userID: Int
    let message: String
    let userpic: String
    let verified: String

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case message, userpic
        case verified = "Verified"
    }
}
