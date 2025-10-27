//
//  GroupMember_VM.swift
//  Neighbrsnooks
//
//  Created by Abdul Aleem on 23/09/25.
//

import Foundation
class  GroupMember_VM: NSObject {
    
    func groupmember(parameter: Parameters, request: GroupMember_Request, completion: @escaping (_ result: GroupMemberResponse?) -> Void) {
        let groupMemberUrl = URL(string: API.groupMember)!
        let httpUtility = HttpUtility()
        guard let registerPostBody = parameter.percentEncoded() else {
            completion(nil)
            return
        }
        
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
          let headers = [ "Authorization": "Bearer \(token)"]
        print("login token auth:\(token)")
        
        httpUtility.postApiData(
            requestUrl: groupMemberUrl,
            requestBody: registerPostBody,
            httpMethod: "POST",
            resultType: GroupMemberResponse.self,
            headers: headers
        ) { (CreateGroupApiResponse) in
            completion(CreateGroupApiResponse)
        }
    }
    
    func groupApprove(parameter: Parameters, request: GroupApprove_Request, completion: @escaping (_ result: GroupJoinResponse?) -> Void) {
        let groupAcceptUrl = URL(string: API.groupApprove)!
        let httpUtility = HttpUtility()
        guard let registerPostBody = parameter.percentEncoded() else {
            completion(nil)
            return
        }
        
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
          let headers = [ "Authorization": "Bearer \(token)"]
        print("login token auth:\(token)")
        
        httpUtility.postApiData(
            requestUrl: groupAcceptUrl,
            requestBody: registerPostBody,
            httpMethod: "POST",
            resultType: GroupJoinResponse.self,
            headers: headers
        ) { (CreateGroupApiResponse) in
            completion(CreateGroupApiResponse)
        }
    }
    
    func groupDeclineRemove(parameter: Parameters, request: GroupApprove_Request, completion: @escaping (_ result: GroupJoinResponse?) -> Void) {
        let groupAcceptUrl = URL(string: API.groupDecRemove)!
        let httpUtility = HttpUtility()
        guard let registerPostBody = parameter.percentEncoded() else {
            completion(nil)
            return
        }
        
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
          let headers = [ "Authorization": "Bearer \(token)"]
        print("login token auth:\(token)")
        
        httpUtility.postApiData(
            requestUrl: groupAcceptUrl,
            requestBody: registerPostBody,
            httpMethod: "POST",
            resultType: GroupJoinResponse.self,
            headers: headers
        ) { (CreateGroupApiResponse) in
            completion(CreateGroupApiResponse)
        }
    }
}
