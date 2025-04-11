//
//  BusinessCategoryModel.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 06/08/24.
//

import Foundation

// MARK: - Welcome
struct BusinessCategoryModel: Codable {
    let status, message, businessImgLimit, businessImageSize: String?
    let businessDocLimit, businessDocSize, businessVideoLimit, businessVideoSize: String?
    let nbdata: [BussinessCategoryData]?

    enum CodingKeys: String, CodingKey {
        case status, message
        case businessImgLimit = "business_img_limit"
        case businessImageSize = "business_image_size"
        case businessDocLimit = "business_doc_limit"
        case businessDocSize = "business_doc_size"
        case businessVideoLimit = "business_video_limit"
        case businessVideoSize = "business_video_size"
        case nbdata
    }
}

// MARK: - Nbdatum
struct BussinessCategoryData: Codable {
    let id, businessTitle: String?

    enum CodingKeys: String, CodingKey {
        case id
        case businessTitle = "business_title"
    }
}

