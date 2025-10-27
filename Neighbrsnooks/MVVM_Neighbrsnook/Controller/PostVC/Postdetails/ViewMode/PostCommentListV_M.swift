//
//  PostCommentListV_M.swift
//  Neighbrsnooks
//
//  Created by Irshad Malik on 06/10/25.
//

import Foundation

class PostCommentListV_M: NSObject {
    static let shared = PostCommentListV_M()
    func PostCommentList(parameters: Parameters, completion: @escaping (_ result: PostCommentListModel?, _ error: String?) -> Void) {
        guard let url = URL(string: API.commentListPost) else {
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
            resultType: PostCommentListModel.self,
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


func postCommentListDecrypt(encryptedString: String, completion: @escaping (PostCommentListDecryptModel?) -> Void) {
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
        resultType: PostCommentListDecryptModel.self,
        headers: headers
    ) { response in
        completion(response)
    }
}



