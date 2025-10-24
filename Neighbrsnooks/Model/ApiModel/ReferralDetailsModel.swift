//
//  ReferralDetailsModel.swift
//  Neighbrsnooks
//
//  Created by Irshad Malik on 16/10/25.
//

import Foundation


// MARK: - ReferralDetailsModel
struct ReferralDetailsModel: Codable {
    let success: Bool
    let message: String
    let data: DataClass?
}

// MARK: - DataClass
struct DataClass: Codable {
    let id: Int?
    let referrerUserID: Int?
    let referredName, referredPhone, referredEmail: String?
    let neighbourhoodID: Int?
    let referralCode, status, referredAt, completedAt: String?
    let referredUserID, remarks, createdAt, updatedAt: String?
    let referrer: Referrer?
    let referredUser: String?

    enum CodingKeys: String, CodingKey {
        case id
        case referrerUserID = "referrer_user_id"
        case referredName = "referred_name"
        case referredPhone = "referred_phone"
        case referredEmail = "referred_email"
        case neighbourhoodID = "neighbourhood_id"
        case referralCode = "referral_code"
        case status
        case referredAt = "referred_at"
        case completedAt = "completed_at"
        case referredUserID = "referred_user_id"
        case remarks
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case referrer
        case referredUser = "referred_user"
    }
}

// MARK: - Referrer
struct Referrer: Codable {
    let id: Int?
    let name, emailid, phoneno: String?
    let status: Int?
    let updatedByStatus, updatedByStatusDate, createddate, updatedate: String?
    let isSalesperson, totalReferrals, pendingReferrals: Int?
    let nbdName: String?
    enum CodingKeys: String, CodingKey {
        case id, name, emailid, phoneno, status
        case updatedByStatus = "updated_by_status"
        case updatedByStatusDate = "updated_by_status_date"
        case createddate, updatedate
        case isSalesperson = "is_salesperson"
        case totalReferrals = "total_referrals"
        case pendingReferrals = "pending_referrals"
        case nbdName = "nbd_name"
    }
}
