//
//  CreateGroupViewModel.swift
//  Neighbrsnooks
//
//  Created by Abdul Aleem on 18/09/25.
//

import Foundation
import UIKit

class CreateGroup_VM: NSObject {
    func createGroup(parameter: Parameters, request: CreateGroup_Request, completion: @escaping (_ result: CreateGroupResponse?) -> Void) {
        let createGrpUrl = URL(string: API.createGroup)!   // <- endpoint
        let httpUtility = HttpUtility()
        
        guard let registerPostBody = parameter.percentEncoded() else {
            completion(nil)
            return
        }
        
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
          let headers = [ "Authorization": "Bearer \(token)"]
        
        httpUtility.postApiData(
            requestUrl: createGrpUrl,
            requestBody: registerPostBody,
            httpMethod: "POST",
            resultType: CreateGroupResponse.self,
            headers: headers
        ) { (CreateGroupApiResponse) in
            completion(CreateGroupApiResponse)
        }
    }
}
