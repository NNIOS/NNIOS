//
//  MarketCategoryModel.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 13/09/24.
//

import Foundation

// MARK: - Welcome
struct MarketCategoryModel: Codable {
    let status, mpkProductImgLimit, mpkProductImgSize, mpkProductVideoLimit: Int?
    let mpkProductVideoSize: Int?
    let category: [MarketCatDataNew]?

    enum CodingKeys: String, CodingKey {
        case status
        case mpkProductImgLimit = "mpk_product_img_limit"
        case mpkProductImgSize = "mpk_product_img_size"
        case mpkProductVideoLimit = "mpk_product_video_limit"
        case mpkProductVideoSize = "mpk_product_video_size"
        case category
    }
}

// MARK: - Category
struct MarketCatDataNew: Codable {
    let id: Int?
    let catTitle, catDescription: String?
    let catStatus: Int?
    let catImage: String?
    let catCreateBy, createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case catTitle = "cat_title"
        case catDescription = "cat_description"
        case catStatus = "cat_status"
        case catImage = "cat_image"
        case catCreateBy = "cat_create_by"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

