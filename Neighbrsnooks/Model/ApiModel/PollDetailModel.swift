import Foundation

// MARK: - Welcome
struct PollDetailModel: Codable {
    let status, message, verfiedMsg, pID: String?
    let title, neighborhood, pollQues, startDate: String?
    let endDate, compEnddate, createdBy, createdDate: String?
    let options: [PollDetailData]?
    let userid, total, userget, isvoted: String?
    let pollRunningStatus: String?
    let favouritstatus: Int?
    let userpic: String?
    let editPollStatus: Int?

    enum CodingKeys: String, CodingKey {
        case status, message
        case verfiedMsg = "verfied_msg"
        case pID = "p_id"
        case title, neighborhood
        case pollQues = "poll_ques"
        case startDate = "start_date"
        case endDate = "end_date"
        case compEnddate = "comp_enddate"
        case editPollStatus = "edit_poll_status"
        case createdBy = "created_by"
        case createdDate = "created_date"
        case options, userid, total, userget, isvoted
        case pollRunningStatus = "poll_running_status"
        case favouritstatus, userpic
    }
}

// MARK: - Option
struct PollDetailData: Codable {
    let option, percentage: String?
    let userCount: Int?

    enum CodingKeys: String, CodingKey {
        case option, percentage
        case userCount = "user_count"
    }
}
