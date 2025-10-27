//
//  SearchMarketViewModel.swift
//  Neighbrsnooks
//
//  Created by Abdul Aleem on 07/10/25.
//

import Foundation


struct SearchMarketRequest: Encodable {
    let search_query: String
}

class SearchMarketVM: NSObject {
    
    func fetchSearchMarket(parameter: Parameters, request: SearchMarketRequest, completion: @escaping (_ result: SearchMarketResponse?) -> Void) {
        let searchMarketUrl = URL(string: API.searchMarketProduct)!
        let httpUtility = HttpUtility()
        guard let searchMarketBody = parameter.percentEncoded() else {
            completion(nil)
            return
        }
        
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
        let headers = [ "Authorization": "Bearer \(token)"]
        httpUtility.postApiData(
            requestUrl: searchMarketUrl,
            requestBody: searchMarketBody,
            httpMethod: "POST",
            resultType: SearchMarketResponse.self,
            headers: headers
        ) { (searchMarketApiResponse) in
            completion(searchMarketApiResponse)
        }
    }
    
    func decryptSearchMArket(encryptedString: String, completion: @escaping (DecryptSearchMarketResponse?) -> Void) {
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
            resultType: DecryptSearchMarketResponse.self,
            headers: headers
        ) { response in
            completion(response)
        }
    }
}
