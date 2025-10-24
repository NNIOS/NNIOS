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

// MARK: - LoginModel (root level)
struct LoginModel: Codable {
    let status, message: String?
    let logindata: loginData?
    let id: String?

    // New properties added at root level (based on your JSON)
    let refer_neighbourhood_id: String?
    let refer_neighbourhood_name: String?
    let referral_status: Int?
    let refer_city_name: String?          // added
    let refer_country_name: String?       // added
    let refer_pincode: String?                // added; use Int if number
    let refer_state_name: String?         // added
    
    enum CodingKeys: String, CodingKey {
        case status, message, logindata, id
        case refer_neighbourhood_id
        case refer_neighbourhood_name
        case referral_status
        case refer_city_name                 // added
        case refer_country_name              // added
        case refer_pincode                  // added
        case refer_state_name               // added
    }
}

// MARK: - loginData
// MARK: - loginData
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


//MARK: - ResetPasswordModel


struct ResetPasswordModel: Codable {
    let status: String?
    let message: String?
}




//MARK: - Model for the inner description
struct VerifyOTPDescription: Codable {
    let desc: String?
}

// Main model for the response
struct VerifyOTPModel: Codable {
    let status: String?
    let description: VerifyOTPDescription
}

struct VerifyEmailModel:Codable {
    var status: Bool?
    var code: Int?
    var message: String?
}
