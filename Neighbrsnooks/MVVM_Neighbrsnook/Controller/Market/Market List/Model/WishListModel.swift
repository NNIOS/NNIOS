//
//  WishListModel.swift
//  Neighbrsnooks
//
//  Created by Abdul Aleem on 07/10/25.  WishList
//

import Foundation

struct WishListResponse:Codable {
    var status:Bool
    var code:Int
    var message:String
    var data:String
}

struct DecryptWishlistResponse: Codable {
    let data: WishlistMainData
}

struct WishlistMainData: Codable {
    let status: Bool
    let code: Int
    let message: String
    let verified: Bool
    let data: WishlistDataWrapper
}

struct WishlistDataWrapper: Codable {
    let Auth_Wishlist: [WishlistProduct]
}

struct WishlistProduct: Codable {
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
