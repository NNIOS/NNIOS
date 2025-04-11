//
//  WishlistModel.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 17/09/24.
//

import Foundation

// MARK: - Welcome
import Foundation

// MARK: - Welcome
struct WishlistModel: Codable {
    let status: String?
    let wishlist: [WishListListData]?
}

// MARK: - Wishlist
struct WishListListData: Codable {
    let id, userID, productID: Int?
    let pTitle, pDescription: String?
    let pQuantity: Int?
    let saleType, salePrice, brandName, sellerName: String?
    let catID: Int?
    let catName: String?
    let pImages: String
    let pStatus, neighborhoodID: Int?
    let neighborhoodName: String?
    let createdBy: Int?
    let createdTime, updatedTime: String?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case productID = "product_id"
        case pTitle = "p_title"
        case pDescription = "p_description"
        case pQuantity = "p_quantity"
        case saleType = "sale_type"
        case salePrice = "sale_price"
        case brandName = "brand_name"
        case sellerName = "seller_name"
        case catID = "cat_id"
        case catName = "cat_name"
        case pImages = "p_images"
        case pStatus = "p_status"
        case neighborhoodID = "neighborhood_id"
        case neighborhoodName = "neighborhood_name"
        case createdBy = "created_by"
        case createdTime = "created_time"
        case updatedTime = "updated_time"
    }
}
