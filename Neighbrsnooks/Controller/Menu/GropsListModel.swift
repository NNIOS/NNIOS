//
//  GropsListModel.swift
//  NeighbrsNook Latest
//
//  Created by Mac on 04/04/24.
//

import Foundation
struct GropsListModel : Codable {
    let status : String?
    let message : String?
    let verfied_msg : String?
    var listdata : [GroupListData]?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case verfied_msg = "verfied_msg"
        case listdata = "listdata"
    }

//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        status = try values.decodeIfPresent(String.self, forKey: .status)
//        message = try values.decodeIfPresent(String.self, forKey: .message)
//        verfied_msg = try values.decodeIfPresent(String.self, forKey: .verfied_msg)
//        listdata = try values.decodeIfPresent([Listdata].self, forKey: .listdata)
//    }

}


struct GroupListData : Codable {
    let groupid : String?
    let groupname : String?
    let group_type : String?
    let neighbrhood : String?
    let username : String?
    let membercount : Int?
    let getjoin : String?
    let pendingRequestCount : String?
    let description : String?
    let image : String?
    let userid : String?
    let status : String?
    let favouritstatus : Int?

    enum CodingKeys: String, CodingKey {

        case groupid = "groupid"
        case groupname = "groupname"
        case group_type = "group_type"
        case neighbrhood = "neighbrhood"
        case username = "username"
        case membercount = "membercount"
        case getjoin = "getjoin"
        case pendingRequestCount = "pendingRequestCount"
        case description = "description"
        case image = "image"
        case userid = "userid"
        case status = "status"
        case favouritstatus = "favouritstatus"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        groupid = try values.decodeIfPresent(String.self, forKey: .groupid)
        groupname = try values.decodeIfPresent(String.self, forKey: .groupname)
        group_type = try values.decodeIfPresent(String.self, forKey: .group_type)
        neighbrhood = try values.decodeIfPresent(String.self, forKey: .neighbrhood)
        username = try values.decodeIfPresent(String.self, forKey: .username)
        membercount = try values.decodeIfPresent(Int.self, forKey: .membercount)
        getjoin = try values.decodeIfPresent(String.self, forKey: .getjoin)
        pendingRequestCount = try values.decodeIfPresent(String.self, forKey: .pendingRequestCount)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        userid = try values.decodeIfPresent(String.self, forKey: .userid)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        favouritstatus = try values.decodeIfPresent(Int.self, forKey: .favouritstatus)
    }

}
