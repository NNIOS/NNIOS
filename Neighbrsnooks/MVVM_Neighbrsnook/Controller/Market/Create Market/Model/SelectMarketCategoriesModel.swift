//
//  SelectMarketCategoriesModel.swift
//  Neighbrsnooks
//
//  Created by Abdul Aleem on 06/10/25.
//

import Foundation


struct SelectMarketCategoriesResponse: Codable {
    var status:Bool
    var code:Int
    var message:String
    var data:String
}



struct DecryptedSelctedMarketCatResponse: Codable {
    let data: DecryptSelectMarketCategories
}

struct DecryptSelectMarketCategories: Codable {
    let categories: [SelectedCategory]
    let marketplace_limits: MarketplaceLimits
}

struct SelectedCategory: Codable {
    let id: Int
    let name: String
    let image: String
    let description: String
    let created_by: Int
    let status: Int
    let created_at: String
    let updated_at: String
}

struct MarketplaceLimits: Codable {
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
