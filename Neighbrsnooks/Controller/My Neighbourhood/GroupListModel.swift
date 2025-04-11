//
//  GroupListModel.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 05/06/24.
//

import Foundation

// MARK: - Welcome
struct GroupListModel: Codable {
    let status, message, status1, groupname: String?
    let groupuserneigh, groupusername: String?
    let groupuserpic: String?
    let ownerid, description: String?
    let memberlist: [GrouListsData]
}

// MARK: - Memberlist
struct GrouListsData: Codable {
    let userid, username, neighbrhood: String?
    let userphoto: String?
    let status, groupid: String?
}

