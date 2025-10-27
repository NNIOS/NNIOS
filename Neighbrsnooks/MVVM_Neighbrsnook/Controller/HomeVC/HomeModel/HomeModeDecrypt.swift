//
//  ModeDecrypt.swift
//  Neighbrsnooks
//
//  Created by Irshad Malik on 24/09/25.
//

import Foundation

struct HomeDecryptOuter: Codable {
    let data: HomeModelDecrypt
}


struct HomeModelDecrypt: Codable {
    let status: Bool
    let code: Int
    let data: HomeData
}

struct HomeData: Codable {
    let announcement: [HomeAnnouncement]
    let myNeighborhoodId: Int
    let myNeighborhood: String
    let verfiedMsg: String
    let popupVerifiedStatus: Int
    let missmatchStatus: String
    let missmatchRemarks: String
    let awaitStatus: Bool
    let memberCount: Int
    let verifiedStatus: Bool
    let currentPage: Int
    let perPage: Int
    let total: Int
    let data: [HomeItem]

    enum CodingKeys: String, CodingKey {
        case announcement, data
        case myNeighborhoodId = "my_neighborhood_id"
        case myNeighborhood = "my_neighborhood"
        case verfiedMsg = "verfied_msg"
        case popupVerifiedStatus = "popup_verified_status"
        case missmatchStatus = "missmatch_status"
        case missmatchRemarks = "missmatch_remarks"
        case awaitStatus = "await_status"
        case memberCount = "member_count"
        case verifiedStatus = "verified_status"
        case currentPage = "current_page"
        case perPage = "per_page"
        case total
    }
}

struct HomeAnnouncement: Codable {
    let id: Int
    let title: String
    let message: String
    let coverImg: String
    let startDate: String
    let endDate: String
    let links: String
    let neighborhoods: [String]
    enum CodingKeys: String, CodingKey {
        case id, title, message, links, neighborhoods
        case coverImg = "cover_img"
        case startDate = "start_date"
        case endDate = "end_date"
    }
}

enum HomeItem: Codable {
    case post(HomePostItem)
    case business(HomeBusinessItem)
    case sponsor(HomeSponsorItem)
    case welcome(HomeWelcomeItem)
    case event(HomeEventItem)
    case poll(HomePollItem)
    case group(HomeGroupItem)

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decodeIfPresent(String.self, forKey: .type)
        switch type {
        case "Post": self = .post(try HomePostItem(from: decoder))
        case "Business": self = .business(try HomeBusinessItem(from: decoder))
        case "Sponsor": self = .sponsor(try HomeSponsorItem(from: decoder))
        case "Welcome": self = .welcome(try HomeWelcomeItem(from: decoder))
        case "Event": self = .event(try HomeEventItem(from: decoder))
        case "Poll": self = .poll(try HomePollItem(from: decoder))
        case "Group": self = .group(try HomeGroupItem(from: decoder))
        default:
            throw DecodingError.typeMismatch(HomeItem.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Unknown type"))
        }
    }
    func encode(to encoder: Encoder) throws {
        switch self {
        case .post(let item): try item.encode(to: encoder)
        case .business(let item): try item.encode(to: encoder)
        case .sponsor(let item): try item.encode(to: encoder)
        case .welcome(let item): try item.encode(to: encoder)
        case .event(let item): try item.encode(to: encoder)
        case .poll(let item): try item.encode(to: encoder)
        case .group(let item): try item.encode(to: encoder)
        }
    }
    enum CodingKeys: String, CodingKey {
        case type
    }
}

struct HomeWelcomeItem: Codable {
    let type: String
    let id: Int
    let userId: Int
    let username: String
    let createdOn: String
    let neighborhood: String
    let welcomeMsg: String
    let firstname: String
    let welcomeImg: String
    let likeStatus: Bool
    let userBokay: Bool
    let totalLike: Int
    let totalBokay: Int
    let likedata: [LikeData]
    let bokaydata: [BokayData]
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case type, id, username, neighborhood, firstname, likedata, bokaydata
        case userId = "user_id"
        case createdOn = "created_on"
        case welcomeMsg = "welcome_msg"
        case welcomeImg = "welcome_img"
        case likeStatus = "like_status"
        case userBokay = "user_bokay"
        case totalLike = "total_like"
        case totalBokay = "total_bokay"
        case createdAt = "created_at"
    }
}
struct LikeData: Codable {}
struct BokayData: Codable {}


struct HomeEventItem: Codable {
    let id: Int
    let type: String
    let userID: Int
    let neighborhoodID: Int
    let neighborhoodName: String
    let eventTitle: String
    let eventDescription: String
    let eventCreatedAt: String
    let eventUpdatedAt: String
    let username: String
    let userpic: String
    let eventMedia: String
    let eventStartDate: String
    let eventEndDate: String
    let eventWillEventStart: Bool
    let eventIsEventRunning: Bool
    let eventAuthFavorites: Bool
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id, type, username, userpic
        case userID = "user_id"
        case neighborhoodID = "neighborhood_id"
        case neighborhoodName = "neighborhood_name"
        case eventTitle = "event_title"
        case eventDescription = "event_description"
        case eventCreatedAt = "event_created_at"
        case eventUpdatedAt = "event_updated_at"
        case eventMedia = "event_media"
        case eventStartDate = "event_start_date"
        case eventEndDate = "event_end_date"
        case eventWillEventStart = "event_willeventstart"
        case eventIsEventRunning = "event_iseventrunning"
        case eventAuthFavorites = "event_auth_favorites"
        case createdAt = "created_at"
    }
}

struct HomePollItem: Codable {
    let type: String
    let id: Int
    let userId: Int
    let neighborhoodId: Int
    let neighborhoodName: String
    let userpic: String
    let username: String
    let pollCreatedOn: String
    let pollTitle: String
    let pollQuestion: String
    let pollStartDate: String
    let pollEndDate: String
    let pollAuthVote: Bool
    let pollAuthFavourite: Bool
    let pollTotalVote: Int
    let pollIsRunning: Bool
    let pollStatus: String
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case type, id, userpic, username
        case userId = "user_id"
        case neighborhoodId = "neighborhood_id"
        case neighborhoodName = "neighborhood_name"
        case pollCreatedOn = "poll_created_on"
        case pollTitle = "poll_title"
        case pollQuestion = "poll_question"
        case pollStartDate = "poll_start_date"
        case pollEndDate = "poll_end_date"
        case pollAuthVote = "poll_auth_vote"
        case pollAuthFavourite = "poll_auth_favourite"
        case pollTotalVote = "poll_total_vote"
        case pollIsRunning = "poll_ispollrunning"
        case pollStatus = "poll_status"
        case createdAt = "created_at"
    }
}

struct HomeGroupItem: Codable {
    let id: Int
    let type: String
    let groupCreatedBy: Int
    let username: String
    let userpic: String
    let groupCreatedOn: String
    let neighborhoodId: Int
    let neighborhoodName: String
    let groupName: String
    let groupDescription: String
    let groupImage: String
    let groupType: String
    let groupStatus: Bool
    let groupFavouriteStatus: Bool
    let groupGetJoin: String
    let groupPendingRequestCount: String
    let groupMemberCount: Int
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id, type, username, userpic
        case groupCreatedBy = "group_createdby"
        case groupCreatedOn = "group_created_on"
        case neighborhoodId = "neighborhood_id"
        case neighborhoodName = "neighborhood_name"
        case groupName = "group_name"
        case groupDescription = "group_description"
        case groupImage = "group_image"
        case groupType = "group_type"
        case groupStatus = "group_status"
        case groupFavouriteStatus = "group_favouritstatus"
        case groupGetJoin = "group_getjoin"
        case groupPendingRequestCount = "group_pendingRequestCount"
        case groupMemberCount = "group_membercount"
        case createdAt = "created_at"
    }
}



// -- HomePostItem, HomePostMedia, HomePostEmoji --
struct HomePostItem: Codable {
    let id: Int
    let type: String
    let userId: Int
    let neighborhoodId: Int
    let neighborhoodName: String
    let postDescription: String
    let postCreatedAt: String
    let postUpdatedAt: String
    let username: String
    let userpic: String
    let postType: String
    let postMedia: [HomePostMedia]
    let postStatus: Bool
    let postAuthLike: Bool
    let postAuthFavorites: Bool
    let postAuthEmoji: Bool
    let postAuthEmojiCode: String
    let postTotallike: Int
    let postTotalEmojis: Int
    let postEmojilistdata: [HomePostEmoji]
    let postTotcomment: Int
    let createdAt: String
    enum CodingKeys: String, CodingKey {
        case id, type, username, userpic
        case userId = "user_id"
        case neighborhoodId = "neighborhood_id"
        case neighborhoodName = "neighborhood_name"
        case postDescription = "post_description"
        case postCreatedAt = "post_created_at"
        case postUpdatedAt = "post_updated_at"
        case postType = "post_type"
        case postMedia = "post_media"
        case postStatus = "post_status"
        case postAuthLike = "post_auth_like"
        case postAuthFavorites = "post_auth_favorites"
        case postAuthEmoji = "post_auth_emoji"
        case postAuthEmojiCode = "post_auth_emoji_code"
        case postTotallike = "post_totallike"
        case postTotalEmojis = "post_total_emojis"
        case postEmojilistdata = "post_emojilistdata"
        case postTotcomment = "post_totcomment"
        case createdAt = "created_at"
    }
}

struct HomePostMedia: Codable {
    let img: String?
    let video: String?
}

struct HomePostEmoji: Codable {
    let emojiType: String
    let userName: String
    let userImage: String
    let postId: Int
    let createdAt: String
    let neighborhoodName: String
    enum CodingKeys: String, CodingKey {
        case emojiType = "emoji_type"
        case userName = "user_name"
        case userImage = "user_image"
        case postId = "post_id"
        case createdAt = "created_at"
        case neighborhoodName = "neighborhood_name"
    }
}

// -- HomeBusinessItem, HomeBusinessMedia --
struct HomeBusinessItem: Codable {
    let id: Int
    let type: String
    let userId: Int
    let neighborhoodId: Int
    let neighborhoodName: String
    let businessTitle: String
    let businessTagline: String
    let businessDescription: String
    let businessCreatedAt: String
    let businessUpdatedAt: String
    let username: String
    let userpic: String
    let businessStatus: Bool
    let businessMedia: [HomeBusinessMedia]
    let businessCategory: String
    let businessAuthFavorites: Bool
    let businessRatingAverage: Int
    let businessReviewsCount: Int
    let createdAt: String
    enum CodingKeys: String, CodingKey {
        case id, type, username, userpic
        case userId = "user_id"
        case neighborhoodId = "neighborhood_id"
        case neighborhoodName = "neighborhood_name"
        case businessTitle = "business_title"
        case businessTagline = "business_tagline"
        case businessDescription = "business_description"
        case businessCreatedAt = "business_created_at"
        case businessUpdatedAt = "business_updated_at"
        case businessStatus = "business_status"
        case businessMedia = "business_media"
        case businessCategory = "business_category"
        case businessAuthFavorites = "business_auth_favorites"
        case businessRatingAverage = "business_rating_average"
        case businessReviewsCount = "business_reviews_count"
        case createdAt = "created_at"
    }
}

struct HomeBusinessMedia: Codable {
    let img: String?
    let video: String?
}

// -- HomeSponsorItem --
struct HomeSponsorItem: Codable {
    let type: String
    let sponsorId: Int
    let caption: String
    let description: String
    let company: String
    let companylink: String
    let externallink: String
    let playstorelink: String
    let pincode: String
    let email: String
    let location: String
    let phone: String
    let salesTeam: String
    let serviceType: String
    let profPositions: String
    let clickLimit: Int
    let startDate: String
    let endDate: String
    let companylogo: String
    let bannerimage: String
    let action: String
    enum CodingKeys: String, CodingKey {
        case type
        case sponsorId = "sponsor_id"
        case caption, description, company, companylink, externallink, playstorelink, pincode, email, location, phone
        case salesTeam = "sales_team"
        case serviceType = "service_type"
        case profPositions = "prof_positions"
        case clickLimit = "click_limit"
        case startDate = "start_date"
        case endDate = "end_date"
        case companylogo, bannerimage, action
    }
}
