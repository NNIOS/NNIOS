//
//  GroupList_Model.swift
//  Neighbrsnooks
//
//  Created by Abdul Aleem on 19/09/25.
//

import Foundation

// MARK: - EncryptGroupList
struct GroupListing_Model: Codable {
    var data: GroupListResponse?
}

struct GroupListResponse: Codable {
    var status:Bool?
    let code: Int?
    var message: String?
    var data:String?
}

// MARK: - DecryptGroupList
struct DecryptGroupList: Codable {
    var status: Bool?
    var code: Int?
    var message: String?
    var data: GroupDecryptListData?
}

struct GroupDecryptListData: Codable {
    var group_count: Int?
    var current_page: Int?
    var last_page: Int?
    var per_page: Int?
    var total: Int?
    var verified_status: Bool?
    var groups: [GroupItem]?
}

// MARK: - Group Decrypt List API Response
struct GroupDecryptListApiResponse<T: Codable>: Codable {
    var status: Bool?
    var code: Int?
    var message: String?
    var data: T?
}


// MARK: - GroupItem
struct GroupItem: Codable {
    var type: String?
    var groupid: Int?
    var userid: Int?
    var username: String?
    var userpic: String?
    var created_on: String?
    var neighborhood: String?
    var group_name: String?
    var group_description: String?
    var group_image: String?
    var group_type: String?
    var group_status: Bool?
    var favouritstatus: Bool?
    var getjoin: String?
    var pendingRequestCount: String?
    var membercount: Int?
}

