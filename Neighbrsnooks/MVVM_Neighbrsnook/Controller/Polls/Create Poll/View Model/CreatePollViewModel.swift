//
//  CreatePollViewModel.swift
//  Neighbrsnooks
//
//  Created by Abdul Aleem on 24/09/25.
//

import Foundation

class CreatePoll_VM: NSObject {
    func createPoll(parameter: Parameters, request: CreatePoll_Request, completion: @escaping (_ result: CreatePollResponse?) -> Void) {
        let createPollUrl = URL(string: API.createPoll)!   // <- endpoint
        let httpUtility = HttpUtility()
        
        guard let registerPostBody = parameter.percentEncoded() else {
            completion(nil)
            return
        }
        
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
          let headers = [ "Authorization": "Bearer \(token)"]
        
        httpUtility.postApiData(
            requestUrl: createPollUrl,
            requestBody: registerPostBody,
            httpMethod: "POST",
            resultType: CreatePollResponse.self,
            headers: headers
        ) { (CreateGroupApiResponse) in
            completion(CreateGroupApiResponse)
        }
    }
}

extension Dictionary {
    func percentEncodedWithArray() -> Data? {
        return map { key, value in
            let keyString = "\(key)"
            if let array = value as? [String] {
                return array.map { item in
                    let escapedKey = keyString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                    let escapedValue = "\(item)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                    return "\(escapedKey)[]=\(escapedValue)"
                }.joined(separator: "&")
            } else {
                let escapedKey = keyString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                return "\(escapedKey)=\(escapedValue)"
            }
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}
