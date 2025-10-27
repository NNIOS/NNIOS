//
//  HomeDataModel.swift
//  Neighbrsnooks
//
//  Created by Irshad Malik on 24/09/25.
//

import Foundation
struct HomeDataModel: Codable {
    let status: IntOrBoolOrString
    let code: Int
    let message: String
    let data: String   // sirf string hai, encrypted data
}
