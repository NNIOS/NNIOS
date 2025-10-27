//
//  PostCommentLikeV_M.swift
//  Neighbrsnooks
//
//  Created by Irshad Malik on 07/10/25.
//

import Foundation

class PostCommentLikeV_M: NSObject {
    static let shared = PostCommentLikeV_M()
    func PostDetails(parameters: Parameters, completion: @escaping (_ result: PostCommentLikeModel?, _ error: String?) -> Void) {
        guard let url = URL(string: API.commenPostLike) else {
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
            resultType: PostCommentLikeModel.self,
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
