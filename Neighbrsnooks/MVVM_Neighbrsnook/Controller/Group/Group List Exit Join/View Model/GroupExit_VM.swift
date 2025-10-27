//
//  GroupExit_VM.swift
//  Neighbrsnooks
//
//  Created by Abdul Aleem on 22/09/25.
//

import Foundation
class  GroupExit_VM: NSObject {
    
    func groupExit(parameter: Parameters, request: GroupExit_Request, completion: @escaping (_ result: GroupExitResponse?) -> Void) {
        let groupExitGrpUrl = URL(string: API.groupExit)!
        let httpUtility = HttpUtility()
        
        guard let registerPostBody = parameter.percentEncoded() else {
            completion(nil)
            return
        }
        
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
          let headers = [ "Authorization": "Bearer \(token)"]
        
        httpUtility.postApiData(
            requestUrl: groupExitGrpUrl,
            requestBody: registerPostBody,
            httpMethod: "POST",
            resultType: GroupExitResponse.self,
            headers: headers
        ) { (CreateGroupApiResponse) in
            completion(CreateGroupApiResponse)
        }
    }
}
