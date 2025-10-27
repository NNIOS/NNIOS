//
//  SearchNeighborhoodModel.swift
//  Neighbrsnooks
//
//  Created by Irshad Malik on 20/09/25.
//

import Foundation
struct SearchNeighborhoodModel: Codable {
    let status: IntOrBoolOrString?
    let code: Int
    let message: String
    let data: FlexibleData?
}

/// yeh helper enum add करो (same file me ya alag file me)
enum FlexibleData: Codable {
    case string(String)
    case array([String])
    case none
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let str = try? container.decode(String.self) {
            self = .string(str)
        } else if let arr = try? container.decode([String].self) {
            self = .array(arr)
        } else {
            self = .none
        }
    }
}
