//
//  SoldModel.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 11/02/25.
//

import Foundation

// MARK: - Welcome
struct SoldModel: Codable {
    let status: String?
    let message: String?
}

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
    case firstname, welcomeImg, likeStatus, userBokay
    case totalLike = "total_like"
    case totalBokay = "total_bokay" // <-- Correct mapping
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
