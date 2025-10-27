//
//  PostCommentListDecryptModel.swift
//  Neighbrsnooks
//
//  Created by Irshad Malik on 06/10/25.
//

import Foundation

// MARK: - CommentListModel
// Decrypt response root
struct PostCommentListDecryptModel: Codable {
    let data: CommentListDataClass
}

struct CommentListDataClass: Codable {
    let status: Bool
    let code: Int
    let message: String
    let data: [CommentListDatum]
}

struct CommentListDatum: Codable {
    let postID, commentID: Int
    let message: String
    let userID: Int
    let userFullName: String
    let userpic: String
    let neighborhoodName: String
    let createdAt: String
    let likeCount: Int
    let commentCount: Int?
    let authLiked: Bool
    let replies: [CommentListDatum]?
    let parentCommentUserID: Int?
    let parentCommentUserFullName: String?
    let parentCommentCount: Int?

    enum CodingKeys: String, CodingKey {
        case postID = "post_id"
        case commentID = "comment_id"
        case message
        case userID = "user_id"
        case userFullName = "user_full_name"
        case userpic
        case neighborhoodName = "neighborhood_name"
        case createdAt = "created_at"
        case likeCount = "like_count"
        case commentCount = "comment_count"
        case authLiked = "auth_liked"
        case replies
        case parentCommentUserID = "parent_comment_user_id"
        case parentCommentUserFullName = "parent_comment_user_full_name"
        case parentCommentCount = "parent_comment_count"
    }
}


enum CreatedAt: String, Codable {
    case the1Month = "1 month"
    case the2Months = "2 months"
    case the3Months = "3 months"
    case the4Months = "4 months"
    case the6Months = "6 months"
}

enum Message: String, Codable {
    case firstCommentNested = "First Comment nested"
    case firstCommentNestedSecond = "First Comment nested second"
    case firstCommentNestedsss = "First Comment nestedsss"
    case thisIsTestingComment = "This is testing comment"
}

enum NeighborhoodName: String, Codable {
    case sector16 = "Sector 16"
    case sector16A = "Sector 16A"
}

enum UserFullName: String, Codable {
    case navi = "Navi"
    case shubham = "Shubham"
}
