//
//  VerifyOTPModel.swift
//  NeighbrsNook Latest
//
//  Created by Rajat Rao on 20/02/24.
//

//import Foundation
//
//// MARK: - Welcome
//struct VerifyOTPModel: Codable {
//    let status: String?
//    let description: verifyOTPData?
//    let mobileNumber: Int?
//}
//
//// MARK: - Description
//struct verifyOTPData: Codable {
//    let desc: String?
//   
//}
//
////
////{
////    "status": "success",
////    "description": {
////        "desc": "Code Matched successfully."
////    }
////}
import Foundation

// Define the top-level response struct
struct Response: Codable {
    let status: String
    let description: Description
}

// Define the nested description struct
struct Description: Codable {
    let desc: String
}

// Example of how to decode JSON into the Swift struct
//let jsonData = """
//{
//    "status": "success",
//    "description": {
//        "desc": "Code Matched successfully."
//    }
//}
//""".data(using: .utf8)!
//
//do {
//    let response = try JSONDecoder().decode(Response.self, from: jsonData)
//    print("Status: \(response.status)")
//    print("Description: \(response.description.desc)")
//} catch {
//    print("Failed to decode JSON: \(error)")
//}
