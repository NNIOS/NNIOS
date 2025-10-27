//
//  UserDataRegistation.swift
//  Neighbrsnooks
//
//  Created by Irshad Malik on 18/09/25.
//


import Foundation
struct DecryptResponseData: Codable {
    let data: InnerData
    
    struct InnerData: Codable {
        let status: Bool
        let code: Int
        let message: String
        let userData: UserDataDecrypt?  // optional
        
        enum CodingKeys: String, CodingKey {
            case status, code, message
            case userData = "data"
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            // CHANGE STARTS HERE
            if let intStatus = try? container.decode(Int.self, forKey: .status) {
                self.status = intStatus == 1
            } else if let boolStatus = try? container.decode(Bool.self, forKey: .status) {
                self.status = boolStatus
            } else if let stringStatus = try? container.decode(String.self, forKey: .status) {
                // success → true, failed → false
                self.status = (stringStatus.lowercased() == "success" || stringStatus.lowercased() == "true")
            } else {
                self.status = false
            }
            // CHANGE ENDS HERE
            
            self.code = try container.decode(Int.self, forKey: .code)
            self.message = try container.decode(String.self, forKey: .message)
            self.userData = try? container.decode(UserDataDecrypt.self, forKey: .userData)
        }
    }
}



struct UserDataDecrypt: Codable {
    let id: Int
    let token: String
}
