//
//  SelectMarketCategoriesViewModel.swift
//  Neighbrsnooks
//
//  Created by Abdul Aleem on 06/10/25.
//

import Foundation


struct SelectMarketCategories_Request:Encodable {
    var decrypt: String
}


class SelectMarketCategoriesViewModel: NSObject {
    func selectMarketCategories(parameter: Parameters, request: SelectMarketCategories_Request, completion: @escaping (_ result: SelectMarketCategoriesResponse?) -> Void) {
        let selectMarketCategorieslUrl = URL(string: API.selectCategories)!   // <- endpoint
        let httpUtility = HttpUtility()
        
        guard let selectMarketCategoriesPostBody = parameter.percentEncoded() else {
            completion(nil)
            return
        }
        
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
        let headers = [ "Authorization": "Bearer \(token)"]
        
        httpUtility.postApiData(
            requestUrl: selectMarketCategorieslUrl,
            requestBody: selectMarketCategoriesPostBody,
            httpMethod: "POST",
            resultType: SelectMarketCategoriesResponse.self,
            headers: headers
        ) { (SelectMarketCategoriesApiResponse) in
            completion(SelectMarketCategoriesApiResponse)
        }
    }
    
    func decryptselectMarketCategoriesApi(encryptedString: String, completion: @escaping (DecryptedSelctedMarketCatResponse?) -> Void) {
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
            resultType: DecryptedSelctedMarketCatResponse.self, // Sahi resultType!
            headers: headers
        ) { response in
            completion(response)
        }
    }
}
