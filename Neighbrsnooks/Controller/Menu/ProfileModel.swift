import Foundation
 

// MARK: - UserProfile
struct ProfileModel: Codable {
    let status: String
    let message: String
    let id: String
    let userpic: String
    let firstname: String
    let lastname: String
    let username: String
    let verfiedMsg: String
    let nbdId: String
    let neighborhood: String
    let posts: String
    let market: String
    let suggestions: String
    let events: String
    let polls: String
    let directmessage: String
    let business: String
    let favourites: String
    let groups: String
    let totposts: String
    let totmarket: String
    let totsuggestions: String
    let totevents: String
    let totpolls: String
    let totdirectmessage: String
    let totbusiness: String
    let totfavourites: String
    let totgroups: String
    let postper: String
    let marketper: String
    let suggestionper: String
    let eventper: String
    let pollper: String
    let directmsgper: String
    let businessper: String
    let favouriteper: String
    let groupper: String
    let createddate: String
    let emailid: String
    let phoneno: String
    let emerPhone: String?
    var addlineone: String?  
    var addlinetwo: String?
    var city: String?
    var state: String?
    let country: String?
    var pincode: String?
    var address: String
    var dob: String
    var gender: String
    let genderid: String
    let nbrsType: String
    let profid: String
    let intersttype: String
    let intid: String
    let reason: String
    let postuserlist: String
    let marketuserlist: String
    let polluserlist: String
    let groupuserlist: String
    let eventuserlist: String
    let businessuserlist: String
    let suggestionuserlist: String
    let favouruserlist: String
    let msguserlist: String
    let uploadedDoc: String

    enum CodingKeys: String, CodingKey {
        case status, message, id, userpic, firstname, lastname, username, verfiedMsg = "verfied_msg", nbdId = "nbd_id", neighborhood, posts, market, suggestions, events, polls, directmessage, business, favourites, groups
        case totposts, totmarket, totsuggestions, totevents, totpolls, totdirectmessage, totbusiness, totfavourites, totgroups
        case postper, marketper, suggestionper, eventper, pollper, directmsgper, businessper, favouriteper, groupper
        case createddate, emailid, phoneno, emerPhone = "emer_phone", addlineone, addlinetwo, city, state, country, pincode, address, dob, gender, genderid, nbrsType = "nbrs_type", profid, intersttype, intid, reason, postuserlist, marketuserlist, polluserlist, groupuserlist, eventuserlist, businessuserlist, suggestionuserlist, favouruserlist, msguserlist, uploadedDoc = "uploaded_doc"
    }
}
