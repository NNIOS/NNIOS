//
//  NotificationCountModel.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 04/11/24.
//

import Foundation

// MARK: - Welcome
struct NotificationCountModel: Codable {
    let notificationCount: Int?
    let status, message: String?

    enum CodingKeys: String, CodingKey {
        case notificationCount = "notification_count"
        case status, message
    }
}

