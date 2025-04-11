//
//  CreatePostModel.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 19/06/24.
//

//import Foundation
//
//// MARK: - Welcome
//struct CreatePostModel: Codable {
//    let status, message: String?
//    let postid: Int?
//    let username, posttype, neighbrhood, postmsg: String?
//    let postimg: [CreatePostData]
//    let imgSize: String?
//
//    enum CodingKeys: String, CodingKey {
//        case status, message, postid, username, posttype, neighbrhood, postmsg, postimg
//        case imgSize = "img_size"
//    }
//}
//
//// MARK: - Postimg
//struct CreatePostData: Codable {
//    let img: String?
//}


import Foundation

// MARK: - Welcome
struct CreatePostModel: Codable {
    let status, message: String?
    let postid: Int?
    let username, posttype, neighbrhood, postmsg: String?
    let postimg: [CreatePostData]?
    let imgSize: String?

    enum CodingKeys: String, CodingKey {
        case status, message, postid, username, posttype, neighbrhood, postmsg, postimg
        case imgSize = "img_size"
    }
}

// MARK: - Postimg
struct CreatePostData: Codable {
    let video: String?
    let img: String?
}
