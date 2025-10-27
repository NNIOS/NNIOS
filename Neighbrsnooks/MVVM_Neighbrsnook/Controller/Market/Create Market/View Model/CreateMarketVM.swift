//
//  CreateMarketVM.swift
//  Neighbrsnooks
//
//  Created by Abdul Aleem on 06/10/25.
//

import Foundation

struct CreateMarket_Request:Encodable {
    var p_title:String
    var p_description:String
    var p_quantity:Int
    var sale_type:String
    var sale_price:Int
    var brand_name:String
    var cat_id:Int
    var media: [String]
}

class CreateMarket_VM: NSObject {
    func createMarket(parameter: Parameters, request: CreateMarket_Request, completion: @escaping (_ result: CreateMarketResponse?) -> Void) {
        let createMarketlUrl = URL(string: API.createMarket)!   // <- endpoint
        let httpUtility = HttpUtility()
        
        guard let createMarketPostBody = parameter.percentEncoded() else {
            completion(nil)
            return
        }
        
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
        let headers = [ "Authorization": "Bearer \(token)"]
        
        httpUtility.postApiData(
            requestUrl: createMarketlUrl,
            requestBody: createMarketPostBody,
            httpMethod: "POST",
            resultType: CreateMarketResponse.self,
            headers: headers
        ) { (createMarketApiResponse) in
            completion(createMarketApiResponse)
        }
    }
}
