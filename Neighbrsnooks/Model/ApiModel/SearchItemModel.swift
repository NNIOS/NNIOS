//
//  SearchItemModel.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 23/09/24.
//

import Foundation

// MARK: - Welcome
struct SearchItemModel: Codable {
    let status: Int?
    let neighborhood: NeighborhoodS?
    let verfiedMsg: String?
    let producthomelist: [MySearchitemsData]??

    enum CodingKeys: String, CodingKey {
        case status, neighborhood
        case verfiedMsg = "verfied_msg"
        case producthomelist
    }
}

enum NeighborhoodS: String, Codable {
    case sector15 = "Sector 15"
    case sector16A = "Sector 16A"
    case sector18 = "Sector 18"
}

// MARK: - Producthomelist
struct MySearchitemsData: Codable {
    let id: Int?
    let pTitle, pDescription: String?
    let pQuantity: Int?
    let saleType: SaleTypeS?
    let salePrice, brandName: String?
    let sellerName: SellerName?
    let catID: Int?
    let pImages: String?
    let pStatus, neighborhoodID, createdBy: Int?
    let neighborhoodName: Neighborhood?
    let wishlistStatus: Int?
    let catName: CatName?
    let createdTime, updatedTime: AtedTime?

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

enum CatName: String, Codable {
    case electronics = "Electronics"
}

enum AtedTime: String, Codable {
    case the13D = "13d"
    case the1Month = "1 month"
    case the2Months = "2 months"
    case the3Months = "3 months"
    case the4Months = "4 months"
    case the9D = "9d"
}

enum SaleTypeS: String, Codable {
    case donate = "Donate"
    case sell = "Sell"
}

enum SellerName: String, Codable {
    case arsadAliPasha = "Arsad Ali Pasha"
    case luinaSingh = "Luina Singh"
    case mohdArsadPasha = "Mohd Arsad Pasha"
    case nagendraYadav = "Nagendra Yadav"
    case pavanDubey = "Pavan Dubey"
    case shubhamSinghRajput = "Shubham Singh Rajput"
}

