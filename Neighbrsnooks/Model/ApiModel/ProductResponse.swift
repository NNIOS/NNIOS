//
//  ProductResponse.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 10/09/24.
//

import Foundation

// MARK: - Main Response
struct ProductResponse: Codable {
    let status: Int?
    let productdetail: [ProductDetail]?
    let similarproducts: [SimilarProduct]?
  //  let similarproducts: [SimilarProductOrString]?

    enum CodingKeys: String, CodingKey {
        case status
        case productdetail = "productdetail"  // Key matching the JSON
        case similarproducts = "similarproducts" // Key matching the JSON
    }
}



enum SimilarProducts: Codable {
    case similarProductList([SimilarProduct])
    case stringList([String])

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let similarProductList = try? container.decode([SimilarProduct].self) {
            self = .similarProductList(similarProductList)
        } else if let stringList = try? container.decode([String].self) {
            self = .stringList(stringList)
        } else {
            throw DecodingError.typeMismatch(SimilarProducts.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Unable to decode SimilarProducts"))
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        switch self {
        case .similarProductList(let products):
            try container.encode(products)
        case .stringList(let strings):
            try container.encode(strings)
        }
    }
}


// MARK: - Product Detail
struct ProductDetail: Codable {
    let id: Int?
    let pTitle: String?
    let pDescription: String?
    let pQuantity: Int?
    let saleType: String?
    let salePrice: String?
    let brandName: String?
    let sellerName: String?
    let catID: Int?
    let pImages: [ProductImage]?
    let pStatus: Int?
    let neighborhoodID: Int?
    let createdBy: Int?
    let readCount: Int?
    let neighborhoodName: String?
    let catName: String?
    let wishlistStatus: Int?
    let userpic: String?
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
        case catID = "cat_id"
        case pImages = "p_images"
        case pStatus = "p_status"
        case neighborhoodID = "neighborhood_id"
        case createdBy = "created_by"
        case readCount = "read_count"
        case neighborhoodName = "neighborhood_name"
        case catName = "cat_name"
        case wishlistStatus = "wishlist_status"
        case userpic
        case createdTime = "created_time"
        case updatedTime = "updated_time"
    }
}

// MARK: - Product Image
struct ProductImage: Codable {
    let img: String?
    let video: String?
}

// MARK: - Similar Product
struct SimilarProduct: Codable {
    let id: Int?
    let pTitle: String?
    let pDescription: String?
    let pQuantity: Int?
    let saleType: String?
    let salePrice: String?
    let brandName: String?
    let sellerName: String?
    let catID: Int?
    let pImages: String?
    let pStatus: Int?
    let neighborhoodID: Int?
    let createdBy: Int?
    let neighborhoodName: String?
    let catName: String?
    let wishlistStatus: Int?
    let userpic: String?
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
        case catID = "cat_id"
        case pImages = "p_images"
        case pStatus = "p_status"
        case neighborhoodID = "neighborhood_id"
        case createdBy = "created_by"
        case neighborhoodName = "neighborhood_name"
        case catName = "cat_name"
        case wishlistStatus = "wishlist_status"
        case userpic
        case createdTime = "created_time"
        case updatedTime = "updated_time"
    }
}

var ProductDataM: [ProductDetail] = []


struct ChatReadModel:Codable {
    var status: Int?
    var message: String?
}
