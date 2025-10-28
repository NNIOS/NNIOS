
import Foundation
 
// MARK: - Welcome
struct HomeAllModel: Codable {
    let status, message: String?
    let announcement: [Announcement]?
    let myNeighborhoodID: String?
    let myNeighborhood: String?
    let verfiedMsg, missmatchRemarks, awaitStatus, memberCount: String?
    let verifiedStatus: String?
    let popupVerifiedStatus: Int?
    let missmatchStatus: String?
    var listdata: [HomeNewData]?
    let referredUserMsg: String?

    enum CodingKeys: String, CodingKey {
        case status, message, announcement
        case myNeighborhoodID = "my_neighborhood_id"
        case myNeighborhood = "my_neighborhood"
        case verfiedMsg = "verfied_msg"
        case missmatchStatus = "missmatch_status"
        case popupVerifiedStatus = "popup_verified_status"
        case missmatchRemarks = "missmatch_remarks"
        case awaitStatus = "await_status"
        case memberCount = "member_count"
        case verifiedStatus = "verified_status"
        case listdata
        case referredUserMsg = "referred_user_msg"
    }
}

// MARK: - Announcement
struct Announcement: Codable {
    let title, msg: String?
}

// MARK: - HomeNewData
struct HomeNewData: Codable {
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
    var firstname, welcomeImg, like_status, user_bokay: String?
    var total_like, total_bokay: Int?
    let likedata, bokaydata: [Datum]?
    let postid, postType, postMessage, status: String?
    var emojiStatus, userEmoji: String?
    let totalEmojis: Int?
    let emojilistdata: [EmojilistdatumN]?
    var postImagesN: [postImagesN]?
    var postlike, postemojiunicode, totcomment, totallike: String?
    let pollid, pollTitle, pollQuestion, pollStartDate: String?
    let pollEndDate, isvoted, totalvote, ispollrunning: String?
    let bID, businessName, businessTagline, businessDesc: String?
    let category, businessStatus: String?
    let businessImage: [BusinessImageH]?
    let businessVideo: [String]?
    let review: Int?
    var didGiveLike: Bool = false
    var didGiveBookay: Bool = false


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
        case firstname, welcomeImg, like_status, user_bokay, total_like, total_bokay
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
}

// MARK: - Datum
struct Datum: Codable {
    let welcomeid, userid, username, userpic: String?
    let neighbrhood: String?
    let bokay: String?
    let createon: String?
    let like: String?
}

// MARK: - EmojilistdatumN
struct EmojilistdatumN: Codable {
    let postid, userid, username, userpic: String?
    let neighbrhood: String?
    let emoji, emojiunicode, createon: String?
}

// MARK: - BusinessImageH
struct BusinessImageH: Codable {
    let img: String?
    let video: String?
}

struct postImagesN: Codable {
    let img: String?
    let video: String?
}

extension HomeNewData {
    var isLiked: Bool {
        return postlike == "1"
    }

    var likeCount: Int {
        return Int(totallike ?? "0") ?? 0
    }

    var emojiunicode: String? {
        return userEmoji?.isEmpty == false ? userEmoji : postemojiunicode
    }
}
