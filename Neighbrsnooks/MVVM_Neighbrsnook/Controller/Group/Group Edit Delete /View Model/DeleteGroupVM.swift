//
//  DeleteGroupVM.swift
//  Neighbrsnooks
//
//  Created by Abdul Aleem on 22/09/25.
//

import Foundation
class DeleteGroup_VM: NSObject {
    func deleteGroup(parameter: Parameters, request: DeleteGroup_Request, completion: @escaping (_ result: DeleteGroupResponse?) -> Void) {
        let DeleteGrpUrl = URL(string: API.groupDelete)!   // <- endpoint
        let httpUtility = HttpUtility()
        
        guard let registerPostBody = parameter.percentEncoded() else {
            completion(nil)
            return
        }
        
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
          let headers = [ "Authorization": "Bearer \(token)"]
        
        httpUtility.postApiData(
            requestUrl: DeleteGrpUrl,
            requestBody: registerPostBody,
            httpMethod: "POST",
            resultType: DeleteGroupResponse.self,
            headers: headers
        ) { (CreateGroupApiResponse) in
            completion(CreateGroupApiResponse)
        }
    }
}
