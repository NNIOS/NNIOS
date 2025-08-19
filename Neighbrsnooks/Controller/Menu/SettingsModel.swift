//
//  SettingsModel.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 23/05/24.
//

import Foundation

// MARK: - Welcome
struct SettingsModel: Codable {
    let status, message, commentpostmail, commentsuggestionmail: String?
    let pollForVoteMB, notificationeventmail, directmsgmail, groupcreatemail: String?
    let ratingCommentbusinessmail, emergencyContactno, addresslinetwo, commentOnYourPostsMB: String?
    let commentLikesOnYourSuggestionMB, pollvotemail, notificationForEventMB, directMessageMB: String?
    let newGroupMB, ratingReviewsOnYourBusinessMB: String?
    var address:String?

    enum CodingKeys: String, CodingKey {
        case status, message, commentpostmail, commentsuggestionmail
        case pollForVoteMB = "pollForVoteMb"
        case notificationeventmail, directmsgmail, groupcreatemail
        case ratingCommentbusinessmail = "rating_commentbusinessmail"
        case emergencyContactno, addresslinetwo
        case commentOnYourPostsMB = "commentOnYourPostsMb"
        case commentLikesOnYourSuggestionMB = "commentLikesOnYourSuggestionMb"
        case pollvotemail
        case notificationForEventMB = "notificationForEventMb"
        case directMessageMB = "directMessageMb"
        case newGroupMB = "newGroupMb"
        case ratingReviewsOnYourBusinessMB = "rating_reviewsOnYourBusinessMb"
        case address
    }
}
