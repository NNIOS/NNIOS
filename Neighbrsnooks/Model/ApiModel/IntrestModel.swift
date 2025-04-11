//
//  IntrestModel.swift
//  NeighbrsNook Latest
//
//  Created by Rajat Rao on 21/02/24.
//

import Foundation
//
//// MARK: - Welcome
//struct IntrestModel: Codable {
//    let status, message: String
//    let nbdata: [IntrsetData]
//}
//
//// MARK: - Nbdatum
//struct IntrsetData: Codable {
//    let id, memberTitle: String
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case memberTitle = "member_title"
//    }
//}


struct IntrestModel: Codable {
    let status, message: String
    let nbdata: [IntrsetData]
}

struct IntrsetData: Codable {
    let id, memberTitle: String

    enum CodingKeys: String, CodingKey {
        case id
        case memberTitle = "member_title"
    }
}

//struct NeighbourModel: Codable {
//    let neighbourList: [String] // Adjust this as per your actual structure
//}
