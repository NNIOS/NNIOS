//
//  RegisterFirstModel.swift
//  NeighbrsNook Latest
//
//  Created by Rajat Rao on 21/02/24.
//

import Foundation

// MARK: - Welcome
//struct RegisterFirstModel: Codable {
//    let status, message, verfiedMsg, image: String
//
//    enum CodingKeys: String, CodingKey {
//        case status, message
//        case verfiedMsg = "verfied_msg"
//        case image = ""
//    }
//}


struct Welcome: Codable {
    let status, message, verfiedMsg, image: String

    enum CodingKeys: String, CodingKey {
        case status, message
        case verfiedMsg = "verfied_msg"
        case image
    }
}
