//
//  LatestProductViewModel.swift
//  Neighbrsnooks
//
//  Created by Abdul Aleem on 07/10/25.
//

import Foundation

class LatestProductViewModel: NSObject {
    
    func fetchLatestProducttData(completion: @escaping (_ result: LatestProductListResponse?) -> Void) {
        let latestProductsApiUrl = URL(string: API.latestProducts)!
        let httpUtility = HttpUtility()
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
        let headers = ["Authorization": "Bearer \(token)"]
        httpUtility.postApiData(
            requestUrl: latestProductsApiUrl,
            requestBody: Data(),
            httpMethod: "POST",
            resultType: LatestProductListResponse.self,
            headers: headers
        ) { (LatestProductsApiResponse) in
            completion(LatestProductsApiResponse)
        }
    }
    
    func decryptLatestProductData(encryptedString: String, completion: @escaping (DecryptLatestListResponse?) -> Void) {
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
            resultType: DecryptLatestListResponse.self,
            headers: headers
        ) { response in
            completion(response)
        }
    }
}
