//
//  MarketDeleteVM.swift
//  Neighbrsnooks
//
//  Created by Abdul Aleem on 08/10/25.
//

import Foundation

struct MarketDeleteRequest:Encodable {
    var product_id: Int?
}


class MarketDeleteVM: NSObject {
    func marketDelete(parameter: Parameters, request: MarketDeleteRequest, completion: @escaping (_ result: MarketDeleteResponse?) -> Void) {
        let marketDeleteUrl = URL(string: API.marketDelete)!   // <- endpoint
        let httpUtility = HttpUtility()
        
        guard let marketDeletePostBody = parameter.percentEncoded() else {
            completion(nil)
            return
        }
        
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
          let headers = [ "Authorization": "Bearer \(token)"]
        
        httpUtility.postApiData(
            requestUrl: marketDeleteUrl,
            requestBody: marketDeletePostBody,
            httpMethod: "POST",
            resultType: MarketDeleteResponse.self,
            headers: headers
        ) { (marketDeleteResponse) in
            completion(marketDeleteResponse)
        }
    }
}
