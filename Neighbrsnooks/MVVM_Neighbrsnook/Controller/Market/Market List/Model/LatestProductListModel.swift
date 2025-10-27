//
//  LatestProductListModel.swift
//  Neighbrsnooks
//
//  Created by Abdul Aleem on 07/10/25.
//

import Foundation

struct LatestProductListResponse:Codable {
    var status:Bool
    var code:Int
    var message:String
    var data:String
}

struct DecryptLatestListResponse: Codable {
    var data: LatestProductListData
}

struct LatestProductListData: Codable {
    var status: Bool
    var code: Int
    var message: String
    var verified: Bool
    var data: TodayListData
}

struct TodayListData: Codable {
    var today_list: [TodayListItem]
}

struct TodayListItem: Codable {
    var id: Int
    var p_title: String
    var p_description: String
    var p_quantity: Int
    var sale_type: String
    var sale_status: Bool
    var sale_price: String
    var brand_name: String
    var seller_name: String
    var cat_id: Int
    var cat_name: String
    var p_images: String
    var p_status: Bool
    var neighborhood_id: Int
    var neighborhood_name: String
    var wishlist_status: Bool
    var created_time: String
    var updated_time: String
}
