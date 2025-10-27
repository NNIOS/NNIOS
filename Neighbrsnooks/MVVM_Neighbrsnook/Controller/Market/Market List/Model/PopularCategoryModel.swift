//
//  PopularCategoryModel.swift
//  Neighbrsnooks
//
//  Created by Abdul Aleem on 07/10/25.
//

import Foundation

struct PopularCategoryResponse:Codable {
    var status:Bool
    var code:Int
    var message:String
    var data:String
}


// MARK: - DecryptPopularCategoryResponse
struct DecryptPopularCategoryResponse: Codable {
    let data: DecryptPopularCategoryData
}


struct DecryptPopularCategoryData: Codable {
    let categories: [PopularCategory]
    let marketplace_limits: MarketplaceLimitsData
}

struct PopularCategory: Codable {
    let id: Int
    let name: String
    let image: String
    let description: String
    let created_by: Int
    let status: Int
    let created_at: String
    let updated_at: String
}

struct MarketplaceLimitsData: Codable {
    let mpk_product_image_limit: Int
    let mpk_product_image_size_mb: Int
    let mpk_product_video_limit: Int
    let mpk_product_video_size_mb: Int
    let mpk_today_list_res_wall_limit: Int
    let mpk_today_list_days_wall_limit: Int
    let mpk_cat_list_res_wall_limit: Int
    let mpk_allproduct_list_res_wall_limit: Int
    let mpk_allproduct_list_days_wall_limit: Int
    let mpk_wishlist_list_res_wall_limit: Int
    let mpk_mylist_list_res_wall_limit: Int
}
