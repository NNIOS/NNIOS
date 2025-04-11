//
//  EventLikeListModel.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 05/03/25.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct EventLikeListModel: Codable {
    let status, message: String?
    let listdata: [EventLikeListData]?
}

// MARK: - Listdatum
struct EventLikeListData: Codable {
    let eID, userid, username: String?
    let userpic: String?
    let neighbrhood, status, createon: String?

    enum CodingKeys: String, CodingKey {
        case eID = "e_id"
        case userid, username, userpic, neighbrhood, status, createon
    }
}

