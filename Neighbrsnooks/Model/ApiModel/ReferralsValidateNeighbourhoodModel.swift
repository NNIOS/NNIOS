//
//  ValidateNeighbourhoodReferralModel.swift
//  Neighbrsnooks
//
//  Created by Irshad Malik on 29/10/25.
//

import Foundation

// MARK: - ValidateNeighbourhoodReferralModel
struct ValidateNeighbourhoodReferralModel: Codable {
    let status: String
    let data: ValidateDataClass
}

// MARK: - DataClass
struct ValidateDataClass: Codable {
    let userid, neighborhoodID, referrerUserID, referrerNeighbourhoodStatus: Int
    let referrerMsg: String

    enum CodingKeys: String, CodingKey {
        case userid
        case neighborhoodID = "neighborhood_id"
        case referrerUserID = "referrer_user_id"
        case referrerNeighbourhoodStatus = "referrer_neighbourhood_status"
        case referrerMsg = "referrer_msg"
    }
}
