//
//  CreateEventsVM.swift
//  Neighbrsnooks
//
//  Created by Abdul Aleem on 26/09/25.
//

import Foundation
struct CreateEvent_Request: Encodable {
    let title: String
    let event_date:String
    let event_end_date: String
    let event_start_time: String
    let event_end_time:String
    let cover_image:String
    let event_detail:String
    let address_line_one:String
    let address_line_two:String
//    let id: Int
}

struct EventDelete_Request: Encodable {
    let event_id:Int
}


struct EventUpdate_Request:Encodable {
    let title: String
    let event_date:String
    let event_end_date: String
    let event_start_time: String
    let event_end_time:String
    let cover_image:String
    let event_detail:String
    let address_line_one:String
    let address_line_two:String
    let id: Int
}


class CreateEvent_VM: NSObject {
    func createEvent(parameter: Parameters, request: CreateEvent_Request, completion: @escaping (_ result: CreateEventsResponse?) -> Void) {
        let createEventUrl = URL(string: API.createEvents)!
        let httpUtility = HttpUtility()
        
        guard let eventPostBody = parameter.percentEncoded() else {
            completion(nil)
            return
        }
        
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
          let headers = [ "Authorization": "Bearer \(token)"]
        
        httpUtility.postApiData(
            requestUrl: createEventUrl,
            requestBody: eventPostBody,
            httpMethod: "POST",
            resultType: CreateEventsResponse.self,
            headers: headers
        ) { (createEventApiResponse) in
            completion(createEventApiResponse)
        }
    }
   
    func eventDelete(parameter: Parameters, request: EventDelete_Request, completion: @escaping (_ result: EventDeleteResponse?) -> Void) {
        let eventDeleteUrl = URL(string: API.eventsDelete)!
        let httpUtility = HttpUtility()
        guard let eventPostBody = parameter.percentEncoded() else {
            completion(nil)
            return
        }
        
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
          let headers = [ "Authorization": "Bearer \(token)"]
        httpUtility.postApiData(
            requestUrl: eventDeleteUrl,
            requestBody: eventPostBody,
            httpMethod: "POST",
            resultType: EventDeleteResponse.self,
            headers: headers
        ) { (eventDeleteApiResponse) in
            completion(eventDeleteApiResponse)
        }
    }
    
    func eventUpdate(parameter: Parameters, request: EventDelete_Request, completion: @escaping (_ result: EventUpdateResponse?) -> Void) {
        let eventUpdateUrl = URL(string: API.createEvents)!
        let httpUtility = HttpUtility()
        guard let eventPostBody = parameter.percentEncoded() else {
            completion(nil)
            return
        }
        
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
          let headers = [ "Authorization": "Bearer \(token)"]
        httpUtility.postApiData(
            requestUrl: eventUpdateUrl,
            requestBody: eventPostBody,
            httpMethod: "POST",
            resultType: EventUpdateResponse.self,
            headers: headers
        ) { (eventUpdateApiResponse) in
            completion(eventUpdateApiResponse)
        }
    }
    
    
}
