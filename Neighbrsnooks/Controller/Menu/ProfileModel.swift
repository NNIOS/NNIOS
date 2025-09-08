import Foundation
 

// MARK: - UserProfile
struct ProfileModel: Codable {
    let status: String
    let message: String
    let id: String
    let userpic: String
    let firstname: String?
    let lastname: String?
    let username: String?
    let verfiedMsg: String
    let nbdId: String
    let neighborhood: String

    // 👇 THESE should be optional (can be missing/null in future)
    var posts: String?
    var market: String?
    var suggestions: String?
    var events: String?
    var polls: String?
    var directmessage: String?
    var business: String?
    var favourites: String?
    var groups: String?
    var totposts: String?
    var totmarket: String?
    var totsuggestions: String?
    var totevents: String?
    var totpolls: String?
    var totdirectmessage: String?
    var totbusiness: String?
    var totfavourites: String?
    var totgroups: String?

    var postper: String?
    var marketper: String?
    var suggestionper: String?
    var eventper: String?
    var pollper: String?
    var directmsgper: String?
    var businessper: String?
    var favouriteper: String?
    var groupper: String?

    var createddate: String?
    var emailid: String?
    var phoneno: String?
    var emerPhone: String?
    var addlineone: String?
    var addlinetwo: String?
    var city: String?
    var state: String?
    var country: String?
    var pincode: String?
    var addressone: String?
    var dob: String?
    var gender: String?
    var genderid: String?
    var nbrsType: String?
    var profid: String?
    var intersttype: String?
    var intid: String?
    var reason: String?
    var postuserlist: String?
    var marketuserlist: String?
    var polluserlist: String?
    var groupuserlist: String?
    var eventuserlist: String?
    var businessuserlist: String?
    var suggestionuserlist: String?
    var favouruserlist: String?
    var msguserlist: String?
    var uploadedDoc: String?
    var uploadedDocImages: [String]?

    enum CodingKeys: String, CodingKey {
        case status, message, id, userpic, firstname, lastname, username, verfiedMsg = "verfied_msg", nbdId = "nbd_id", neighborhood, posts, market, suggestions, events, polls, directmessage, business, favourites, groups
        case totposts, totmarket, totsuggestions, totevents, totpolls, totdirectmessage, totbusiness, totfavourites, totgroups
        case postper, marketper, suggestionper, eventper, pollper, directmsgper, businessper, favouriteper, groupper
        case createddate, emailid, phoneno, emerPhone = "emer_phone", addlineone, addlinetwo, city, state, country, pincode, addressone, dob, gender, genderid, nbrsType = "nbrs_type", profid, intersttype, intid, reason, postuserlist, marketuserlist, polluserlist, groupuserlist, eventuserlist, businessuserlist, suggestionuserlist, favouruserlist, msguserlist, uploadedDoc = "uploaded_doc"
        case uploadedDocImages = "uploaded_doc_img"
    }
}





