import Foundation

// MARK: - Welcome
struct NotificationModel: Codable {
    let nbdata: [NotificationData]
    let status, message: String
}

// MARK: - Nbdatum
struct NotificationData: Codable {
    let notificationID, notificationType, id, neighbrhood: String
    let title, message, createon, createdOwner: String
    let isDelete, ownername: String?
    let ownerpic: String?
    let groupchatName: String?
    let groupchatImage: String?
    let groupType: String?

    enum CodingKeys: String, CodingKey {
        case notificationID = "notification_id"
        case notificationType = "notification_type"
        case id, neighbrhood, title, message, createon
        case createdOwner = "created-Owner"
        case isDelete = "is_delete"
        case ownername, ownerpic
        case groupchatName = "groupchat_name"
        case groupchatImage = "groupchat_image"
        case groupType = "group_type"
    }
}
