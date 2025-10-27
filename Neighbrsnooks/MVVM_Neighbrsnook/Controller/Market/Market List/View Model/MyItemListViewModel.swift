//
//  MyItemListViewModel.swift
//  Neighbrsnooks
//
//  Created by Abdul Aleem on 07/10/25.
//

import Foundation


class MyItemListViewModel: NSObject {
    
    func fetchAuthProductData(completion: @escaping (_ result: MyItemListResponse?) -> Void) {
        let AuthProductsApiUrl = URL(string: API.AuthProducts)!
        let httpUtility = HttpUtility()
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
        let headers = ["Authorization": "Bearer \(token)"]
        httpUtility.postApiData(
            requestUrl: AuthProductsApiUrl,
            requestBody: Data(),
            httpMethod: "POST",
            resultType: MyItemListResponse.self,
            headers: headers
        ) { (AuthProductsApiResponse) in
            completion(AuthProductsApiResponse)
        }
    }
    
    func decryptAuthProductData(encryptedString: String, completion: @escaping (DecryptMyItemListResponse?) -> Void) {
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
            resultType: DecryptMyItemListResponse.self,
            headers: headers
        ) { response in
            completion(response)
        }
    }
}
