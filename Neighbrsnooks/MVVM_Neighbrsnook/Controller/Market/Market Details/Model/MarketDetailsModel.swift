//
//  MarketDetailsModel.swift
//  Neighbrsnooks
//
//  Created by Abdul Aleem on 08/10/25.
//

import Foundation

struct MarketDetailsResponse:Codable {
    var status: Bool
    var code:Int
    var message:String
    var data: String
}

import Foundation

struct DecryptMarketDetailsResponse: Codable {
    let data: MarketDetailList
}

struct MarketDetailList: Codable {
    let status: Bool
    let code: Int
    let message: String
    let verified: Bool
    let data: MarketDetailsData
}

struct MarketDetailsData: Codable {
    let productdetail: ProductDetailData
    let Similar_Products: [SimilarProductData]
}

struct ProductDetailData: Codable {
    let id: Int
    let user_id: Int
    let username: String
    let userpic: String
    let neighborhood_id: Int
    let neighborhood_name: String
    let p_title: String
    let p_description: String
    let p_quantity: Int
    let sale_type: String
    let sale_price: String
    let brand_name: String
    let cat_id: Int
    let cat_name: String
    let p_status: Bool
    let sale_status: Bool
    let read_count: Int
    let wishlist_count: Int
    let auth_wishlist_status: Bool
    let media: [ProductMedia]
    let created_at: String
    let updated_at: String
}

struct ProductMedia: Codable {
    var img: String?
    var video:String?
//    let video:String
}

struct SimilarProductData: Codable {
    let id: Int
    let user_id: Int
    let username: String
    let userpic: String
    let neighborhood_id: Int
    let neighborhood_name: String
    let p_title: String
    let p_description: String
    let p_quantity: Int
    let sale_type: String
    let sale_price: String
    let brand_name: String
    let cat_id: Int
    let p_status: Bool
    let sale_status: Bool
    let wishlist_count: Int
    let auth_wishlist_status: Bool
    let image: String
    let created_at: String
    let updated_at: String
}
