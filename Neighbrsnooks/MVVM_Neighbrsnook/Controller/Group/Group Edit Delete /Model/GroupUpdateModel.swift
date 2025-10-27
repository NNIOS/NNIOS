//
//  GroupUpdateModel.swift
//  Neighbrsnooks
//
//  Created by Abdul Aleem on 22/09/25.
//

import Foundation

struct GroupUpdate_Request: Encodable {
    var group_id: Int
    var name: String
    var image:String
    let description: String
    let join_type: String
}

struct GroupUpdateResponse: Codable {
    var status: Bool?
    var code: Int?
    var message: String?
}
