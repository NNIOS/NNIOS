//
//  EventDeatils.swift
//  Neighbrsnooks
//
//  Created by Abdul Aleem on 29/09/25.
//

import Foundation


struct EventDeatils_Request:Encodable {
    var id:Int
}


struct EventAttend_Request:Encodable {
    var event_id:Int
    var flag:String
}

struct EventUnAttend_Request:Encodable {
    var event_id:Int
    var flag:String
}

struct EventImage_Request:Encodable {
    var image:String
    var event_id:Int
}

struct EventImageDelete_Request:Encodable {
    var image_id:Int
}

struct EventLike_Request:Encodable {
    var event_id:Int
}


class EventDeatilsVM: NSObject {
    func eventDetails(parameter: Parameters, request: EventDeatils_Request, completion: @escaping (_ result: EventDetailsResponse?) -> Void) {
        let eventDetailsUrl = URL(string: API.eventsDetails)!
        let httpUtility = HttpUtility()
        
        guard let eventDetailsPostBody = parameter.percentEncoded() else {
            completion(nil)
            return
        }
        
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
          let headers = [ "Authorization": "Bearer \(token)"]
        
        httpUtility.postApiData(
            requestUrl: eventDetailsUrl,
            requestBody: eventDetailsPostBody,
            httpMethod: "POST",
            resultType: EventDetailsResponse.self,
            headers: headers
        ) { (eventDetailsResponse) in
            completion(eventDetailsResponse)
        }
    }
    
    func decryptEventDetailsData(encryptedString: String, completion: @escaping (decryptEvent?) -> Void) {
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
            resultType: decryptEvent.self,
            headers: headers
        ) { response in
            completion(response)
        }
    }
    
  
    
    func eventAttendApi(parameter: Parameters, request: EventAttend_Request, completion: @escaping (_ result: EventAttendResponse?) -> Void) {
        let eventAttendUrl = URL(string: API.eventsAttend)!
        let httpUtility = HttpUtility()
        
        guard let eventAttendPostBody = parameter.percentEncoded() else {
            completion(nil)
            return
        }
        
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
          let headers = [ "Authorization": "Bearer \(token)"]
        
        httpUtility.postApiData(
            requestUrl: eventAttendUrl,
            requestBody: eventAttendPostBody,
            httpMethod: "POST",
            resultType: EventAttendResponse.self,
            headers: headers
        ) { (eventAttendResponse) in
            completion(eventAttendResponse)
        }
    }
    
    func eventUnAttendApi(parameter: Parameters, request: EventUnAttend_Request, completion: @escaping (_ result: EventUnattendRespnse?) -> Void) {
        let eventUnAttendUrl = URL(string: API.eventsAttend)!
        let httpUtility = HttpUtility()
        
        guard let eventUnAttendPostBody = parameter.percentEncoded() else {
            completion(nil)
            return
        }
        
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
          let headers = [ "Authorization": "Bearer \(token)"]
        
        httpUtility.postApiData(
            requestUrl: eventUnAttendUrl,
            requestBody: eventUnAttendPostBody,
            httpMethod: "POST",
            resultType: EventUnattendRespnse.self,
            headers: headers
        ) { (eventUnAttendResponse) in
            completion(eventUnAttendResponse)
        }
    }
    
    func eventImageApi(parameter: Parameters, request: EventImage_Request, completion: @escaping (_ result: EventImageResponse?) -> Void) {
        let eventImagedUrl = URL(string: API.eventsImage)!
        let httpUtility = HttpUtility()
        guard let eventImagePostBody = parameter.percentEncoded() else {
            completion(nil)
            return
        }
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
          let headers = [ "Authorization": "Bearer \(token)"]
        httpUtility.postApiData(
            requestUrl: eventImagedUrl,
            requestBody: eventImagePostBody,
            httpMethod: "POST",
            resultType: EventImageResponse.self,
            headers: headers
        ) { (eventImageResponse) in
            completion(eventImageResponse)
        }
    }
    
    func eventImageDeleteApi(parameter: Parameters, request: EventImageDelete_Request, completion: @escaping (_ result: EventImageDeleteResponse?) -> Void) {
        let eventImageDeletedUrl = URL(string: API.eventsImageDelete)!
        let httpUtility = HttpUtility()
        guard let eventImageDeletePostBody = parameter.percentEncoded() else {
            completion(nil)
            return
        }
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
        let headers = [ "Authorization": "Bearer \(token)"]
        httpUtility.postApiData(
            requestUrl: eventImageDeletedUrl,
            requestBody: eventImageDeletePostBody,
            httpMethod: "POST",
            resultType: EventImageDeleteResponse.self,
            headers: headers
        ) { (eventImageDeleteResponse) in
            completion(eventImageDeleteResponse)
        }
    }
    
    func eventLikeApi(parameter: Parameters, request: EventLike_Request, completion: @escaping (_ result: EventLikeResponse?) -> Void) {
        let eventLikeUrl = URL(string: API.eventsLike)!
        let httpUtility = HttpUtility()
        guard let eventLikePostBody = parameter.percentEncoded() else {
            completion(nil)
            return
        }
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
        let headers = [ "Authorization": "Bearer \(token)"]
        httpUtility.postApiData(
            requestUrl: eventLikeUrl,
            requestBody: eventLikePostBody,
            httpMethod: "POST",
            resultType: EventLikeResponse.self,
            headers: headers
        ) { (eventLikeResponse) in
            completion(eventLikeResponse)
        }
    }
}
