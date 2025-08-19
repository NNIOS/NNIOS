//
//  DeactivateModel.swift
//  Neighbrsnooks
//
//  Created by Mac on 07/05/25.
//

import Foundation

// MARK: - Welcome
struct DeactivateModel: Codable {
    let status, message: String?
}


struct BlockUserModel: Codable {
    var status:String?
    let message: String?
}


struct DeleteAccountModel: Codable {
    let status: Int?
    let message: String?
}


struct DeleteMessMDModel: Codable {
    let status, message: String?
}


