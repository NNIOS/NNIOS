//
//  UserLocationModel.swift
//  NeighbrsNook Latest Latest
//
//  Created by Irshad Malik on 18/03/25.
//

import Foundation

struct UserLocationModel: Codable {
    let status, message: String?
    let userid: Int?
    let latitude, longitude: Double?
    let areaName, addressOne, addressTwo: String?
    let countryName, stateName, cityName: String?
    let pincode: Int?

    // CodingKeys enum to map JSON keys to struct properties
    enum CodingKeys: String, CodingKey {
        case status, message, userid
        case latitude, longitude
        case areaName = "area_name"
        case addressOne = "addlineone"
        case addressTwo = "addlinetwo"
        case countryName = "country_name"
        case stateName = "state_name"
        case cityName = "city_name"
        case pincode
    }

    // Custom initializer for decoding
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        status = try container.decodeIfPresent(String.self, forKey: .status)
        message = try container.decodeIfPresent(String.self, forKey: .message)
        userid = try container.decodeIfPresent(Int.self, forKey: .userid)
        latitude = try container.decodeIfPresent(Double.self, forKey: .latitude)
        longitude = try container.decodeIfPresent(Double.self, forKey: .longitude)
        areaName = try container.decodeIfPresent(String.self, forKey: .areaName)
        addressOne = try container.decodeIfPresent(String.self, forKey: .addressOne)
        addressTwo = try container.decodeIfPresent(String.self, forKey: .addressTwo)
        countryName = try container.decodeIfPresent(String.self, forKey: .countryName)
        stateName = try container.decodeIfPresent(String.self, forKey: .stateName)
        cityName = try container.decodeIfPresent(String.self, forKey: .cityName)
        pincode = try container.decodeIfPresent(Int.self, forKey: .pincode)
    }
}
