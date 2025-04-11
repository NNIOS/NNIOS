//
//  FavouriteListModel.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 31/07/24.
//


import Foundation

// MARK: - Welcome
struct FavouriteListModel: Codable {
    let status, message: String?
   
    let myNeighborhoodID: String?
    let myNeighborhood: String?
    let verfiedMsg, missmatchRemarks, awaitStatus, memberCount: String?
    let verifiedStatus: String?
    let popupVerifiedStatus: Int?
    var listdata: [FavoriteListData]

    enum CodingKeys: String, CodingKey {
        case status, message
        case myNeighborhoodID = "my_neighborhood_id"
        case myNeighborhood = "my_neighborhood"
        case verfiedMsg = "verfied_msg"
        case popupVerifiedStatus = "popup_verified_status"
        case missmatchRemarks = "missmatch_remarks"
        case awaitStatus = "await_status"
        case memberCount = "member_count"
        case verifiedStatus = "verified_status"
        case listdata
    }
}
// MARK: - HomeNewData
struct FavoriteListData: Codable {
    let type, hID, createdby, userpic: String?
    let username, createdOn, groupid, neighborhood: String?
    let groupName, groupDescription, groupImage, groupType: String?
    let groupStatus: String?
    var favouritstatus: Int?
    let getjoin, pendingRequestCount: String?
    let membercount: Int?
    let sponsorID, caption, description, company: String?
    let companylink, externallink, playstorelink, companylogo: String?
    let bannerimage, action, eventid, eventName: String?
    let eventDescription, eventCoverImage, eventStartDate, eventEndDate: String?
    let willeventstart, iseventrunning, welcomeid, welcomeMsg: String?
    let firstname, welcomeImg, likeStatus, userBokay: String?
    let totalLike, totalBokay: Int?
    let likedata, bokaydata: [DatumF]?
    let postid, postType, postMessage, status: String?
    let emojiStatus, userEmoji: String?
    let totalEmojis: Int?
    let emojilistdata: [EmojilistdatumF]?
    let postImagesN: [PostImageF]?
    let postlike, postemojiunicode, totcomment, totallike: String?
    let pollid, pollTitle, pollQuestion, pollStartDate: String?
    let pollEndDate, isvoted, totalvote, ispollrunning: String?
    let bID, businessName, businessTagline, businessDesc: String?
    let category, businessStatus: String?
    
    
    let businessImage: [BusinessImage]?
    let businessVideo: [String]?
    let review: Int?

    enum CodingKeys: String, CodingKey {
        case type
        case hID = "h_id"
        case createdby, userpic, username
        case createdOn = "created_on"
        case groupid, neighborhood
        case groupName = "group_name"
        case groupDescription = "group_description"
        case groupImage = "group_image"
        case groupType = "group_type"
        case groupStatus = "group_status"
        case favouritstatus, getjoin, pendingRequestCount, membercount
        case sponsorID = "sponsor_id"
        case postImagesN = "post_images"
        case caption, description, company, companylink, externallink, playstorelink, companylogo, bannerimage, action, eventid
        case eventName = "event_name"
        case eventDescription = "event_description"
        case eventCoverImage = "event_cover_image"
        case eventStartDate = "event_start_date"
        case eventEndDate = "event_end_date"
        case willeventstart, iseventrunning, welcomeid
        case welcomeMsg = "welcome_msg"
        case firstname, welcomeImg, likeStatus, userBokay, totalLike, totalBokay
        case likedata, bokaydata, postid, status
        case emojiStatus = "emoji_status"
        case userEmoji = "user_emoji"
        case totalEmojis = "total_emojis"
        case emojilistdata, postlike, postemojiunicode, totcomment, totallike
        case pollid, pollTitle = "poll_title"
        case pollQuestion = "poll_question"
        case pollStartDate = "poll_start_date"
        case pollEndDate = "poll_end_date"
        case isvoted, totalvote, ispollrunning, bID = "b_id"
        case businessName = "business_name"
        case businessTagline = "business_tagline"
        case businessDesc = "business_desc"
        case category, businessStatus = "business_status"
       
        
        case businessImage = "business_image"
               case businessVideo = "business_video"
        case postType = "post_type"
        case postMessage = "post_message"

        case review
    }
}// MARK: - Datum
struct DatumF: Codable {
    let welcomeid, userid, username, userpic: String?
    let neighbrhood: String?
    let bokay: String?
    let createon: String?
    let like: String?
}

struct PostImageF: Codable {
    let img: String?
    let video: String?
}

// MARK: - BusinessImage


// MARK: - EmojilistdatumN
struct EmojilistdatumF: Codable {
    let postid, userid, username, userpic: String?
    let neighbrhood: String?
    let emoji, emojiunicode, createon: String?
}

struct BusinessImage: Codable {
    let img: String?
    let video: String?
}





