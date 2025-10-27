//
//  GroupJoin_VM.swift
//  Neighbrsnooks
//
//  Created by Abdul Aleem on 22/09/25.
//

import Foundation


class  GroupJoin_VM: NSObject {
    func groupJoin(parameter: Parameters, request: GroupJoin_Request, completion: @escaping (_ result: GroupJoinResponse?) -> Void) {
        let groupJoinGrpUrl = URL(string: API.group_join)!
        let httpUtility = HttpUtility()
        
        guard let registerPostBody = parameter.percentEncoded() else {
            completion(nil)
            return
        }
        
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
          let headers = [ "Authorization": "Bearer \(token)"]
        
        httpUtility.postApiData(
            requestUrl: groupJoinGrpUrl,
            requestBody: registerPostBody,
            httpMethod: "POST",
            resultType: GroupJoinResponse.self,
            headers: headers
        ) { (CreateGroupApiResponse) in
            completion(CreateGroupApiResponse)
        }
    }
}
