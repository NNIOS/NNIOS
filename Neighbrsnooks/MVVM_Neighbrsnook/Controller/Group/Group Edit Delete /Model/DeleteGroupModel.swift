//
//  DeleteGroupModel.swift
//  Neighbrsnooks
//
//  Created by Abdul Aleem on 22/09/25.
//

import Foundation
struct DeleteGroup_Request: Encodable {
    let group_id: Int
}


struct DeleteGroupResponse: Codable {
    let status: Bool?
    let code: Int?
    let message: String?
}


