////
////  HomeModel.swift
////  NeighbrsNook Latest
////
////  Created by Rajat Rao on 08/03/24.
////
//
//import Foundation
//
//struct HomeModel: Codable {
//    let status, message: String?
//    let announcement: [String]?
//    let myNeighborhoodID: String?
//    let myNeighborhood: String?
//    let verfiedMsg, missmatchRemarks, awaitStatus, memberCount: String?
//    let verifiedStatus: String?
//    let listdata: [Listdatum]?
//
//    enum CodingKeys: String, CodingKey {
//        case status, message, announcement
//        case myNeighborhoodID = "my_neighborhood_id"
//        case myNeighborhood = "my_neighborhood"
//        case verfiedMsg = "verfied_msg"
//        case missmatchRemarks = "missmatch_remarks"
//        case awaitStatus = "await_status"
//        case memberCount = "member_count"
//        case verifiedStatus = "verified_status"
//        case listdata
//    }
//}
//
//// MARK: - Listdatum
//struct Listdatum: Codable {
//    let type, hID, createdby: String?
//    let userpic: String?
//    let username, createdOn: String?
//    let postid, postType: String?
//    let neighborhood: String?
//    let postImages: [Image]?
//    let postMessage, status, emojiStatus, userEmoji: String?
//    let totalEmojis: Int?
//    let emojilistdata: [Emojilistdatum]?
//    let postlike, totcomment, totallike: String?
//    let favouritstatus: Int?
//    let welcomeid, welcomeMsg, welcomeImg, eventid: String?
//    let eventName, eventDescription: String?
//    let eventCoverImage: String?
//    let eventStartDate, eventEndDate, willeventstart, iseventrunning: String?
//    let bID, businessName, businessTagline, businessDesc: String?
//    let category, businessStatus: String?
//    let businessImage: [Image]?
//    let businessVideo: [String]?
//    let review: Int?
//    let rating, groupid, groupName, groupDescription: String?
//    let groupImage: String?
//    let groupType, groupStatus, getjoin, pendingRequestCount: String?
//    let membercount: Int?
//
//    enum CodingKeys: String, CodingKey {
//        case type
//        case hID = "h_id"
//        case createdby, userpic, username
//        case createdOn = "created_on"
//        case postid
//        case postType = "post_type"
//        case neighborhood
//        case postImages = "post_images"
//        case postMessage = "post_message"
//        case status
//        case emojiStatus = "emoji_status"
//        case userEmoji = "user_emoji"
//        case totalEmojis = "total_emojis"
//        case emojilistdata, postlike, totcomment, totallike, favouritstatus, welcomeid
//        case welcomeMsg = "welcome_msg"
//        case welcomeImg = "welcome_img"
//        case eventid
//        case eventName = "event_name"
//        case eventDescription = "event_description"
//        case eventCoverImage = "event_cover_image"
//        case eventStartDate = "event_start_date"
//        case eventEndDate = "event_end_date"
//        case willeventstart, iseventrunning
//        case bID = "b_id"
//        case businessName = "business_name"
//        case businessTagline = "business_tagline"
//        case businessDesc = "business_desc"
//        case category
//        case businessStatus = "business_status"
//        case businessImage = "business_image"
//        case businessVideo = "business_video"
//        case review, rating, groupid
//        case groupName = "group_name"
//        case groupDescription = "group_description"
//        case groupImage = "group_image"
//        case groupType = "group_type"
//        case groupStatus = "group_status"
//        case getjoin, pendingRequestCount, membercount
//    }
//}
//
//// MARK: - Image
//struct Image: Codable {
//    let img: String?
//}
//
//// MARK: - Emojilistdatum
//struct Emojilistdatum: Codable {
//    let postid, userid, username: String?
//    let userpic: String?
//    let neighbrhood: String?
//    let emoji, createon: String?
//}
//
//
//// MARK: - Welcome
////struct HomeModel: Codable {
////    let status, message: String?
////    let announcement: String?
////    let myNeighborhoodID: String?
////    let myNeighborhood: String?
////    let verfiedMsg, missmatchRemarks, awaitStatus, memberCount: String?
////    let verifiedStatus: String?
////    let listdata: [HomeData]?
////
////    enum CodingKeys: String, CodingKey {
////        case status, message, announcement
////        case myNeighborhoodID = "my_neighborhood_id"
////        case myNeighborhood = "my_neighborhood"
////        case verfiedMsg = "verfied_msg"
////        case missmatchRemarks = "missmatch_remarks"
////        case awaitStatus = "await_status"
////        case memberCount = "member_count"
////        case verifiedStatus = "verified_status"
////        case listdata
////    }
////}
////
////// MARK: - Listdatum
////struct HomeData: Codable {
////    let type, hID, createdby: String?
////    let userpic: String?
////    let username, createdOn: String?
////    let postid, postType: String?
////    let neighborhood: String?
////    let postImages: [Image]?
////    let postMessage, status, emojiStatus, userEmoji: String?
////    let totalEmojis: Int?
////    let emojilistdata: [Emojilistdatum]?
////    let postlike, totcomment, totallike: String?
////    let favouritstatus: Int?
////    let welcomeid, welcomeMsg, welcomeImg, eventid: String?
////    let eventName, eventDescription: String?
////    let eventCoverImage: String?
////    let eventStartDate, eventEndDate, willeventstart, iseventrunning: String?
////    let bID, businessName, businessTagline, businessDesc: String?
////    let category, businessStatus: String?
////    let businessImage: [Image]?
////    let businessVideo: [String]?
////    let review: Int?
////    let rating, groupid, groupName, groupDescription: String?
////    let groupImage: String?
////    let groupType, groupStatus, getjoin, pendingRequestCount: String?
////    let membercount: Int?
////
////    enum CodingKeys: String, CodingKey {
////        case type
////        case hID = "h_id"
////        case createdby, userpic, username
////        case createdOn = "created_on"
////        case postid
////        case postType = "post_type"
////        case neighborhood
////        case postImages = "post_images"
////        case postMessage = "post_message"
////        case status
////        case emojiStatus = "emoji_status"
////        case userEmoji = "user_emoji"
////        case totalEmojis = "total_emojis"
////        case emojilistdata, postlike, totcomment, totallike, favouritstatus, welcomeid
////        case welcomeMsg = "welcome_msg"
////        case welcomeImg = "welcome_img"
////        case eventid
////        case eventName = "event_name"
////        case eventDescription = "event_description"
////        case eventCoverImage = "event_cover_image"
////        case eventStartDate = "event_start_date"
////        case eventEndDate = "event_end_date"
////        case willeventstart, iseventrunning
////        case bID = "b_id"
////        case businessName = "business_name"
////        case businessTagline = "business_tagline"
////        case businessDesc = "business_desc"
////        case category
////        case businessStatus = "business_status"
////        case businessImage = "business_image"
////        case businessVideo = "business_video"
////        case review, rating, groupid
////        case groupName = "group_name"
////        case groupDescription = "group_description"
////        case groupImage = "group_image"
////        case groupType = "group_type"
////        case groupStatus = "group_status"
////        case getjoin, pendingRequestCount, membercount
////    }
////}
////
////// MARK: - Image
////struct Image: Codable {
////    let img: String?
////}
////
////// MARK: - Emojilistdatum
////struct Emojilistdatum: Codable {
////    let postid, userid, username: String?
////    let userpic: String?
////    let neighbrhood: String?
////    let emoji, createon: String?
////}
//
////enum Rhood: String, Codable {
////    case sector15 = "Sector 15"
////    case sector16 = "Sector 16"
////    case sector16A = "Sector 16A"
////    case sector18 = "Sector 18"
////}
//
//// MARK: - Encode/decode helpers
//
////class JSONNull: Codable, Hashable {
////
////    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
////        return true
////    }
////
////    public var hashValue: Int {
////        return 0
////    }
////
////    public init() {}
////
////    public required init(from decoder: Decoder) throws {
////        let container = try decoder.singleValueContainer()
////        if !container.decodeNil() {
////            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
////        }
////    }
////
////    public func encode(to encoder: Encoder) throws {
////        var container = encoder.singleValueContainer()
////        try container.encodeNil()
////    }
////}
//
////class JSONCodingKey: CodingKey {
////    let key: String
////
////    required init?(intValue: Int) {
////        return nil
////    }
////
////    required init?(stringValue: String) {
////        key = stringValue
////    }
////
////    var intValue: Int? {
////        return nil
////    }
////
////    var stringValue: String {
////        return key
////    }
////}
//
////class JSONAny: Codable {
////
////    let value: Any
////
////    static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
////        let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
////        return DecodingError.typeMismatch(JSONAny.self, context)
////    }
////
////    static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
////        let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
////        return EncodingError.invalidValue(value, context)
////    }
////
////    static func decode(from container: SingleValueDecodingContainer) throws -> Any {
////        if let value = try? container.decode(Bool.self) {
////            return value
////        }
////        if let value = try? container.decode(Int64.self) {
////            return value
////        }
////        if let value = try? container.decode(Double.self) {
////            return value
////        }
////        if let value = try? container.decode(String.self) {
////            return value
////        }
////        if container.decodeNil() {
////            return JSONNull()
////        }
////        throw decodingError(forCodingPath: container.codingPath)
////    }
////
////    static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
////        if let value = try? container.decode(Bool.self) {
////            return value
////        }
////        if let value = try? container.decode(Int64.self) {
////            return value
////        }
////        if let value = try? container.decode(Double.self) {
////            return value
////        }
////        if let value = try? container.decode(String.self) {
////            return value
////        }
////        if let value = try? container.decodeNil() {
////            if value {
////                return JSONNull()
////            }
////        }
////        if var container = try? container.nestedUnkeyedContainer() {
////            return try decodeArray(from: &container)
////        }
////        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
////            return try decodeDictionary(from: &container)
////        }
////        throw decodingError(forCodingPath: container.codingPath)
////    }
////
////    static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
////        if let value = try? container.decode(Bool.self, forKey: key) {
////            return value
////        }
////        if let value = try? container.decode(Int64.self, forKey: key) {
////            return value
////        }
////        if let value = try? container.decode(Double.self, forKey: key) {
////            return value
////        }
////        if let value = try? container.decode(String.self, forKey: key) {
////            return value
////        }
////        if let value = try? container.decodeNil(forKey: key) {
////            if value {
////                return JSONNull()
////            }
////        }
////        if var container = try? container.nestedUnkeyedContainer(forKey: key) {
////            return try decodeArray(from: &container)
////        }
////        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
////            return try decodeDictionary(from: &container)
////        }
////        throw decodingError(forCodingPath: container.codingPath)
////    }
////
////    static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
////        var arr: [Any] = []
////        while !container.isAtEnd {
////            let value = try decode(from: &container)
////            arr.append(value)
////        }
////        return arr
////    }
////
////    static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
////        var dict = [String: Any]()
////        for key in container.allKeys {
////            let value = try decode(from: &container, forKey: key)
////            dict[key.stringValue] = value
////        }
////        return dict
////    }
////
////    static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
////        for value in array {
////            if let value = value as? Bool {
////                try container.encode(value)
////            } else if let value = value as? Int64 {
////                try container.encode(value)
////            } else if let value = value as? Double {
////                try container.encode(value)
////            } else if let value = value as? String {
////                try container.encode(value)
////            } else if value is JSONNull {
////                try container.encodeNil()
////            } else if let value = value as? [Any] {
////                var container = container.nestedUnkeyedContainer()
////                try encode(to: &container, array: value)
////            } else if let value = value as? [String: Any] {
////                var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
////                try encode(to: &container, dictionary: value)
////            } else {
////                throw encodingError(forValue: value, codingPath: container.codingPath)
////            }
////        }
////    }
////
////    static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
////        for (key, value) in dictionary {
////            let key = JSONCodingKey(stringValue: key)!
////            if let value = value as? Bool {
////                try container.encode(value, forKey: key)
////            } else if let value = value as? Int64 {
////                try container.encode(value, forKey: key)
////            } else if let value = value as? Double {
////                try container.encode(value, forKey: key)
////            } else if let value = value as? String {
////                try container.encode(value, forKey: key)
////            } else if value is JSONNull {
////                try container.encodeNil(forKey: key)
////            } else if let value = value as? [Any] {
////                var container = container.nestedUnkeyedContainer(forKey: key)
////                try encode(to: &container, array: value)
////            } else if let value = value as? [String: Any] {
////                var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
////                try encode(to: &container, dictionary: value)
////            } else {
////                throw encodingError(forValue: value, codingPath: container.codingPath)
////            }
////        }
////    }
////
////    static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
////        if let value = value as? Bool {
////            try container.encode(value)
////        } else if let value = value as? Int64 {
////            try container.encode(value)
////        } else if let value = value as? Double {
////            try container.encode(value)
////        } else if let value = value as? String {
////            try container.encode(value)
////        } else if value is JSONNull {
////            try container.encodeNil()
////        } else {
////            throw encodingError(forValue: value, codingPath: container.codingPath)
////        }
////    }
////
////    public required init(from decoder: Decoder) throws {
////        if var arrayContainer = try? decoder.unkeyedContainer() {
////            self.value = try JSONAny.decodeArray(from: &arrayContainer)
////        } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
////            self.value = try JSONAny.decodeDictionary(from: &container)
////        } else {
////            let container = try decoder.singleValueContainer()
////            self.value = try JSONAny.decode(from: container)
////        }
////    }
////
////    public func encode(to encoder: Encoder) throws {
////        if let arr = self.value as? [Any] {
////            var container = encoder.unkeyedContainer()
////            try JSONAny.encode(to: &container, array: arr)
////        } else if let dict = self.value as? [String: Any] {
////            var container = encoder.container(keyedBy: JSONCodingKey.self)
////            try JSONAny.encode(to: &container, dictionary: dict)
////        } else {
////            var container = encoder.singleValueContainer()
////            try JSONAny.encode(to: &container, value: self.value)
////        }
////    }
////}
//
