//
//  RegistrationSecModel.swift
//  NeighbrsNook Latest Latest
//
//  Created by Irshad Malik on 19/09/24.
//

import Foundation

struct RegistrationSecModel: Codable{
    let status: String?
    let data: [RegistrationSec]?
    let message: String?
}
struct RegistrationSec: Codable {
    let nbdID, nbdName, distance: String?
    
    
    enum CodingKeys: String, CodingKey {
            case nbdID = "nbd_id"
            case nbdName = "nbd_name"
            case distance
        }
}

 
