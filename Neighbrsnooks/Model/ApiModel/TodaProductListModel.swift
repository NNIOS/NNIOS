//
//  TodaProductListModel.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 07/09/24.
//

import Foundation

// MARK: - Welcome
struct TodaProductListModel: Codable {
    let status: Int?
    let neighborhood, verfiedMsg: String?
    let producttodaylist: [ProductListData]?

    enum CodingKeys: String, CodingKey {
        case status, neighborhood
        case verfiedMsg = "verfied_msg"
        case producttodaylist
    }
}

// MARK: - Producttodaylist
struct ProductListData: Codable {
    let id: Int?
    let pTitle, pDescription: String?
    let pQuantity: Int?
    let saleType, salePrice: String?
    let brandName: String?
    let sellerName: String?
    let catID: String?
    let pImages: String?
    let pStatus, neighborhoodID, createdBy: Int?
    let neighborhoodName: String?
    let wishlistStatus: Int?
    let catName: String?
    let createdTime, updatedTime: String?

    enum CodingKeys: String, CodingKey {
        case id
        case pTitle = "p_title"
        case pDescription = "p_description"
        case pQuantity = "p_quantity"
        case saleType = "sale_type"
        case salePrice = "sale_price"
        case brandName = "brand_name"
        case sellerName = "seller_name"
        case catID = "cat_id"
        case pImages = "p_images"
        case pStatus = "p_status"
        case neighborhoodID = "neighborhood_id"
        case createdBy = "created_by"
        case neighborhoodName = "neighborhood_name"
        case wishlistStatus = "wishlist_status"
        case catName = "cat_name"
        case createdTime = "created_time"
        case updatedTime = "updated_time"
    }
}

// MARK: - Encode/decode helpers


