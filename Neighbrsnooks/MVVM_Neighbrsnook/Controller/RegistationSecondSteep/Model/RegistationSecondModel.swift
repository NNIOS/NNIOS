//
//  RegistationSecondModel.swift
//  Neighbrsnooks
//
//  Created by Irshad Malik on 19/09/25.
//

import Foundation

// MARK: - Location Response Model

struct LocationResponse: Codable {
    let status: Bool?  
    let code: Int?
    let message: String?
    let error: String?
}

struct SecondCompleteModel: Codable {
    let status: Bool
    let code: Int
    let message, data: String
}
