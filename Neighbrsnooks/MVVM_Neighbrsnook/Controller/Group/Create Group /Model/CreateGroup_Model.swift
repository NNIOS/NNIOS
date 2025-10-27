//
//  CreateGroup_Model.swift
//  Neighbrsnooks
//
//  Created by Abdul Aleem on 18/09/25.
//

import Foundation
struct CreateGroup_Request: Encodable {
    let name: String
    let image:String
    let description: String
    let join_type: String
//    let id: Int
}

struct CreateGroupResponse: Codable {
    let code: Int?
    let error:String?
    let message: String?
    let status: Bool?
}

struct ValidationResponse_CreateGroup {
    let message: String?
    let isValid: Bool
}


struct Validation_SCreateGroup{
    func validate(request: CreateGroup_Request) -> ValidationResponse_CreateGroup {
        guard !request.name.isEmpty else {
            return ValidationResponse_CreateGroup(message:"The name field is required.", isValid: false)
        }
        guard !request.description.isEmpty else {
            return ValidationResponse_CreateGroup(message:"The description field is required.", isValid: false)
        }
        guard !request.join_type.isEmpty else {
            return ValidationResponse_CreateGroup(message:"The join type field is required.", isValid: false)
        }
        return ValidationResponse_CreateGroup(message: nil, isValid: true)
    }
}
