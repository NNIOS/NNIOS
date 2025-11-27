//
//  OtpModel.swift
//  NeighbrsNook Latest
//
//  Created by Rajat Rao on 19/02/24.
//

import Foundation

// MARK: - Welcome

struct OtpModel: Codable {
    let status: Bool?
    let code: Int?
    let message: String?
    let requestId: String?   // server ka request_id

    var otp: String?         // optional, sirf OTP generate hone par
     
    // Map JSON keys to Swift property names
    enum CodingKeys: String, CodingKey {
        case status, code, message, otp
        case requestId = "request_id"
    }
}

