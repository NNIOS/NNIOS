//
//  ChatMemberModel.swift
//  NeighbrsNook Latest
//
//  Created by Mac on 01/05/24.
//

import Foundation

// MARK: - Welcome
struct ChatMemberModel: Codable {
    let status, message: String
    let listdata: [ChatMemberData]
}

// MARK: - Listdatum
struct ChatMemberData: Codable {
    let id, fullname: String
    let userpic: String
    let neighbrhood: String
}
