//
//  PostLikeV_M.swift
//  Neighbrsnooks
//
//  Created by Irshad Malik on 07/10/25.
//

import Foundation

class PostLikeV_M: NSObject {
    static let shared = PostLikeV_M()
    func PostLike(parameters: Parameters, completion: @escaping (_ result: PostLikeModel?, _ error: String?) -> Void) {
        guard let url = URL(string: API.PostLike) else {
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
            resultType: PostLikeModel.self,
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

class DecryptUtility {
    static func decryptPostLike(encryptedString: String, completion: @escaping (PostLikeDecryptModel?) -> Void) {
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
            resultType: PostLikeDecryptModel.self,
            headers: headers
        ) { response in
            completion(response)
        }
    }
}




// MARK: - Api status like


class PostLikeStatusV_M: NSObject {
    static let shared = PostLikeStatusV_M()
    func PostLike(parameters: Parameters, completion: @escaping (_ result: PostLikeModel?, _ error: String?) -> Void) {
        guard let url = URL(string: API.PostLikeStatus) else {
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
            resultType: PostLikeModel.self,
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

class DecryptUtilityPostLikeStatus {
    static func decryptPostLikeStatus(encryptedString: String, completion: @escaping (PostLikeStatus?) -> Void) {
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
            resultType: PostLikeStatus.self, // ← Correct Model Type!
            headers: headers
        ) { response in
            completion(response)
        }
    }
}
