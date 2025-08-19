//
//  MessageModel.swift
//  NeighbrsNook Latest
//
//  Created by Mac on 02/05/24.
//

//import Foundation
//
//// MARK: - Welcome
//struct MessageModel: Codable {
//    let status, messages: String?
//    let nbdata: [ChatMessageData]
//}
//
//// MARK: - Nbdatum
//struct ChatMessageData: Codable {
//    let id, type, message, subject: String?
//    let userpic: String?
//    let dttime: String?
//}



import Foundation

// MARK: - MessageModel
struct MessageModel: Codable {
    let status: String?
    let message: String?
    var data: [ChatMessageData]?

    enum CodingKeys: String, CodingKey {
        case status
        case message = "messages"  // server se "messages" aa raha hai
        case data = "nbdata"
    }
}

// MARK: - ChatMessageData
struct ChatMessageData: Codable {
    let id: String?
    let type: String?
    let message: String?
    let subject: String?
    let userPic: String?
    let dateTime: String?
    var msg_id: Int?

    enum CodingKeys: String, CodingKey {
        case id, type, message, subject
        case userPic = "userpic"
        case dateTime = "dttime"
    }
}
