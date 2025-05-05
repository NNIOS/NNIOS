//
//  MatchOTPModel.swift
//  NeighbrsNook Latest
//
//  Created by Mac on 20/05/24.
//

import Foundation

// MARK: - Welcome
struct MatchOTPModel: Codable {
    let status: String?
//    let reqestmobileno : String?
    let description: verifyOTPData?
    
    
    
}

// MARK: - Description
struct verifyOTPData: Codable {
    let desc: String?
//    let reqestmobile : String?
}

 
