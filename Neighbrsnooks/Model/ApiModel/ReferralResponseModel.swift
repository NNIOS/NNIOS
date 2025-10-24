//
//  ReferralResponseModel.swift
//  Neighbrsnooks
//
//  Created by Irshad Malik on 17/10/25.
//
import Foundation

struct ReferralResponseList: Codable {
    let success: Bool
    let message: String
    let data: ReferralDataModel
}

struct ReferralDataModel: Codable {
    let currentPage: Int
    let data: [ReferralItem]
    let firstPageURL: String
    let from: Int
    let lastPage: Int
    let lastPageURL: String
    let links: [LinkModel]
    let nextPageURL: String
    let path: String
    let perPage: Int
    let prevPageURL: String
    let to: Int
    let total: Int
    let referrer: ReferrerModel
    let referredList: [ReferredUserModel]

    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case data
        case firstPageURL = "first_page_url"
        case from
        case lastPage = "last_page"
        case lastPageURL = "last_page_url"
        case links
        case nextPageURL = "next_page_url"
        case path
        case perPage = "per_page"
        case prevPageURL = "prev_page_url"
        case to
        case total
        case referrer
        case referredList = "referred_list"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        currentPage = try container.decode(Int.self, forKey: .currentPage)
        data = try container.decode([ReferralItem].self, forKey: .data)
        firstPageURL = try container.decode(String.self, forKey: .firstPageURL)

        if let fromInt = try? container.decode(Int.self, forKey: .from) {
            from = fromInt
        } else {
            let fromString = try container.decode(String.self, forKey: .from)
            from = Int(fromString) ?? 0
        }

        lastPage = try container.decode(Int.self, forKey: .lastPage)
        lastPageURL = try container.decode(String.self, forKey: .lastPageURL)
        links = try container.decode([LinkModel].self, forKey: .links)
        nextPageURL = try container.decode(String.self, forKey: .nextPageURL)
        path = try container.decode(String.self, forKey: .path)
        perPage = try container.decode(Int.self, forKey: .perPage)
        prevPageURL = try container.decode(String.self, forKey: .prevPageURL)

        if let toInt = try? container.decode(Int.self, forKey: .to) {
            to = toInt
        } else {
            let toString = try container.decode(String.self, forKey: .to)
            to = Int(toString) ?? 0
        }

        total = try container.decode(Int.self, forKey: .total)
        referrer = try container.decode(ReferrerModel.self, forKey: .referrer)
        referredList = try container.decode([ReferredUserModel].self, forKey: .referredList)
    }
}


struct LinkModel: Codable {
    let url: String
    let label: String
    let active: Bool
}

struct ReferrerModel: Codable {
    let id: Int
    let name: String
    let emailid: String
    let phoneno: String
    let neighborhood: Int
    let status: Int
    let updatedByStatus: String
    let updatedByStatusDate: String
    let createddate: String
    let updatedate: String
    let isSalesperson: Int
    let totalReferrals: Int
    let pendingReferrals: Int
    let neighbourhoodName: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case emailid
        case phoneno
        case neighborhood
        case status
        case updatedByStatus = "updated_by_status"
        case updatedByStatusDate = "updated_by_status_date"
        case createddate
        case updatedate
        case isSalesperson = "is_salesperson"
        case totalReferrals = "total_referrals"
        case pendingReferrals = "pending_referrals"
        case neighbourhoodName = "neighbourhood_name"
    }
}

struct ReferredUserModel: Codable {
    let id: Int
    let referrerUserID: Int
    let referredName: String
    let referredPhone: String
    let referredEmail: String
    let neighbourhoodID: Int
    let referralCode: String
    let status: String
    let referredAt: String
    let completedAt: String
    let referredUserID: String
    let remarks: String
    let createdAt: String
    let updatedAt: String
    let referredUser: String
    let neighbourhoodName: String

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
        case referredUser = "referred_user"
        case neighbourhoodName = "neighbourhood_name"
    }
}

struct ReferralItem: Codable {}
