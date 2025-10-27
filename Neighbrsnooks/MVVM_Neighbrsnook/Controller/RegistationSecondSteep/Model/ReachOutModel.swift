//
//  ReachOutModel.swift
//  Neighbrsnooks
//
//  Created by Irshad Malik on 22/09/25.
//

import Foundation
struct ReachOutModel: Codable {
    let status: IntOrBoolOrString
    let code: Int
    let message: String
}

struct ReachOutRequest {
    let address: String
    let latitude: String
    let longitude: String
    let area: String
    let city: String
    let state: String
    let country: String
    let pincode: String
    let reachout: String // usually "1"
}
