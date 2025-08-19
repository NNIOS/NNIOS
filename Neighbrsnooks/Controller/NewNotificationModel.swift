//  NewNotificationModel.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 03/09/24.
//

import Foundation

import Foundation

// MARK: - Welcome
struct NewNotificationModel: Codable {
    let status, message, commentOnYourPostsMB, commentpostmail: String
    let commentLikesOnYourSuggestionMB, commentsuggestionmail, pollForVoteMB, pollvotemail: String
    let notificationForEventMB, notificationeventmail, directMessageMB, directmsgmail: String
    let newGroupMB, groupcreatemail, ratingReviewsOnYourBusinessMB, ratingCommentbusinessmail: String
    var sendMessageMarketMB, sendMessageMarketEmail, contactNo, emergencyContactno: String
    var address,profession: String

    enum CodingKeys: String, CodingKey {
        case status, message
        case commentOnYourPostsMB = "commentOnYourPostsMb"
        case commentpostmail
        case commentLikesOnYourSuggestionMB = "commentLikesOnYourSuggestionMb"
        case commentsuggestionmail
        case pollForVoteMB = "pollForVoteMb"
        case pollvotemail
        case notificationForEventMB = "notificationForEventMb"
        case notificationeventmail
        case directMessageMB = "directMessageMb"
        case directmsgmail
        case newGroupMB = "newGroupMb"
        case groupcreatemail
        case ratingReviewsOnYourBusinessMB = "rating_reviewsOnYourBusinessMb"
        case ratingCommentbusinessmail = "rating_commentbusinessmail"
        case sendMessageMarketMB = "SendMessageMarketMB"
        case sendMessageMarketEmail = "SendMessageMarketEmail"
        case contactNo, emergencyContactno,profession,address
    }
}
