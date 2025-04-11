//
//  BusinessDetailModel.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 05/08/24.
//

import Foundation

// MARK: - Welcome
struct BusinessDetailModel: Codable {
    let status, message, id, businessName: String?
    let tagline, description, neighborhood, review: String?
    let rating, userid: String?
    let userpic: String?
    let username, web, weeklyOff, doctype: String?
    let document: [BussinessDetailData]?
    let opentime, mobile, bisaddress, email: String?
    let telephone, fromtime, totime, add1: String?
    let add2, cityID, city, stateID: String?
    let state, countryID, country, pincode: String?
    let category, catid, businessstatus, ratingStatus: String?
    let reviewstatus, fastatus: String?
    let image: [ImageBd]?
    let video: [String]?
    let createdDate: String?

    enum CodingKeys: String, CodingKey {
        case status, message, id
        case businessName = "business_name"
        case tagline, description, neighborhood, review, rating, userid, userpic, username, web
        case weeklyOff = "weekly_off"
        case doctype, document, opentime, mobile, bisaddress, email, telephone, fromtime, totime, add1, add2
        case cityID = "city_id"
        case city
        case stateID = "state_id"
        case state
        case countryID = "country_id"
        case country, pincode, category, catid, businessstatus
        case ratingStatus = "rating_status"
        case reviewstatus, fastatus, image, video
        case createdDate = "created_date"
    }
}

// MARK: - Document
struct BussinessDetailData: Codable {
    let doc: String?
}

// MARK: - Image
struct ImageBd: Codable {
    let img: String?
    let video: String?
    
}

// MARK: - Encode/decode helpers

