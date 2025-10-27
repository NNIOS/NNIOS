//
//  EventDetails_Model.swift
//  Neighbrsnooks
//
//  Created by Abdul Aleem on 29/09/25.
//

import Foundation

//MARK: - EventAttendModel
struct EventAttendResponse:Codable {
    var status:IntOrBoolOrString
    var code:Int
    var message:String
}

//MARK: - EventUnattendModel
struct EventUnattendRespnse:Codable {
    var status:IntOrBoolOrString
    var code:Int
    var message:String
}

//MARK: - eventImageModel
struct EventImageResponse:Codable {
    var status:IntOrBoolOrString
    var code:Int
    var message:String
}

//MARK: - eventImageDeleteModel
struct EventImageDeleteResponse:Codable {
    var status:IntOrBoolOrString
    var code:Int
    var message:String
}

//MARK: - eventLikeModel
struct EventLikeResponse: Codable {
    let status: IntOrBoolOrString
    let code: Int
    let message: String
    let data: EventLikeData
}

struct EventLikeData: Codable {
    let event_id: String
    let liked: Bool
}

//MARK: - eventDetailEncryptedModel
struct EventDetailsResponse:Codable {
    var status:IntOrBoolOrString
    var code:Int
    var message:String
    var data:String
}

//MARK: - eventDetailDecyptedModel
struct decryptEvent:Codable {
    var data: DecryptEventDetailModel?
}

struct DecryptEventDetailModel: Codable {
    var status: IntOrBoolOrString
    var code: Int
    var message: String
    var data: EventDataList
}

struct EventDataList: Codable {
    var id: Int
    var title: String
    var userid: Int
    var event_date: String
    var event_end_date: String
    var event_start_time: String
    var event_end_time: String
    var cover_image: String
    var event_detail: String
    var address_line_one: String
    var address_line_two: String
    var neighborhood_name_date_time: String
    var username: String
    var userpic: String
    var auth_join: Int
    var auth_like: Bool
    var total_joins: Int
    var total_likes: Int
    var total_comments: Int
    var event_running: Bool
    var event_infuture: Bool
    var event_attender: [EventAttender]
    var event_unattender: [EventUnattender]
    var attender_count: Int
    var unattender_count: Int
    var images: [EventImage]
    var event_img_limit: Int
    var event_image_size: Int
    var event_img_remain_limit: Int
}

struct EventAttender: Codable {
    var event_id: Int
    var user_id: Int
    var neighborhood: String
    var name: String
    var userpic: String
    var joined_status: Bool
}

struct EventUnattender: Codable {
    var event_id: Int
    var user_id: Int
    var neighborhood: String
    var name: String
    var userpic: String
    var joined_status: Bool
}

struct EventImage: Codable {
    var id: Int
    var image_path: String
    var type: String
    var user_id: Int
}

