import Foundation

// MARK: - Welcome
struct EventDetailModel: Codable {
    let status, message: String?
    let images: [ImageEvent]?
    let id, title, eventStartDate, eventEndDate: String?
    let eventStarttime, eventEndtime: String?
    let coverImage: String?
    let eventDetail, addlineone, addlinetwo: String?
    let userattends: UserAttends?
    let userjoinmemberlist: [Userjoinmemberlist]?
    let userunjoinmemberlist: [UserUnjoinMemberList]?
    let userlikes, datetimeandneighbrhood, createby: String?
    let userpic: String?
    let userid, futureeventstatus, iseventrunning, totalLike: String?
    let totalJoin, unjoin, nojoin, eventImgLimit: String?
    let eventImageSize, eventImgRemainLimit: String?

    enum CodingKeys: String, CodingKey {
        case status, message, images, id, title
        case eventStartDate = "event_start_date"
        case eventEndDate = "event_end_date"
        case eventStarttime = "event_starttime"
        case eventEndtime = "event_endtime"
        case coverImage = "cover_image"
        case eventDetail = "event_detail"
        case addlineone, addlinetwo, userattends, userjoinmemberlist, userunjoinmemberlist, userlikes, datetimeandneighbrhood, createby, userpic, userid, futureeventstatus, iseventrunning
        case totalLike = "total_like"
        case totalJoin = "total_join"
        case unjoin, nojoin
        case eventImgLimit = "event_img_limit"
        case eventImageSize = "event_image_size"
        case eventImgRemainLimit = "event_img_remain_limit"
    }
    
    
}

enum UserAttends: Codable {
       case intValue(Int)
       case stringValue(String)
       
       init(from decoder: Decoder) throws {
           let container = try decoder.singleValueContainer()
           if let intValue = try? container.decode(Int.self) {
               self = .intValue(intValue)
           } else if let stringValue = try? container.decode(String.self) {
               self = .stringValue(stringValue)
           } else {
               throw DecodingError.typeMismatch(UserAttends.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Expected value of type String or Int"))
           }
       }
       
       func encode(to encoder: Encoder) throws {
           var container = encoder.singleValueContainer()
           switch self {
           case .intValue(let intValue):
               try container.encode(intValue)
           case .stringValue(let stringValue):
               try container.encode(stringValue)
           }
       }
   }

// MARK: - Image
struct ImageEvent: Codable {
    let img: String?
    let userid: String?
    let imgid: Imgid?
    let type: String?
}

enum Imgid: Codable {
    case integer(Int)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            self = .integer(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(Imgid.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Imgid"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .integer(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}

// MARK: - Userjoinmemberlist
struct Userjoinmemberlist: Codable {
    let userid, username, neighbrhood: String?
    let userphoto: String?
    let status, eventid: String?
}



// MARK: - Userjoinmemberlist
struct UserUnjoinMemberList: Codable {
    let userid, username, neighbrhood: String?
    let userphoto: String?
    let status, eventid: String?
}
struct EventDetailData {
    var images: [ImageEvent]?
}

// MARK: - Encode/decode helpers

//import Foundation
//
//// MARK: - Welcome
//struct Welcome: Codable {
//    let status, message: String
//    let images: [ImageEvent]
//    let id, title, eventStartDate, eventEndDate: String
//    let eventStarttime, eventEndtime: String
//    let coverImage: String
//    let eventDetail, addlineone, addlinetwo, userattends: String
//    let userjoinmemberlist, userunjoinmemberlist: [Userjoinmemberlist]
//    let userlikes, datetimeandneighbrhood, createby: String
//    let userpic: String
//    let userid, futureeventstatus, iseventrunning, totalLike: String
//    let totalJoin, unjoin, nojoin, eventImgLimit: String
//    let eventImageSize, eventImgRemainLimit: String
//
//    enum CodingKeys: String, CodingKey {
//        case status, message, images, id, title
//        case eventStartDate = "event_start_date"
//        case eventEndDate = "event_end_date"
//        case eventStarttime = "event_starttime"
//        case eventEndtime = "event_endtime"
//        case coverImage = "cover_image"
//        case eventDetail = "event_detail"
//        case addlineone, addlinetwo, userattends, userjoinmemberlist, userunjoinmemberlist, userlikes, datetimeandneighbrhood, createby, userpic, userid, futureeventstatus, iseventrunning
//        case totalLike = "total_like"
//        case totalJoin = "total_join"
//        case unjoin, nojoin
//        case eventImgLimit = "event_img_limit"
//        case eventImageSize = "event_image_size"
//        case eventImgRemainLimit = "event_img_remain_limit"
//    }
//}
//
//// MARK: - Image
//struct ImageEvent: Codable {
//    let img: String
//    let userid: String
//    let imgid: Int
//    let type: String
//}
//
//// MARK: - Userjoinmemberlist
//struct Userjoinmemberlist: Codable {
//    let userid, username, neighbrhood: String
//    let userphoto: String
//    let status, eventid: String
//}
