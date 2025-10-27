//
//  PollDetails_VM.swift
//  Neighbrsnooks
//
//  Created by Abdul Aleem on 25/09/25.
//

import Foundation

struct PollDetails_Request: Encodable {
    var poll_id : Int
}

struct pollUpdate_Request:Encodable {
    var title: String?
    var question: String?
    var options: [String]?
    var start_date: String?
    var end_date: String?
    var id:Int?
}

struct pollVote_Request:Encodable {
    var poll_id:Int?
    var option_id:Int?
}



//MARK: - ViewModel_PollDetails

class PollDetail_VM: NSObject {
    
    // Poll Detail
    func fetchPollDetailData(parameter: Parameters, request: PollDetails_Request, completion: @escaping (_ result: PollDetailsResponse?) -> Void) {
        let pollDetailListUrl = URL(string: API.pollDetails)!
        let httpUtility = HttpUtility()
        let pollDetailPostBody = parameter.percentEncoded()
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
          let headers = [ "Authorization": "Bearer \(token)"]
        
        httpUtility.postApiData(
            requestUrl: pollDetailListUrl,
            requestBody: pollDetailPostBody!,
            httpMethod: "POST",
            resultType: PollDetailsResponse.self,
            headers: headers
        ) { (groupListApiResponse) in
            completion(groupListApiResponse)

        }
    }
    
    func decryptPollDetailsData(encryptedString: String, completion: @escaping (PollDetailsDecryptModel?) -> Void) {
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
            resultType: PollDetailsDecryptModel.self, // Sahi resultType!
            headers: headers
        ) { response in
            completion(response)
        }
    }
    
    // Poll Delete
    func fetchPollDelete(parameter: Parameters, request: PollDetails_Request, completion: @escaping (_ result: PollDeleteResponse?) -> Void) {
        let pollDeleteUrl = URL(string: API.pollDelete)!
        let httpUtility = HttpUtility()
        let pollDeletePostBody = parameter.percentEncoded()
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
          let headers = [ "Authorization": "Bearer \(token)"]
        
        httpUtility.postApiData(
            requestUrl: pollDeleteUrl,
            requestBody: pollDeletePostBody!,
            httpMethod: "POST",
            resultType: PollDeleteResponse.self,
            headers: headers
        ) { (groupListApiResponse) in
            completion(groupListApiResponse)

        }
    }
    
    // Poll Update
    func fetchPollUpdate(parameter: Parameters, request: pollUpdate_Request, completion: @escaping (_ result: PollDeleteResponse?) -> Void) {
        let pollDeleteUrl = URL(string: API.createPoll)!
        let httpUtility = HttpUtility()
        let pollDeletePostBody = parameter.percentEncoded()
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
          let headers = [ "Authorization": "Bearer \(token)"]
        
        httpUtility.postApiData(
            requestUrl: pollDeleteUrl,
            requestBody: pollDeletePostBody!,
            httpMethod: "POST",
            resultType: PollDeleteResponse.self,
            headers: headers
        ) { (groupListApiResponse) in
            completion(groupListApiResponse)

        }
    }
    
    // Poll Vote
    func fetchPollVote(parameter: Parameters, request: pollVote_Request, completion: @escaping (_ result: PollVoteResponse?) -> Void) {
        let pollVoteUrl = URL(string: API.pollVote)!
        let httpUtility = HttpUtility()
        let pollVotePostBody = parameter.percentEncoded()
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
        let headers = [ "Authorization": "Bearer \(token)"]
        
        httpUtility.postApiData(
            requestUrl: pollVoteUrl,
            requestBody: pollVotePostBody!,
            httpMethod: "POST",
            resultType: PollVoteResponse.self,
            headers: headers
        ) { (groupListApiResponse) in
            completion(groupListApiResponse)
        }
    }
}


