//
//  PollListModel.swift
//  Neighbrsnooks
//
//  Created by Abdul Aleem on 24/09/25.
//

import Foundation

struct PollListResponse: Codable {
    var status:Bool
    var code:Int
    var message:String
    var data:String
}

// MARK: - PollDecryptModel
struct PollDecryptModel: Codable {
    var data: PollDecryptData
}

// MARK: - PollDecryptData
struct PollDecryptData: Codable {
    var status: Bool
    var code: Int
    var message: String
    var data: PollListData
}

// MARK: - PollListData
struct PollListData: Codable {
    var poll_count: Int
    var current_page: Int
    var last_page: Int
    var per_page: Int
    var total: Int
    var verified_status: Bool
    var polls: [PollItem]
}

// MARK: - PollItem
struct PollItem: Codable {
    var id: Int
    var question: String
    var has_voted: Bool
    var start_date: String
    var end_date: String
    var total_votes: Int
    var is_running: Bool
    var poll_status: String
    var name: String
    var is_favourite: Bool
    var neighborhood: String
    var created_at: String
    var user_id: Int
    var userpic: String
}
