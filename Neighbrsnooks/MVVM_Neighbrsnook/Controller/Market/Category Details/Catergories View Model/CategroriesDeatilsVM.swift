//
//  CategroriesDeatilsVM.swift
//  Neighbrsnooks
//
//  Created by Abdul Aleem on 09/10/25.
//

import Foundation 
struct CategroriesDeatilsRequest:Encodable {
    var cat_id:Int
}

class CategroriesDeatilsVM: NSObject {
    func fetchCategoriesFilter(parameter: Parameters, request: CategroriesDeatilsRequest, completion: @escaping (_ result: CategroriesDeatilsResponse?) -> Void) {
        let categoriesFilterUrl = URL(string: API.categoriesFilter)!
        let httpUtility = HttpUtility()
        let categoriesFilterPostBody = parameter.percentEncoded()
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
          let headers = [ "Authorization": "Bearer \(token)"]
        httpUtility.postApiData(
            requestUrl: categoriesFilterUrl,
            requestBody: categoriesFilterPostBody!,
            httpMethod: "POST",
            resultType: CategroriesDeatilsResponse.self,
            headers: headers
        ) { (CategoriesFilterApiResponse) in
            completion(CategoriesFilterApiResponse)
        }
    }
    
    func decryptCategoriesFilter(encryptedString: String, completion: @escaping (DecryptCategroriesDeatilsResponse?) -> Void) {
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
            resultType: DecryptCategroriesDeatilsResponse.self,
            headers: headers
        ) { response in
            completion(response)
        }
    }
}


