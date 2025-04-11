//
//  LatestListModel.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 17/09/24.
//



//// MARK: - Welcome
//struct LatestListModel: Codable {
//    let status: Int?
//    let neighborhood: Neighborhood?
//    let verfiedMsg: String?
//    let producttodaylist: [LatestListData]?
//
//    enum CodingKeys: String, CodingKey {
//        case status, neighborhood
//        case verfiedMsg = "verfied_msg"
//        case producttodaylist
//    }
//}
//
//enum NeighborhoodL: String, Codable {
//    case sector16A = "Sector 16A"
//    case sector18 = "Sector 18"
//}
//
//// MARK: - Producttodaylist
//struct LatestListData: Codable {
//    let id: Int?
//    let pTitle, pDescription: String?
//    let pQuantity: Int?
//    let saleType: SaleTypeL?
//    let salePrice, brandName, sellerName: String?
//    let catID: Int?
//    let pImages: String?
//    let pStatus, neighborhoodID, createdBy: Int?
//    let neighborhoodName: NeighborhoodL?
//    let wishlistStatus: Int?
//    let catName: String?
//    let createdTime, updatedTime: AtedTime?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case pTitle = "p_title"
//        case pDescription = "p_description"
//        case pQuantity = "p_quantity"
//        case saleType = "sale_type"
//        case salePrice = "sale_price"
//        case brandName = "brand_name"
//        case sellerName = "seller_name"
//        case catID = "cat_id"
//        case pImages = "p_images"
//        case pStatus = "p_status"
//        case neighborhoodID = "neighborhood_id"
//        case createdBy = "created_by"
//        case neighborhoodName = "neighborhood_name"
//        case wishlistStatus = "wishlist_status"
//        case catName = "cat_name"
//        case createdTime = "created_time"
//        case updatedTime = "updated_time"
//    }
//}
//
//enum AtedTime: String, Codable {
//    case the1D = "1d"
//    case the4D = "4d"
//}
//
//enum SaleTypeL: String, Codable {
//    case sell = "Sell"
//}


import Foundation

// Model for the product list items
struct LatestListData: Codable {
    let id: Int?
    let pTitle: String?
    let pDescription: String?
    let pQuantity: Int?
    let saleType: String?
    let salePrice: String?
    let brandName: String?
    let sellerName: String?
    let catId: Int?
    let pImages: String?
    let pStatus: Int?
    let neighborhoodId: Int?
    let createdBy: Int?
    let neighborhoodName: String?
    let wishlistStatus: Int?
    let catName: String?
    let createdTime: String?
    let updatedTime: String?

    enum CodingKeys: String, CodingKey {
        case id
        case pTitle = "p_title"
        case pDescription = "p_description"
        case pQuantity = "p_quantity"
        case saleType = "sale_type"
        case salePrice = "sale_price"
        case brandName = "brand_name"
        case sellerName = "seller_name"
        case catId = "cat_id"
        case pImages = "p_images"
        case pStatus = "p_status"
        case neighborhoodId = "neighborhood_id"
        case createdBy = "created_by"
        case neighborhoodName = "neighborhood_name"
        case wishlistStatus = "wishlist_status"
        case catName = "cat_name"
        case createdTime = "created_time"
        case updatedTime = "updated_time"
    }
}

// Main model for the response
struct LatestListModel: Codable {
    let status: Int?
    let neighborhood: String?
    let verfiedMsg: String?
    let productTodayList: [LatestListData]?

    enum CodingKeys: String, CodingKey {
        case status
        case neighborhood
        case verfiedMsg = "verfied_msg"
        case productTodayList = "producttodaylist"
    }
}
