//
//  CreatePoll_Model.swift
//  Neighbrsnooks
//
//  Created by Abdul Aleem on 24/09/25.
//

import Foundation


struct CreatePoll_Request: Encodable {
    var title: String?
    var question: String?
    var options: [String]?
    var start_date: String?
    var end_date: String?
}

struct CreatePollResponse: Codable {
    let code: Int?
    let status: Bool?
    let message: String?
}
