import Foundation

// MARK: - Welcome
struct MyNeighbhoodModel: Codable {
    var status, message, neighbrhood, verfiedMsg: String?
    let totmember: Int?
    let members, groups, events, polls: String?
    let business, post, suggestions: String?
    let nearestNeighbrhood, ownerNeighbrhood: [Neighbrhood]
    let groupuserlist, eventuserlist, polluserlist, businessuserlist: String?
    let suggestionuserlist, postuserlist: String?
    let coverimage, coverimageandroid, coverimageios: String?

    enum CodingKeys: String, CodingKey {
        case status, message, neighbrhood
        case verfiedMsg = "verfied_msg"
        case totmember, members, groups, events, polls, business, post, suggestions
        case nearestNeighbrhood = "nearest_neighbrhood"
        case ownerNeighbrhood = "owner_neighbrhood"
        case groupuserlist, eventuserlist, polluserlist, businessuserlist, suggestionuserlist, postuserlist, coverimage, coverimageandroid, coverimageios
    }
}

// MARK: - Neighbrhood
struct Neighbrhood: Codable {
    let id, name, status, member: String
}
