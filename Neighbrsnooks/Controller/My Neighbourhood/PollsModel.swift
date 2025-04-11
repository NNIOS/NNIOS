import Foundation

// MARK: - PollsModel
struct PollsModel: Codable {
    let status, message, verfiedMsg: String
    let nbdata: [PollsData]

    enum CodingKeys: String, CodingKey {
        case status, message
        case verfiedMsg = "verfied_msg"
        case nbdata
    }
}

// MARK: - PollsData
struct PollsData: Codable {
    let pID: String
    let neighborhood: String? // Use `String?` to accommodate both cases
    let neighborhoodEnum: NeighborhoodB? // Optional for specific enumeration
    let pollQues, startDate, endDate: String
    let createdBy: String?
    let userid, createdDate: String
    let userpic: String
    let isvoted, totalvote, ispollrunning: String
    let favouritstatus: Int

    enum CodingKeys: String, CodingKey {
        case pID = "p_id"
        case neighborhood
        case neighborhoodEnum = "neighborhood_enum" // Add a distinct key for enums if provided in some cases
        case pollQues = "poll_ques"
        case startDate = "start_date"
        case endDate = "end_date"
        case createdBy = "created_by"
        case userid
        case createdDate = "created_date"
        case userpic, isvoted, totalvote, ispollrunning, favouritstatus
    }
}

// MARK: - NeighborhoodB Enum
enum NeighborhoodB: String, Codable {
    case jungpuraExtension = "Jungpura Extension"
    case sector104 = "Sector 104"
    case sector16A = "Sector 16A"
}
