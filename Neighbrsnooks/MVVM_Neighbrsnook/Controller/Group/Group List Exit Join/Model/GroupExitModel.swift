//
//  GroupExitModel.swift
//  Neighbrsnooks
//
//  Created by Abdul Aleem on 22/09/25.
//

import Foundation
struct GroupExit_Request: Encodable {
    var group_id: Int
}

struct GroupExitResponse: Codable {
    var status: Bool?
    var code: Int?
    var message: String?
}
