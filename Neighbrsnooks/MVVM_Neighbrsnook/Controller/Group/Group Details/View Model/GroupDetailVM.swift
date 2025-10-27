//
//  GroupDetailVM.swift
//  Neighbrsnooks
//
//  Created by Abdul Aleem on 20/09/25.
//

import Foundation

struct GroupDetails_Request: Encodable {
    var id : Int
}

//MARK: ViewModel_GroupDetail
class GroupDetail_VM: NSObject {
    func fetchGroupDetailData(parameter: Parameters, request: GroupDetails_Request, completion: @escaping (_ result: GroupDetailResponse?) -> Void) {
        let groupDetailUrl = URL(string: API.groupDeatail)!
        let httpUtility = HttpUtility()
        let groupDetailPostBody = parameter.percentEncoded()
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
        let headers = [ "Authorization": "Bearer \(token)"]
        httpUtility.postApiData(
            requestUrl: groupDetailUrl,
            requestBody: groupDetailPostBody!,
            httpMethod: "POST",
            resultType: GroupDetailResponse.self,
            headers: headers
        ) { (groupListApiResponse) in
            completion(groupListApiResponse)
        }
    }
}
