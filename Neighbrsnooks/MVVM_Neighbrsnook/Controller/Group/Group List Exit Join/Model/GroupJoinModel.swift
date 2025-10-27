//
//  GroupJoinModel.swift
//  Neighbrsnooks
//
//  Created by Abdul Aleem on 22/09/25.
//

import Foundation
struct GroupJoin_Request: Encodable {
    var group_id: Int
}

struct GroupJoinResponse: Codable {
    var status: Bool?
    var code: Int?
    var message: String?
}
