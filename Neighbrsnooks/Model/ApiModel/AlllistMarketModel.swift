//
//  AlllistMarketModel.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 17/09/24.
//

//import Foundation
//
//// MARK: - Welcome
//struct AlllistMarketModel: Codable {
//    let status: Int?
//    let neighborhood: NeighborhoodA?
//    let verfiedMsg: String?
//    let producthomelist: [AllListMarketData]?
//
//    enum CodingKeys: String, CodingKey {
//        case status, neighborhood
//        case verfiedMsg = "verfied_msg"
//        case producthomelist
//    }
//}
//
//enum NeighborhoodA: String, Codable {
//    case sector15 = "Sector 15"
//    case sector16A = "Sector 16A"
//    case sector18 = "Sector 18"
//}
//
//// MARK: - Producthomelist
//struct AllListMarketData: Codable {
//    let id: Int?
//    let pTitle, pDescription: String?
//    let pQuantity: Int?
//    let saleType: SaleTypeA?
//    let salePrice: String?
//    let brandName: String?
//    let sellerName: String?
//    let catID: Int?
//    let pImages: String?
//    let pStatus, neighborhoodID, createdBy: Int?
//    let neighborhoodName: NeighborhoodA?
//    let wishlistStatus: Int?
//    let catName: CatName?
//    let createdTime, updatedTime: AtedTimeA?
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
//enum CatName: String, Codable {
//    case automobiles = "Automobiles"
//    case books = "Books"
//    case clothingAccessories = "Clothing & accessories"
//    case coupons = "Coupons"
//    case electronics = "Electronics"
//    case footwear = "Footwear"
//    case furniture = "Furniture"
//    case homeDecor = "Home decor"
//    case kidsBabies = "Kids & babies"
//    case mobiles = "Mobiles"
//    case other = "Other"
//}
//
//enum AtedTimeA: String, Codable {
//    case the11D = "11d"
//    case the13D = "13d"
//    case the17D = "17d"
//    case the1D = "1d"
//    case the1Month = "1 month"
//    case the26D = "26d"
//    case the2Months = "2 months"
//    case the3Months = "3 months"
//    case the4D = "4d"
//    case the4Months = "4 months"
//    case the7D = "7d"
//    case the8D = "8d"
//}
//
//enum SaleTypeA: String, Codable {
//    case donate = "Donate"
//    case sell = "Sell"
//}
//

import Foundation

// MARK: - AlllistMarketModel
struct AlllistMarketModel: Codable {
    let status: Int?
    let neighborhood, verfiedMsg: String?
    let producthomelist: [AllListMarketData]?

    enum CodingKeys: String, CodingKey {
        case status
        case neighborhood
        case verfiedMsg = "verfied_msg"
        case producthomelist = "producthomelist"
    }
}

// MARK: - ProductHome
struct AllListMarketData: Codable {
    let id: Int?
    let pTitle, pDescription: String?
    let pQuantity: Int?
    let saleType: String?
    let salePrice, brandName, sellerName: String?
    let catID: Int?
    let pImages: String?
    let pStatus, neighborhoodID, createdBy: Int?
    let neighborhoodName: String?
    let wishlistStatus: Int?
    let catName, createdTime, updatedTime: String?

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
