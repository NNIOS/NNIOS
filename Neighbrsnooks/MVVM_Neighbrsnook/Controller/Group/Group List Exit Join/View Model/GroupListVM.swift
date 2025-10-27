//
//  GroupListVM.swift
//  Neighbrsnooks
//
//  Created by Abdul Aleem on 19/09/25.
//

import Foundation


struct GroupListing_Request: Encodable {
    var type : String
    var page : Int
}

//MARK: ViewModel_GroupList
class GroupList_VM: NSObject {
    func fetchGroupListData(parameter: Parameters, request: GroupListing_Request, completion: @escaping (_ result: GroupListResponse?) -> Void) {
        let groupListUrl = URL(string: API.grouplist)!
        let httpUtility = HttpUtility()
        let groupListPostBody = parameter.percentEncoded()
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
          let headers = [ "Authorization": "Bearer \(token)"]
        
        httpUtility.postApiData(
            requestUrl: groupListUrl,
            requestBody: groupListPostBody!,
            httpMethod: "POST",
            resultType: GroupListResponse.self,
            headers: headers
        ) { (groupListApiResponse) in
            completion(groupListApiResponse)

        }
    }
    
    
    
}


