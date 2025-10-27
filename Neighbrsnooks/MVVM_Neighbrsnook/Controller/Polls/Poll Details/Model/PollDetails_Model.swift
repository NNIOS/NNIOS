//
//  PollDetails_Model.swift
//  Neighbrsnooks
//
//  Created by Abdul Aleem on 25/09/25.
//

import Foundation
// MARK: - PollDetails_Model (Encrypted API Response)
struct PollDetailsResponse: Codable {
    var status: Bool
    var code: Int
    var message: String
    var data: String
}


// MARK: - DecryptPollDetailsModel
struct PollDetailsDecryptModel: Codable {
    var data: DecryptPollDetailsData
}

// MARK: - DecryptPollDetailsData
struct DecryptPollDetailsData: Codable {
    var status: Bool
    var code: Int
    var message: String
    var verfied_msg: String
    var data: PollDetailsData
}

// MARK: - PollDetailsData
struct PollDetailsData: Codable {
    var p_id: Int
    var title: String
    var neighborhood: String
    var poll_ques: String
    var start_date: String
    var end_date: String
    var created_by: String
    var created_date: String
    var edit_poll_status: Bool
    var options: [PollOption]
    var userid: Int
    var total_vote: Int
    var owner_vote: Bool
    var auth_voted: Bool
    var auth_favourite_status: Bool
    var poll_running_status: Bool
    var poll_status: String
    var userpic: String
}

// MARK: - PollOption
struct PollOption: Codable {
    var id: Int
    var option: String
    var percentage: String
    var user_count: Int
}

// MARK: - PollDelete_Model
struct PollDeleteResponse: Codable {
    var status: Bool
    var code:Int
    var message:String
    
}

// MARK: - PollDelete_Model
struct PollVoteResponse: Codable {
    var status: Bool
    var code:Int
    var message:String
    
}
