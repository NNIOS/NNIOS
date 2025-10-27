//
//  HomeV_M.swift
//  Neighbrsnooks
//
//  Created by Irshad Malik on 24/09/25.
//

import Foundation

class HomeV_M: NSObject {
    static let shared = HomeV_M()
    func HomeAllData(parameters: Parameters, completion: @escaping (_ result: HomeDataModel?, _ error: String?) -> Void) {
        guard let url = URL(string: API.homeDataApi) else {
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
            resultType: HomeDataModel.self,
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

func decryptHomeData(encryptedString: String, completion: @escaping (HomeModelDecrypt?) -> Void) {
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

    // ⭐️ YAHAN PE resultType now HomeDecryptOuter.self
    httpUtility.postApiData(
        requestUrl: url,
        requestBody: postBody,
        httpMethod: "POST",
        resultType: HomeDecryptOuter.self,
        headers: headers
    ) { response in
         completion(response?.data)
    }
}


//MARK: - FierbaseTokenUpdateModel



class FierbaseTokenUpdateV_M: NSObject {
    static let shared = FierbaseTokenUpdateV_M()
    func FierbaseTokenUpdate(parameters: Parameters, completion: @escaping (_ result: FierbaseTokenUpdateModel?, _ error: String?) -> Void) {
        guard let url = URL(string: API.firebase_tokenApi) else {
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
            resultType: FierbaseTokenUpdateModel.self,
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
