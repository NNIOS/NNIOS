//
//  DeviceRegisterModel.swift
//  Neighbrsnooks
//
//  Created by Irshad Malik on 20/09/25.
//

import Foundation
struct DeviceRegisterModel: Codable {
    let status: IntOrBoolOrString
    let code: Int
    let message: String
}

