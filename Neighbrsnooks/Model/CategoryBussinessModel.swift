//
//  CategoryBussinessModel.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 31/05/24.
//

import Foundation

// MARK: - Welcome
struct CategoryBussinessModel: Codable {
    let status, message, businessImgLimit, businessImageSize: String
    let businessDocLimit, businessDocSize, businessVideoSize: String
    let nbdata: [AddPCategoryData]
    let businessVideoLimit: String

    enum CodingKeys: String, CodingKey {
        case status, message
        case businessImgLimit = "business_img_limit"
        case businessImageSize = "business_image_size"
        case businessDocLimit = "business_doc_limit"
        case businessDocSize = "business_doc_size"
        case businessVideoSize = "business_video_size"
        case nbdata
        case businessVideoLimit = "business_video_limit"
    }
}

// MARK: - Nbdatum
struct AddPCategoryData: Codable {
    let id, businessTitle: String

    enum CodingKeys: String, CodingKey {
        case id
        case businessTitle = "business_title"
    }
}

