//
//  Uploaded Documents Model.swift
//  NeighbrsNook Latest Latest
//
//  Created by Irshad Malik on 22/01/25.
//

import Foundation

// MARK: - Welcome
struct UploadedDocumentsModel: Codable {
    let status, message: String
    let docsdata: Docsdata
}

// MARK: - Docsdata
struct Docsdata: Codable {
    let id, passportFront, passportBack: String
    let aadharFront, aadharBack: String
    let voteridFront, voteridBack, drivingLicenseFront, drivingLicenseBack: String
    let rentDocs: String

    enum CodingKeys: String, CodingKey {
        case id
        case passportFront = "passport_front"
        case passportBack = "passport_back"
        case aadharFront = "aadhar_front"
        case aadharBack = "aadhar_back"
        case voteridFront = "voterid_front"
        case voteridBack = "voterid_back"
        case drivingLicenseFront = "driving_license_front"
        case drivingLicenseBack = "driving_license_back"
        case rentDocs = "rent_docs"
    }
}

