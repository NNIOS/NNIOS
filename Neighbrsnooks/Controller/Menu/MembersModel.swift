//
//  MembersModel.swift
//  NeighbrsNook Latest
//
//  Created by Mac on 04/04/24.
//

import Foundation

// MARK: - Welcome
struct MembersModel: Codable {
    let status, message: String
    let listdata: [MemberListData]
}

// MARK: - Listdatum
struct MemberListData: Codable {
    let id, fullname: String
    let userpic: String
    let neighbrhood: String
    var is_blocked:Int?
}
