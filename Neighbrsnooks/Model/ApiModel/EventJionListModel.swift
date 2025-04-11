//
//  EventJionListModel.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 21/08/24.
//

import Foundation

// MARK: - Welcome
struct EventJionListModel: Codable {
    let status, message: String?
    let listdata: [EventJoinListData]?
}

// MARK: - Listdatum
struct EventJoinListData: Codable {
    let eID, name, neigh, userid: String?
    let img: String?

    enum CodingKeys: String, CodingKey {
        case eID = "e_id"
        case name, neigh, userid, img
    }
}

