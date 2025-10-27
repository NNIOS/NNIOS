//
//  GroupMemberModel.swift
//  Neighbrsnooks
//
//  Created by Abdul Aleem on 23/09/25.
//

import Foundation

// MARK: - API Request
struct GroupMember_Request: Encodable {
    let group_id: Int?
}

struct GroupApprove_Request: Encodable {
    let group_id, member_id: Int?
}

// MARK: - Encrypted API Response
struct GroupMemberResponse: Codable {
    var status: Bool?
    var code: Int?
    var message: String?
    var data: String?
}

// MARK: - Decrypted Response Wrapper
struct DecryptGroupMemberResponse: Codable {
    var data: DecryptGroupMemberData?
}

// MARK: - Decrypted Data Dictionary
struct DecryptGroupMemberData: Codable {
    var code: Int?
    var data: [GroupMemberData]?   // Array of members
    var message: String?
    var status: Int?

    enum CodingKeys: String, CodingKey {
        case code, data, message, status
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        code = try? container.decode(Int.self, forKey: .code)
        data = try? container.decode([GroupMemberData].self, forKey: .data)
        message = try? container.decode(String.self, forKey: .message)
        
        // Decode status safely (Int or Bool)
        if let intValue = try? container.decode(Int.self, forKey: .status) {
            status = intValue
        } else if let boolValue = try? container.decode(Bool.self, forKey: .status) {
            status = boolValue ? 1 : 0
        } else {
            status = nil
        }
    }
}




// MARK: - Individual Member
struct GroupMemberData: Codable {
    var full_name: String?
    var group_id: Int?
    var join_status_label: Bool?
    var neighbourhood: String?
    var profile_pic: String?
    var role: String?
    var user_id: Int?
}

