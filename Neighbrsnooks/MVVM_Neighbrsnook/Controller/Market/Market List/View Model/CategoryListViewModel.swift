//
//  CategoryListViewModel.swift
//  Neighbrsnooks
//
//  Created by Abdul Aleem on 07/10/25.
//

import Foundation

class CategoryListViewModel: NSObject {
    
    func fetchCategoryListData(completion: @escaping (_ result: PopularCategoryResponse?) -> Void) {
        let popularCategoryApiUrl = URL(string: API.popularCategories)!
        let httpUtility = HttpUtility()
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
        let headers = ["Authorization": "Bearer \(token)"]
        httpUtility.postApiData(
            requestUrl: popularCategoryApiUrl,
            requestBody: Data(),
            httpMethod: "POST",
            resultType: PopularCategoryResponse.self,
            headers: headers
        ) { (PopularCategoryApiResponse) in
            completion(PopularCategoryApiResponse)
        }
    }
    
    func decryptCategoryListData(encryptedString: String, completion: @escaping (DecryptPopularCategoryResponse?) -> Void) {
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
            resultType: DecryptPopularCategoryResponse.self,
            headers: headers
        ) { response in
            completion(response)
        }
    }
}
