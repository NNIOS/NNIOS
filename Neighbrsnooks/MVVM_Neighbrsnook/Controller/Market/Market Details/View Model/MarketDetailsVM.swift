//
//  MarketDetailsVM.swift
//  Neighbrsnooks
//
//  Created by Abdul Aleem on 08/10/25.
//

import Foundation

struct MarketDetailsRequest: Encodable {
    var product_id : Int
}

class MarketDetailsVM: NSObject {
    
    // Market Details
    func fetchMarketDetailsData(parameter: Parameters, request: MarketDetailsRequest, completion: @escaping (_ result: MarketDetailsResponse?) -> Void) {
        let marketDetailUrl = URL(string: API.marketDetails)!
        let httpUtility = HttpUtility()
        let marketDetailPostBody = parameter.percentEncoded()
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
        let headers = [ "Authorization": "Bearer \(token)"]
        
        httpUtility.postApiData(
            requestUrl: marketDetailUrl,
            requestBody: marketDetailPostBody!,
            httpMethod: "POST",
            resultType: MarketDetailsResponse.self,
            headers: headers
        ) { (marketDetailApiResponse) in
            completion(marketDetailApiResponse)
        }
    }
    
    func decryptMarketDetailsData(encryptedString: String, completion: @escaping (DecryptMarketDetailsResponse?) -> Void) {
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
            resultType: DecryptMarketDetailsResponse.self,
            headers: headers
        ) { response in
            completion(response)
        }
    }
}
