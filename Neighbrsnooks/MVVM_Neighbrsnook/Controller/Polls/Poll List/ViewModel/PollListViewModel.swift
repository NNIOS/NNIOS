//
//  PollListViewModel.swift
//  Neighbrsnooks
//
//  Created by Abdul Aleem on 24/09/25.
//

import Foundation

struct PollList_Request: Encodable {
    var type : String
//    var neighbr_id:Int
//    var other_user_id:Int?
    var page : Int
}

//MARK: ViewModel_GroupList
class PollList_VM: NSObject {
    func fetchPollListData(parameter: Parameters, request: PollList_Request, completion: @escaping (_ result: PollListResponse?) -> Void) {
        let groupListUrl = URL(string: API.pollList)!
        let httpUtility = HttpUtility()
        let groupListPostBody = parameter.percentEncoded()
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
          let headers = [ "Authorization": "Bearer \(token)"]
        
        httpUtility.postApiData(
            requestUrl: groupListUrl,
            requestBody: groupListPostBody!,
            httpMethod: "POST",
            resultType: PollListResponse.self,
            headers: headers
        ) { (groupListApiResponse) in
            completion(groupListApiResponse)

        }
    }
    
    func decryptPollListData(encryptedString: String, completion: @escaping (PollDecryptModel?) -> Void) {
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
            resultType: PollDecryptModel.self, // Sahi resultType!
            headers: headers
        ) { response in
            completion(response)
        }
    }
    
    
}


