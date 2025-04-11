//
//  LoginModel.swift
//  NeighbrsNook Latest
//
//  Created by Rajat Rao on 19/02/24.
//

import Foundation

// MARK: - Welcome
//struct LoginModel: Codable {
//    let status, message: String?
//    let logindata: loginData
//}
//
//// MARK: - Logindata
//struct loginData: Codable {
//    let id: Int?
//    let username, firstname, lastname, emailid: String?
//    let phoneno, addlineone, addlinetwo, country: String?
//    let state: String?
//    let city, pincode, verified: Int?
//    let verifiedMessage, membercount: String?
//    let userphoto: String?
//    let logintype: String?
//    let andlink, ioslink: String?
//    let neighbrshood, reqNdbstatus: Int?
//
//    enum CodingKeys: String, CodingKey {
//        case id, username, firstname, lastname, emailid, phoneno, addlineone, addlinetwo, country, state, city, pincode, verified
//        case verifiedMessage = "verified_message"
//        case membercount, userphoto, logintype, andlink, ioslink, neighbrshood
//        case reqNdbstatus = "req_ndbstatus"
//    }
//}
//
//


import Foundation

// MARK: - Welcome
struct LoginModel: Codable {
    let status, message: String?
    let logindata: loginData?  // Optional banaya
}

// MARK: - Logindata
struct loginData: Codable {
    let id: Int?
    let username, firstname, lastname, emailid: String?
    let phoneno, addlineone, addlinetwo, country: String?
    let state: String?
    let city, pincode, verified: Int?
    let verifiedMessage, membercount: String?
    let userphoto: String?
    let logintype: String?
    let andlink, ioslink: String?
    let neighbrshood, reqNdbstatus: Int?

    enum CodingKeys: String, CodingKey {
        case id, username, firstname, lastname, emailid, phoneno, addlineone, addlinetwo, country, state, city, pincode, verified
        case verifiedMessage = "verified_message"
        case membercount, userphoto, logintype, andlink, ioslink, neighbrshood
        case reqNdbstatus = "req_ndbstatus"
    }
}
