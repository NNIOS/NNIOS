//
//  RegisterModel.swift
//  NeighbrsNook Latest
//
//  Created by Rajat Rao on 19/02/24.
//

import Foundation

// MARK: - Welcome
struct RegisterModel: Codable {
    let userid: Int?
    let status, message: String?
    let referral_status: Int?   // referral status
    let phone: String?          // phone number
    let refer_neighbourhood_id: String?
    let refer_neighbourhood_name: String?
    let refer_city_name: String?
    let refer_state_name: String?
    let refer_pincode: String?
}
