//
//  EventListModel.swift
//  NeighbrsNook Latest
//
//  Created by Mac on 05/04/24.
//

import Foundation

// MARK: - Welcome
struct EventListModel: Codable {
    let status, message, neighbrhood, verfiedMsg: String
    let eventPast, eventCurrent, eventFuture: [EventListData]
    let evencountPast, eventcountCurrent, eventcountFuture: Int

    enum CodingKeys: String, CodingKey {
        case status, message, neighbrhood
        case verfiedMsg = "verfied_msg"
        case eventPast = "event_past"
        case eventCurrent = "event_current"
        case eventFuture = "event_future"
        case evencountPast = "evencount_past"
        case eventcountCurrent = "eventcount_current"
        case eventcountFuture = "eventcount_future"
    }
}

// MARK: - Event
struct EventListData: Codable {
    let id, title: String
    let coverImage: String
    let eventstartdate, eventenddate, eventStarttime, eventEndtime: String
    let eventDetail, willeventstart, iseventrunning, status: String
    let address, favouritstatus: String

    enum CodingKeys: String, CodingKey {
        case id, title
        case coverImage = "cover_image"
        case eventstartdate, eventenddate
        case eventStarttime = "event_starttime"
        case eventEndtime = "event_endtime"
        case eventDetail = "event_detail"
        case willeventstart, iseventrunning, status, address, favouritstatus
    }
}

