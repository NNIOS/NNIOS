//
//  ProfileUpdateDataV_M.swift
//  Neighbrsnooks
//
//  Created by Irshad Malik on 29/09/25.
//

import Foundation

class ProfileUpdateV_M: NSObject {
    static let shared = ProfileUpdateV_M()
    func ProfileUpdate(parameters: Parameters, completion: @escaping (_ result: ProfileUpdateDataModel?, _ error: String?) -> Void) {
        guard let url = URL(string: API.profileUpdate) else {
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
            resultType: ProfileUpdateDataModel.self,
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

func decryptProfileUpdateData(encryptedString: String, completion: @escaping (ProfileUpdateDataModelDecrypt?) -> Void) {
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
        resultType: ProfileUpdateDataModelDecrypt.self,
        headers: headers
    ) { response in

         completion(response)
    }
}


//awaitClearName

class AwaitClearNameV_M: NSObject {
    static let shared = AwaitClearNameV_M()
    func AwaitClearName(parameters: Parameters, completion: @escaping (_ result: UserClearAwaitStatusModel?, _ error: String?) -> Void) {
        guard let url = URL(string: API.awaitClearName) else {
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
            resultType: UserClearAwaitStatusModel.self,
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
