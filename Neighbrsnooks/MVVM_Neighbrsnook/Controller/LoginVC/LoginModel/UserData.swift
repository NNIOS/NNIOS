//
//  UserData.swift
//  Neighbrsnooks
//
//  Created by Irshad Malik on 17/09/25.
//

import Foundation

// MARK: - User Data Model (SAFE)
struct UserData: Codable {
    let user_id: IntOrString?
    let profile_picture: String?
    let first_step: BoolOrInt?
    let second_step: BoolOrInt?
    let third_step: BoolOrInt?
    let name: String?
    let is_verified_message: String?
    let created_at: String?
    let date_of_birth: String?
    let email: String?
    let phone: String?
    let emergency_phone: String?
    let address: String?
    let pincode: String?
    let city: String?
    let state: String?
    let country: String?
    let full_address: String?
    let intrest: String?
    let profession: String?
    let reasons: String?
    let gender: String?
    let uploaded_doc: String?
    let neighborhood_id: IntOrString?
    let neighborhood_name: String?
    let post_count: IntOrString?
    let market_count: IntOrString?
    let event_count: IntOrString?
    let business_count: IntOrString?
    let group_count: IntOrString?
    let total_post_count: IntOrString?
    let total_market_count: IntOrString?
    let total_event_count: IntOrString?
    let total_business_count: IntOrString?
    let total_group_count: IntOrString?
    let post_percentage: IntOrString?
    let market_percentage: IntOrString?
    let event_percentage: IntOrString?
    let business_percentage: IntOrString?
    let group_percentage: IntOrString?
    let favourite_count: IntOrString?
    let total_favourite_count: IntOrString?
    let favourite_percentage: IntOrString?
    let polls_count: IntOrString?
    let total_polls_count: IntOrString?
    let poll_percentage: IntOrString?
    
    // NEW KEYS
    let message: String?
    let firebase_token: String?
    let verified: BoolOrInt?
    let doc_image: DocImage?

    // Nested struct for doc_image
    struct DocImage: Codable {
        let front: String?
        let back: String?
    }
}


// Flexible decoding for Int values that can be Int or String (including "")
enum IntOrString: Codable {
    case int(Int)
    case string(String)
    case none

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let intVal = try? container.decode(Int.self) {
            self = .int(intVal)
        } else if let strVal = try? container.decode(String.self), !strVal.isEmpty {
            self = .string(strVal)
        } else {
            self = .none
        }
    }

    func intValue(default: Int = 0) -> Int {
        switch self {
            case .int(let v): return v
            case .string(let s): return Int(s) ?? `default`
            case .none: return `default`
        }
    }

    func stringValue() -> String? {
        switch self {
            case .int(let v): return String(v)
            case .string(let s): return s
            case .none: return nil
        }
    }
}

// Flexible decoding for Bool values that can be Int, Bool, or String
enum BoolOrInt: Codable {
    case bool(Bool)
    case int(Int)
    case string(String)
    case none

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let intVal = try? container.decode(Int.self) {
            self = .int(intVal)
        } else if let boolVal = try? container.decode(Bool.self) {
            self = .bool(boolVal)
        } else if let strVal = try? container.decode(String.self), !strVal.isEmpty {
            self = .string(strVal)
        } else {
            self = .none
        }
    }

    func boolValue() -> Bool {
        switch self {
            case .bool(let b): return b
            case .int(let i): return i != 0
            case .string(let s): return s == "1" || s.lowercased() == "true"
            case .none: return false
        }
    }
}
