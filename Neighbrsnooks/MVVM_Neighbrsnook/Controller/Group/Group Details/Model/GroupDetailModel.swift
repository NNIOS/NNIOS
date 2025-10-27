//
//  GroupDetailModel.swift
//  Neighbrsnooks
//
//  Created by Abdul Aleem on 20/09/25.
//

import Foundation

// MARK: - EncryptGroupList
struct GroupDetail_Model: Codable {
    var data: GroupDetailResponse?
}

struct GroupDetailResponse: Codable {
    var status:Bool?
    let code: Int?
    var message: String?
    var data:String?
}

// MARK: - DecryptGroupList
struct DecryptGroupDetailsList: Codable {
    var status: Bool?
    var code: Int?
    var message: String?
    var data: GroupDetailItem?
}


// MARK: - DecryptGroupList
struct GroupDecryptDeatiltData: Codable {
    var data: DecryptGroupDetailResponse?
}
struct DecryptGroupDetailResponse: Codable {
    var status: Bool?
    var code: Int?
    var message: String?
    var data: GroupDetailItem?
}

// MARK: - Group Decrypt List API Response
struct GroupDecryptDetailApiResponse<T: Codable>: Codable {
    var status: Bool?
    var code: Int?
    var message: String?
    var data: T?
}

// MARK: - Group Detail
struct GroupDetailItem: Codable {
    var type: String?
    var groupid: Int?
    var createdby: Int?
    var username: String?
    var userpic: String?
    var created_on: String?
    var neighborhood: String?
    var group_name: String?
    var group_description: String?
    var group_image: String?
    var group_type: String?
    var memJoinStatus: Bool?
    var group_status: Bool?
    var favouritstatus: Bool?
    var getjoin: String?
    var pendingRequestCount: String?
    var membercount: Int?

}
