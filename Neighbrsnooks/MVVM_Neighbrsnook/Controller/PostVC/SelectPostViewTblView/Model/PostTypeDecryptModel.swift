//
//  PostTypeDecryptModel.swift
//  Neighbrsnooks
//
//  Created by Irshad Malik on 30/09/25.
//
import Foundation

// MARK: - PostTypeResponse
struct PostTypeResponse: Codable {
    let data: PostTypeResult
}

// MARK: - PostTypeResult
struct PostTypeResult: Codable {
    let code: Int
    let message: String?
    let status: String   // Int/String dono ko handle karenge
    let data: PostTypeDetails

    enum CodingKeys: String, CodingKey {
        case code, message, status, data
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        code = try container.decode(Int.self, forKey: .code)
        message = try? container.decode(String.self, forKey: .message)
        data = try container.decode(PostTypeDetails.self, forKey: .data)

        // status flexible
        if let intVal = try? container.decode(Int.self, forKey: .status) {
            status = String(intVal)
        } else if let strVal = try? container.decode(String.self, forKey: .status) {
            status = strVal
        } else {
            status = ""
        }
    }
}

// MARK: - PostTypeDetails
struct PostTypeDetails: Codable {
    let maxImageCount: Int
    let maxImageSizeMB: Int
    let maxVideoCount: Int
    let maxVideoSizeMB: Int
    let types: [PostTypeItem]

    enum CodingKeys: String, CodingKey {
        case maxImageCount = "post_image_limit"
        case maxImageSizeMB = "post_image_size_mb"
        case maxVideoCount = "post_video_limit"
        case maxVideoSizeMB = "post_video_size_mb"
        case types = "post_types"
    }
}

// MARK: - PostTypeItem
struct PostTypeItem: Codable {
    let id: Int
    let title: String
    let isActive: String
    let isDeleted: String
    let createdAt: String
    let createdBy: String
    let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id, title
        case isActive = "status"
        case isDeleted = "is_deleted"
        case createdAt = "created_at"
        case createdBy = "created_by"
        case updatedAt = "updated_at"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        createdAt = try container.decode(String.self, forKey: .createdAt)
        updatedAt = try container.decode(String.self, forKey: .updatedAt)

        // Flexible decoding (status, is_deleted, created_by kabhi Int kabhi String)
        if let intVal = try? container.decode(Int.self, forKey: .isActive) {
            isActive = String(intVal)
        } else if let strVal = try? container.decode(String.self, forKey: .isActive) {
            isActive = strVal
        } else {
            isActive = ""
        }

        if let intVal = try? container.decode(Int.self, forKey: .isDeleted) {
            isDeleted = String(intVal)
        } else if let strVal = try? container.decode(String.self, forKey: .isDeleted) {
            isDeleted = strVal
        } else {
            isDeleted = ""
        }

        if let str = try? container.decode(String.self, forKey: .createdBy) {
            createdBy = str
        } else if let intVal = try? container.decode(Int.self, forKey: .createdBy) {
            createdBy = String(intVal)
        } else {
            createdBy = ""
        }
    }
}
