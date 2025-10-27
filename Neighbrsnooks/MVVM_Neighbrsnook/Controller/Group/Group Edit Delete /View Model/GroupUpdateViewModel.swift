//
//  GroupUpdateViewModel.swift
//  Neighbrsnooks
//
//  Created by Abdul Aleem on 22/09/25.
//

import Foundation

class GroupUpdate_VM: NSObject {
    func updateGroup(parameter: Parameters, request: GroupUpdate_Request, completion: @escaping (_ result: GroupUpdateResponse?) -> Void) {
        let updateGrpUrl = URL(string: API.updateGroup)!
        let httpUtility = HttpUtility()
        guard let registerPostBody = parameter.percentEncoded() else {
            completion(nil)
            return
        }
        
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
        let headers = [ "Authorization": "Bearer \(token)"]
        httpUtility.postApiData(
            requestUrl: updateGrpUrl,
            requestBody: registerPostBody,
            httpMethod: "POST",
            resultType: GroupUpdateResponse.self,
            headers: headers
        ) { (CreateGroupApiResponse) in  completion(CreateGroupApiResponse) }
    }
}
