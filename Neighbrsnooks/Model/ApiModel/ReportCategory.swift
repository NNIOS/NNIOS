//
//  ReportCategory.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 28/10/24.
//

import Foundation

// MARK: - Welcome
struct ReportCategory: Codable {
    let status, message: String?
    let listdata: [ReportCatData]?
}

// MARK: - Listdatum
struct ReportCatData: Codable {
    let id, name: String?
}

