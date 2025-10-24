//
//  ReferralModel.swift
//  Neighbrsnooks
//
//  Created by Irshad Malik on 15/10/25.
//

import Foundation

struct ReferralResponse: Codable {
    let success: Bool
    let message: String
    let data: ReferralData?
}

struct ReferralData: Codable {
    let referralId: Int
    let referralCode: String
    let referrerUserId: Int
    let referredName: String
    let referredPhone: String
    let referredEmail: String?    
    let neighbourhoodId: Int
    let status: String
    let referredAt: String
    
    enum CodingKeys: String, CodingKey {
        case referralId = "referral_id"
        case referralCode = "referral_code"
        case referrerUserId = "referrer_user_id"
        case referredName = "referred_name"
        case referredPhone = "referred_phone"
        case referredEmail = "referred_email"
        case neighbourhoodId = "neighbourhood_id"
        case status
        case referredAt = "referred_at"
    }
}


