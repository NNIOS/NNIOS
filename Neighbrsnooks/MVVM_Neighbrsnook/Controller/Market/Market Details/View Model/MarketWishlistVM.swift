//
//  MarketWishlistVM.swift
//  Neighbrsnooks
//
//  Created by Abdul Aleem on 08/10/25.
//

import Foundation
struct MarketWishlistRequest:Encodable {
    var product_id:Int
}


class MarketWishlistVM: NSObject {
    func toggleWishList(parameter: Parameters, request: MarketWishlistRequest, completion: @escaping (_ result: MarketWishlistResponse?) -> Void) {
        let wishListUrl = URL(string: API.toggleWishlist)!   // <- endpoint
        let httpUtility = HttpUtility()
        
        guard let wishListPostBody = parameter.percentEncoded() else {
            completion(nil)
            return
        }
        
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
          let headers = [ "Authorization": "Bearer \(token)"]
        
        httpUtility.postApiData(
            requestUrl: wishListUrl,
            requestBody: wishListPostBody,
            httpMethod: "POST",
            resultType: MarketWishlistResponse.self,
            headers: headers
        ) { (wishListResponse) in
            completion(wishListResponse)
        }
    }
}
