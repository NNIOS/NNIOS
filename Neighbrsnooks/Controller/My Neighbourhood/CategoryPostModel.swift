//
//  CategoryPostModel.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 19/06/24.
//

import Foundation

// MARK: - Welcome
struct CategoryPostModel: Codable {
    let status, message, postImgLimit, postImageSize: String?
    let postVideoLimit, postVideoSize: String?
    let nbdata: [CategoryPostData]

    enum CodingKeys: String, CodingKey {
        case status, message
        case postImgLimit = "post_img_limit"
        case postImageSize = "post_image_size"
        case postVideoLimit = "post_video_limit"
        case postVideoSize = "post_video_size"
        case nbdata
    }
}

// MARK: - Nbdatum
struct CategoryPostData: Codable {
    let id, postTitle: String?

    enum CodingKeys: String, CodingKey {
        case id
        case postTitle = "post_title"
    }
}


