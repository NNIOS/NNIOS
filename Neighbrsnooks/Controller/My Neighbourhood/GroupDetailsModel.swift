import Foundation

// MARK: - Welcome
struct GroupDetailsModel: Codable {
    let status, message, groupid, groupname: String?
    let image: String?
    let description, neighbrhood, nearbyneighbrhood, username: String?
    let createdby, groupType: String?
    let membercount, membJoinStatus: Int?

    enum CodingKeys: String, CodingKey {
        case status, message, groupid, groupname, image, description, neighbrhood, nearbyneighbrhood, username, createdby
        case groupType = "group_type"
        case membercount
        case membJoinStatus = "memb_join_status"
    }
}
