//
//  PostDetailModel.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 09/01/25.
//

import Foundation

// MARK: - Welcome
//struct PostDetailModel: Codable {
//    let status, message, verifiedMsg: String?
//    let listdata: [PostDetailData]?
//
//    enum CodingKeys: String, CodingKey {
//        case status, message
//        case verifiedMsg = "verified_msg"
//        case listdata
//    }
//}
//
//// MARK: - Listdatum
//struct PostDetailData: Codable {
//    let postid: Int
//    let postType, neighborhood: String?
//    let postImages: [PostImageD]?
//    let postMessage: String?
//    let status: Int?
//    let emojiStatus, userEmoji, postlike: String?
//    let totalEmojis, totcomment, totallike: Int?
//    let postemojiunicode: String?
//    let emojilistdata: [String]
//    let createdOn: String?
//    let createdby, favouritstatus: Int?
//    let username: String?
//    let userpic: String?
//
//    enum CodingKeys: String, CodingKey {
//        case postid
//        case postType = "post_type"
//        case neighborhood
//        case postImages = "post_images"
//        case postMessage = "post_message"
//        case status
//        case emojiStatus = "emoji_status"
//        case userEmoji = "user_emoji"
//        case postlike
//        case totalEmojis = "total_emojis"
//        case totcomment, totallike, postemojiunicode, emojilistdata
//        case createdOn = "created_on"
//        case createdby, favouritstatus, username, userpic
//    }
//}
//
//// MARK: - PostImage
//struct PostImageD: Codable {
//    let img: String?
//    let video: String?
//}
//



struct PostDetailModel: Codable {
    let status, message, verifiedMsg: String?
    let listdata: [PostDetailData]?

    enum CodingKeys: String, CodingKey {
        case status, message
        case verifiedMsg = "verified_msg"
        case listdata
    }
}

struct PostDetailData: Codable {
    let postid: Int?
    let postType, neighborhood: String?
    let postImages: [PostImageD]?
    let postMessage: String?
    let status: Int?
    let emojiStatus, userEmoji, postlike: String?
    let totalEmojis, totcomment, totallike: Int?
    let postemojiunicode: String?
    let emojilistdata: [EmojiListData]?
    let createdOn: String?
    let createdby, favouritstatus: Int?
    let username: String?
    let userpic: String?

    enum CodingKeys: String, CodingKey {
        case postid
        case postType = "post_type"
        case neighborhood
        case postImages = "post_images"
        case postMessage = "post_message"
        case status
        case emojiStatus = "emoji_status"
        case userEmoji = "user_emoji"
        case postlike
        case totalEmojis = "total_emojis"
        case totcomment, totallike, postemojiunicode
        case emojilistdata
        case createdOn = "created_on"
        case createdby, favouritstatus, username, userpic
        
    }
}

struct PostImageD: Codable {
    let img: String?
    let video: String? // safe to keep as optional even if absent
}

struct EmojiListData: Codable {
    let postid, userid: String?
    let username, userpic, neighbrhood, emoji, emojiunicode, createon: String?
}
