//
//  PostTypeV_M.swift
//  Neighbrsnooks
//
//  Created by Irshad Malik on 26/09/25.
//

import Foundation
struct PostTypeV_M {
    func get_PostType(completion: @escaping (_ result: PostTypeModel?) -> Void) {
        guard let url = URL(string: API.postTypeApi) else {
            print("❌ Invalid URL")
            completion(nil)
            return
        }

        var request = URLRequest(url: url, timeoutInterval: Double.infinity)
        request.httpMethod = "GET" 

        // ✅ Add Authorization token
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
        if !token.isEmpty {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            print("🔑 Token added to GET request: Bearer \(token)")
        } else {
            print("❌ Token is empty, please login first")
        }

        // Optional: Add content-type if needed
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let httpUtility = HttpUtility()
        httpUtility.getApiDatawithAuth(requestUrl: request, resultType: PostTypeModel.self) { response in
            completion(response)
        }
    }
}



func decryptPostTypeV_M(encryptedString: String, completion: @escaping (PostTypeResult?) -> Void) {
    guard let url = URL(string: API.decrypt) else {
        completion(nil)
        return
    }
    let httpUtility = HttpUtility()
    let parameters: Parameters = ["decrypt": encryptedString]
    guard let postBody = parameters.percentEncoded() else {
        completion(nil)
        return
    }
    let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
    let headers = ["Authorization": "Bearer \(token)"]

    httpUtility.postApiData(
        requestUrl: url,
        requestBody: postBody,
        httpMethod: "POST",
        resultType: PostTypeResponse.self,
        headers: headers
    ) { response in
        completion(response?.data) 
    }
}

