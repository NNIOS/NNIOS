//
//  CreatePostModel.swift
//  Neighbrsnooks
//
//  Created by Irshad Malik on 01/10/25.
//

import Foundation

// MARK: - CreatePostModel
struct CreatePostModel: Codable {
    let status: IntOrBoolOrString
    let code: Int
    let message: String
}
