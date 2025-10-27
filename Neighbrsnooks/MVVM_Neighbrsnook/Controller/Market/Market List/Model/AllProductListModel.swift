//
//  AllProductListModel.swift
//  Neighbrsnooks
//
//  Created by Abdul Aleem on 07/10/25.
//

import Foundation

struct AllProductListResponse:Codable {
    var status:Bool
    var code:Int
    var message:String
    var data:String
}

// MARK: - DecryptAllListProductResponse
struct DecryptAllProductListResponse: Codable {
    let data: AllListProductMainData
}

struct AllListProductMainData: Codable {
    let status: Bool
    let code: Int
    let message: String
    let verified: Bool
    let data: AllProductListDataWrapper
}

struct AllProductListDataWrapper: Codable {
    let all_products_list: AllProductsListData
}

struct AllProductsListData: Codable {
    let current_page: Int
    let data: [AllProductData]
    let first_page_url: String
    let from: Int
    let last_page: Int
    let last_page_url: String
    let links: [AllProductLink]
    let next_page_url: String
    let path: String
    let per_page: Int
    let prev_page_url: String
    let to: Int
    let total: Int
}

struct AllProductData: Codable {
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
// MARK: - AllProductLink
struct AllProductLink: Codable {
    let url: String
    let label: String
    let active: Bool
}
