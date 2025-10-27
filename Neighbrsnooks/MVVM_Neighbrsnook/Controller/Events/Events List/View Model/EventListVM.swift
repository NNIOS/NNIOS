//
//  EventListVM.swift
//  Neighbrsnooks
//
//  Created by Abdul Aleem on 26/09/25.
//

import Foundation

struct EventList_Request:Encodable {
    var type : String
    var neighbr_id:Int
    var other_user_id:Int?
    var page : Int
}



//MARK: ViewModel_GroupList
class EventList_VM: NSObject {
    func fetchEventListData(parameter: Parameters, request: EventList_Request, completion: @escaping (_ result: EventsListResponse?) -> Void) {
        let eventListUrl = URL(string: API.eventsList)!
        let httpUtility = HttpUtility()
        let eventListPostBody = parameter.percentEncoded()
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
        let headers = [ "Authorization": "Bearer \(token)"]
      
        httpUtility.postApiData(
            requestUrl: eventListUrl,
            requestBody: eventListPostBody!,
            httpMethod: "POST",
            resultType: EventsListResponse.self,
            headers: headers
        ) { (eventListApiResponse) in
            completion(eventListApiResponse)

        }
    }
    
    func decryptEventListData(encryptedString: String, completion: @escaping (EventListDecryptModel?) -> Void) {
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
            resultType: EventListDecryptModel.self, // Sahi resultType!
            headers: headers
        ) { response in
            completion(response)
        }
    }
    
    
}


