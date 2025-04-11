//
//  BussinessListModel.swift
//  NeighbrsNook Latest
//
//  Created by Mac on 03/04/24.
//

import Foundation

// MARK: - Welcome
struct BussinessListModel: Codable {
    let status, message, addlineone, addlinetwo: String?
    let countryName, stateName, cityName, pin: String?
    let verfiedMsg: String?
    let listdata: [BusinessListData]
    

    enum CodingKeys: String, CodingKey {
        case status, message, addlineone, addlinetwo
        case countryName = "country_name"
        case stateName = "state_name"
        case cityName = "city_name"
        case pin
        case verfiedMsg = "verfied_msg"
        case listdata
    }
}

// MARK: - Listdatum
struct BusinessListData: Codable {
    let id, name, tagline, description: String?
    let neighborhood: String?
    let review: Int?
    let rating, userid: String?
    let userpic: String?
    let username, web, weeklyOff, doctype: String?
    let doc, opentime, phoneNo, bisaddress: String?
    let state, country, city, pincode: String?
    let email, tel, frtime, clstime: String?
    let add1, add2, category, catid: String?
    let businessstatus: String?
    let ratingStatus, reviewstatus, fastatus: Int?
    let image: [ImageBussi]?
    let video: [String]?

    enum CodingKeys: String, CodingKey {
        case id, name, tagline, description, neighborhood, review, rating, userid, userpic, username, web
        case weeklyOff = "weekly_off"
        
        case doctype, doc, opentime
        case phoneNo = "phone_no"
        case bisaddress, state, country, city, pincode, email, tel, frtime, clstime, add1, add2, category, catid, businessstatus
        case ratingStatus = "rating_status"
        case reviewstatus, fastatus, image, video
    }
    
    
}

struct ImageBussi: Codable {
    let img: String?
    let video : String?
    
}

