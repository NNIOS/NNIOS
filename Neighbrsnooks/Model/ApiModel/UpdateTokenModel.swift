//
//  UpdateTokenModel.swift
//  Neighbrsnooks
//
//  Created by Irshad Malik on 15/04/25.
//

import Foundation
 

// MARK: - UpdateTokenModel
struct UpdateTokenModel: Codable {
    let userid: Int
    let firebaseToken: String

    enum CodingKeys: String, CodingKey {
        case userid
        case firebaseToken = "firebase_token"
    }
}
