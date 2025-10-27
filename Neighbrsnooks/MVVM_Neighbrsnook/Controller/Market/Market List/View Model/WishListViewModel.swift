//
//  WishListViewModel.swift
//  Neighbrsnooks
//
//  Created by Abdul Aleem on 07/10/25.
//

import Foundation


class WishListViewModel: NSObject {
    
    func fetchWishListData(completion: @escaping (_ result: WishListResponse?) -> Void) {
        let wishListApiUrl = URL(string: API.wishList)!
        let httpUtility = HttpUtility()
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
        let headers = ["Authorization": "Bearer \(token)"]
        httpUtility.postApiData(
            requestUrl: wishListApiUrl,
            requestBody: Data(),
            httpMethod: "POST",
            resultType: WishListResponse.self,
            headers: headers
        ) { (WishListApiResponse) in
            completion(WishListApiResponse)
        }
    }
    
    func decryptWishListData(encryptedString: String, completion: @escaping (DecryptWishlistResponse?) -> Void) {
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
            resultType: DecryptWishlistResponse.self,
            headers: headers
        ) { response in
            completion(response)
        }
    }
}
