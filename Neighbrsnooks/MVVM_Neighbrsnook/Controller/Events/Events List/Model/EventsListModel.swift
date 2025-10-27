//
//  EventsListModel.swift
//  Neighbrsnooks
//
//  Created by Abdul Aleem on 26/09/25.
//

import Foundation


//MARK: EventsListModel
struct EventsListResponse:Codable {
    var status:Bool
    var code:Int
    var message:String
    var data:String
}

// MARK: - DecryptPollDetailsModel
import Foundation

// MARK: - EventListDecryptModel
struct EventListDecryptModel: Codable {
    var data: EventListDataResponse
}

// MARK: - EventListData
struct EventListDataResponse: Codable {
    var status: Bool
    var code: Int
    var message: String
    var data: EventData
}

// MARK: - EventData
struct EventData: Codable {
    var verified_status: Bool
    var neighbourhood: String
    var event_count: Int
    var event_Past: [EventItem]
    var event_Current: [EventItem]
    var event_Future: [EventItem]
    var eventcount_past: Int
    var eventcount_current: Int
    var eventcount_future: Int
    var current_page: Int
    var last_page: Int
    var per_page: Int
    var total: Int
}

// MARK: - EventItem
struct EventItem: Codable {
    var id: Int
    var title: String
    var event_start_date: String
    var event_end_date: String
    var event_start_time: String
    var event_end_time: String
    var cover_image: String
    var event_detail: String
    var address_line_one: String
    var address_line_two: String
    var neighborhood_name: String
    var user_id: Int
    var user_name: String
    var status: Bool
    var auth_faviouraite: Bool
    var willeventstart: Bool
    var iseventrunning: Bool
}

// MARK: - EventDelete
struct EventDeleteResponse:Codable {
    var status: Bool
    var message:String
    var code:Int
}

// MARK: - EventUpdate
struct EventUpdateResponse:Codable {
    var status: Bool
    var message:String
    var code:Int
}


