//
//  PostDetailsModel.swift
//  Neighbrsnooks
//
//  Created by Irshad Malik on 06/10/25.
//

import Foundation
struct PostDetailsModel: Codable {
    let status: Bool
    let code: Int
    let message, data: String
}
