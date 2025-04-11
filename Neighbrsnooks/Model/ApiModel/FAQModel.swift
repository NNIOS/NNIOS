//
//  FAQModel.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 01/10/24.
//

import Foundation

// MARK: - Welcome
struct FAQModel: Codable {
    let status, message: String?
    let faqdata: [FAQData]?
}

// MARK: - Faqdatum
struct FAQData: Codable {
    let id, question, answer: String?
    var isExpanded: Bool?
}


