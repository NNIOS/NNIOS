//
//  RegistationFirst_Request.swift
//  Neighbrsnooks
//
//  Created by Irshad Malik on 18/09/25.
//

import Foundation
//MARK: - Registation First Model
struct Register_Request: Encodable {
    let name: String
    let email: String
    let phone_no: String
    let password: String
    let firebase_token: String
    let terms: String
}


struct RegisterFirstResponse: Codable {
    let status: Bool
    let code: Int
    let message: String?
    let data: String?
    let error: String?
}

struct ValidationResponse_Register {
    let message: String?
    let isValid: Bool
}

//MARK: - Send Otp Model

struct SendOtpResponse: Codable {
    let status: Bool
    let code: Int
    let message: String?
    let data: String?
    let error: String?
}

//MARK: - VerifyOtpResponse Model

struct VerifyOtpResponse: Codable {
    let status: Bool
    let code: Int
    let message: String
    let data: String
}

// MARK: - Email Verify Model

struct emailVerifyModel: Codable {
    let status: IntOrBoolOrString      
    let code: Int?
    let error: String?
    let message: String?
}

struct userPicUpdateModel: Codable {
    let status: Bool
    let code: Int
    let message, data: String
}


// Custom Decoder for mixed status types:
enum IntOrBoolOrString: Codable {
    case int(Int)
    case bool(Bool)
    case string(String)
    
    var isSuccess: Bool {
        switch self {
        case .int(let v): return v == 1
        case .bool(let v): return v
        case .string(let v): return v == "1" || v.lowercased() == "true"
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let intV = try? container.decode(Int.self) { self = .int(intV) }
        else if let boolV = try? container.decode(Bool.self) { self = .bool(boolV) }
        else if let strV = try? container.decode(String.self) { self = .string(strV) }
        else { self = .string("") }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .int(let v): try container.encode(v)
        case .bool(let v): try container.encode(v)
        case .string(let v): try container.encode(v)
        }
    }
}




struct Validation_Service_Register {
    func validate(request: Register_Request) -> ValidationResponse_Register {
        guard !request.name.isEmpty else {
            return ValidationResponse_Register(message: "Name is required", isValid: false)
        }
        guard request.email.isValidEmail() else {
            return ValidationResponse_Register(message: "Invalid email format", isValid: false)
        }
        guard request.phone_no.count >= 7 && request.phone_no.count <= 14 else {
            return ValidationResponse_Register(message: "Phone number must be between 7-14 digits", isValid: false)
        }
        guard request.password.count >= 6 else {
            return ValidationResponse_Register(message: "Password must be at least 6 characters", isValid: false)
        }
        guard !request.firebase_token.isEmpty else {
            return ValidationResponse_Register(message: "Firebase token is required", isValid: false)
        }
        return ValidationResponse_Register(message: nil, isValid: true)
    }
}
