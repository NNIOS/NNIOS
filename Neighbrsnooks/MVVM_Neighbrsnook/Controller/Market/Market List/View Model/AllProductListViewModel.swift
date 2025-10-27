//
//  AllProductListViewModel.swift
//  Neighbrsnooks
//
//  Created by Abdul Aleem on 07/10/25.
//

import Foundation


class AllProductListViewModel: NSObject {
    
    func fetchAllProductListData(completion: @escaping (_ result: AllProductListResponse?) -> Void) {
        let allProductListApiUrl = URL(string: API.allListCategories)!
        let httpUtility = HttpUtility()
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
        let headers = ["Authorization": "Bearer \(token)"]
        httpUtility.postApiData(
            requestUrl: allProductListApiUrl,
            requestBody: Data(),
            httpMethod: "POST",
            resultType: AllProductListResponse.self,
            headers: headers
        ) { (AllProductListApiResponse) in
            completion(AllProductListApiResponse)
        }
    }
    
    func decryptAllProductListData(encryptedString: String, completion: @escaping (DecryptAllProductListResponse?) -> Void) {
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
            resultType: DecryptAllProductListResponse.self,
            headers: headers
        ) { response in
            completion(response)
        }
    }
}
