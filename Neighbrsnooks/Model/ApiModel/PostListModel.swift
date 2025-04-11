


struct PostListModel: Codable {
    let status, message, verfiedMsg: String?
//    let status, message, verfiedMsg, image: String
    let listdata: [PostListData]?

    enum CodingKeys: String, CodingKey {
        
//        case status, message
//               case verfiedMsg = "verfied_msg"
//               case image
//        
        
        
        case status, message
        case verfiedMsg = "verfied_msg"
        case listdata
    }
}

// MARK: - Listdatum
struct PostListData: Codable {
    let postid: String?
    let postType: String?
    let neighborhood: String?
    let postImages: [PostImage]?
    let postMessage, status, emojiStatus, userEmoji: String?
    let totalEmojis: Int?
    let emojilistdata: [Emojilistdata]?
    let postlike: String?
    let postemojiunicode: String?
    let totcomment, totallike: String?
    var favouritstatus: Int?
    let createdby, username: String?
    let userpic: String?
    let createdOn: String?

    enum CodingKeys: String, CodingKey {
        case postid
        case postType = "post_type"
        case neighborhood
        case postImages = "post_images"
        case postMessage = "post_message"
        case status
        case emojiStatus = "emoji_status"
        case userEmoji = "user_emoji"
        case totalEmojis = "total_emojis"
        case emojilistdata, postlike, postemojiunicode, totcomment, totallike, favouritstatus, createdby, username, userpic
        case createdOn = "created_on"
    }
}

// MARK: - Emojilistdatum
struct Emojilistdata: Codable {
    let postid, userid, username: String?
    let userpic: String?
    let neighbrhood: String?
    let emoji: String?
    let emojiunicode: String?
    let createon: String?
    
}


// MARK: - PostImage
struct PostImage: Codable {
    let img: String?
    let video: String?
}


