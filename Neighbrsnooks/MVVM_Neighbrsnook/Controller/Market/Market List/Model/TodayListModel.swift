//
//  TodayListModel.swift
//  Neighbrsnooks
//
//  Created by Abdul Aleem on 07/10/25.
//

import Foundation

struct TodayListResponse:Codable {
    var status:Bool
    var code:Int
    var message:String
    var data:String
}

// MARK: - DecryptTodayListResponse
struct DecryptTodayListResponse: Codable {
    let data: TodayListMainData?
}

struct TodayListMainData: Codable {
    let status: Bool
    let code: Int
    let message: String
    let verified: Bool
    let data: TodayListDataWrapper
}

struct TodayListDataWrapper: Codable {
    let today_list: [TodayListProduct]
}

struct TodayListProduct: Codable {
    let id: Int
    let p_title: String
    let p_description: String
    let p_quantity: Int
    let sale_type: String
    let sale_status: Bool
    let sale_price: String
    let brand_name: String
    let seller_name: String
    let cat_id: Int
    let cat_name: String
    let p_images: String
    let p_status: Bool
    let neighborhood_id: Int
    let neighborhood_name: String
    let wishlist_status: Bool
    let created_time: String
    let updated_time: String
}
