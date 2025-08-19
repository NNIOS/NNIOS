//
//  CommentPostModel.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 17/06/24.
//

import Foundation

//// MARK: - Welcome
struct CommentPostModel: Codable {
    let status, message: String
    var postlistdata: [Postlistdatum]
}

struct Postlistdatum: Codable {
    let pcID: String
    let postid: String
    let userid: String
    let commenttext: String
    let username: String
    let createon: String
    let userpic: String
    let totalLikes: String
    let userLikeStatus: String
    let totalComments: String
    let neighbrhood: String
    let replies: [Postlistdatum]?
    var isLiked: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case pcID = "pc_id"
        case totalComments = "total_comments"
        case totalLikes = "total_likes"
        case userLikeStatus = "user_like_status"
        case postid, userid, commenttext, username, createon, userpic, neighbrhood, replies
    }
}
