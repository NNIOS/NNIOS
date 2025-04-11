//
//  BusinessReviewModel.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 06/08/24.
//

import Foundation

// MARK: - Welcome
struct BusinessReviewModel: Codable {
    let status, message: String?
    var listdata: [BusinessReviewData]?
}

// MARK: - Listdatum
struct BusinessReviewData: Codable {
    let username: String?
    let userpic: String?
    let review, reviewDate, neighbrhood, userid: String?
    let id: String?

    enum CodingKeys: String, CodingKey {
        case username, userpic, review
        case reviewDate = "review_date"
        case neighbrhood, userid, id
    }
}



// MARK: - DeleteBusinessReview Model


struct DeleteBusinessReviewModel: Codable {
    let status, message: String
}

