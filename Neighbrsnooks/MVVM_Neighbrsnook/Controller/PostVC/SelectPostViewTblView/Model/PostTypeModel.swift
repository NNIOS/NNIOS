//
//  PostTypeModel.swift
//  Neighbrsnooks
//
//  Created by Irshad Malik on 26/09/25.
//

import Foundation

struct PostTypeModel: Codable {
    let status: IntOrBoolOrString?
    let code: Int?
    let message: String?
    let data: String?
}
