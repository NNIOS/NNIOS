//
//  LoginModel.swift
//  Neighbrsnooks
//
//  Created by Irshad Malik on 16/09/25.
//

import Foundation

// MARK: - Login API Response (Encrypted)
struct LoginApiResponse: Codable {
    let data: String?
    let error: String?
    let code: Int?
    let status: StatusValue?
    let message: String?
    
}

// MARK: - Decrypt Login API Response (Nested)
struct DecryptLoginApiResponse: Codable {
    let data: DecryptTokenData?
    let code: Int?
    let message: String?
    let status: StatusValue?
}

struct DecryptTokenData: Codable {
    let code: Int?
    let data: LoginTokenResponse?
    let message: String?
    let status: StatusValue?
}

struct LoginTokenResponse: Codable {
    let id: Int?
    let token: String?
}

// MARK: - Decrypt Profile API Response (Nested)
struct DecryptProfileApiResponse: Codable {
    let data: DecryptProfileData?
    let code: Int?
    let message: String?
    let status: StatusValue?
}

struct DecryptProfileData: Codable {
    let code: Int?
    let data: UserData?
    let message: String?
    let status: StatusValue?
}

// MARK: - Status Enum
enum StatusValue: Codable {
    case int(Int)
    case bool(Bool)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let intVal = try? container.decode(Int.self) {
            self = .int(intVal)
        } else if let boolVal = try? container.decode(Bool.self) {
            self = .bool(boolVal)
        } else {
            throw DecodingError.typeMismatch(StatusValue.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "status neither Int nor Bool"))
        }
    }

    func asBoolOrInt() -> Bool {
        switch self {
            case .int(let val): return val == 1
            case .bool(let val): return val
        }
    }
}
