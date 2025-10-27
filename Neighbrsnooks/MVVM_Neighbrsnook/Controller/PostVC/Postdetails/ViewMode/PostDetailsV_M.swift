//
//  PostDetailsV_M.swift
//  Neighbrsnooks
//
//  Created by Irshad Malik on 06/10/25.
//

import Foundation


class PostDetailsV_M: NSObject {
    static let shared = PostDetailsV_M()
    func PostDetails(parameters: Parameters, completion: @escaping (_ result: PostDetailsModel?, _ error: String?) -> Void) {
        guard let url = URL(string: API.detailsPost) else {
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
            resultType: PostDetailsModel.self,
            headers: headers
        ) { responseData in
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


func PostDetailsDecrypt(encryptedString: String, completion: @escaping (postDetailsdecryptModel?) -> Void) {
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
        resultType: postDetailsdecryptModel.self,
        headers: headers
    ) { response in
        completion(response)  
    }
}



