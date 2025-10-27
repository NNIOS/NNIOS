//
//  CreatePostV_M.swift
//  Neighbrsnooks
//
//  Created by Irshad Malik on 01/10/25.
//

import Foundation

class CreatePostV_M: NSObject {
    static let shared = CreatePostV_M()
    func CreatePostData(parameters: Parameters, completion: @escaping (_ result: CreatePostModel?, _ error: String?) -> Void) {
        guard let url = URL(string: API.createPost) else {
            completion(nil, "Invalid API URL")
            return
        }
        let httpUtility = HttpUtility()
        guard let postBody = parameters.percentEncoded() else {
            completion(nil, "Parameter encoding failed")
            return
        }
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
        let headers = ["Authorization": "Bearer \(token)"]

        httpUtility.postApiData(
            requestUrl: url,
            requestBody: postBody,
            httpMethod: "POST",
            resultType: CreatePostModel.self,
            headers: headers
        ) { responseData in
            // ⚠️ Custom error parse logic — raw response JSON as Data
            if let data = responseData as? Data,
                let dict = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                let status = dict["status"] as? Int,
                status == 0 {
                let errorMsg = dict["error"] as? String ?? "API Error"
                completion(nil, errorMsg)
                return
            }
            completion(responseData, nil)
        }
    }

}
