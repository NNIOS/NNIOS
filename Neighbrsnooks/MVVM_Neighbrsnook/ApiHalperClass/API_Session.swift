//
//  API_Session.swift
//  HRMS_DS
//
//  Created by Manish Mishra on 07/08/21.
//

import Foundation

import UIKit

fileprivate extension NSMutableData {
    func appendString(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}

struct HttpUtility {
    
    //    func getApiData<T:Decodable>(requestUrl: URL, resultType: T.Type, completionHandler:@escaping(_ result: T?)-> Void) {
    //        URLSession.shared.dataTask(with: requestUrl) { (responseData, httpUrlResponse, error) in
    //            if(error == nil && responseData != nil && responseData?.count != 0) {
    //                let decoder = JSONDecoder()
    //                do {
    //                    let result = try decoder.decode(T.self, from: responseData!)
    //                    _=completionHandler(result)
    //                }
    //                catch let error{
    //                    debugPrint("error occured while decoding = \(error)")
    //                }
    //            }
    //
    //        }.resume()
    //    }
    
    
    func getApiData<T: Decodable>(
        requestUrl: URL,
        parameters: [String: Any],
        resultType: T.Type,
        completionHandler: @escaping(_ result: T?) -> Void
    ) {
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        
        // Add API Key header (make sure this key is correct)
        request.addValue("0c7c034f-2527-4ed8-af37-95f8f6a02428", forHTTPHeaderField: "x-api-key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        } catch {
            completionHandler(nil)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (responseData, httpUrlResponse, error) in
            // First, check for network errors
            if let error = error {
                print("Network error: \(error)")
                completionHandler(nil)
                return
            }
            
            guard let data = responseData, !data.isEmpty else {
                completionHandler(nil)
                return
            }
            
            // Print raw response for debugging
            if let responseString = String(data: data, encoding: .utf8) {
                print("Raw API Response: \(responseString)")
            }
            
            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                completionHandler(result)
            } catch let decodingError {
                print("Decoding error: \(decodingError)")
                
                // Try to decode as error response
                if let errorResponse = try? JSONDecoder().decode(APIErrorResponse.self, from: data) {
                    print("API Error: \(errorResponse.error)")
                    // You might want to handle this differently
                }
                completionHandler(nil)
            }
        }.resume()
    }
    
    
    // Add this struct for error responses
    struct APIErrorResponse: Codable {
        let error: String
    }
    
    //MARK: - Get Api
    
    func getApiDatawithAuth<T: Decodable>(
        requestUrl: URLRequest,
        resultType: T.Type,
        completionHandler: @escaping (_ result: T?) -> Void
    ) {
        var urlRequest = requestUrl
        
        // ✅ Ensure Bearer token
        let authToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
        if !authToken.isEmpty {
            urlRequest.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
            print("🔑 Authorization header added: Bearer \(authToken)")
        } else {
            print("❌ Access token is empty")
        }
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                print("❌ API Error: \(error.localizedDescription)")
                completionHandler(nil)
                return
            }
            
            guard let data = data, data.count > 0 else {
                print("❌ API Response is empty")
                completionHandler(nil)
                return
            }
            
            // Debug response
            if let str = String(data: data, encoding: .utf8) {
                print("Response Data: \(str)")
            }
            
            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completionHandler(result)
                }
            } catch let decodeError {
                print("❌ Decoding error: \(decodeError)")
                DispatchQueue.main.async {
                    completionHandler(nil)
                }
            }
        }.resume()
    }
    
    
    
    func postApiData<T: Decodable>(
        requestUrl: URL,
        requestBody: Data,
        httpMethod: String,
        resultType: T.Type,
        headers: [String: String] = [:],
        completionHandler: @escaping(_ result: T?) -> Void
    ){
        var urlRequest = URLRequest(url: requestUrl)
        urlRequest.httpMethod = httpMethod
        urlRequest.httpBody = requestBody
        urlRequest.addValue("0c7c034f-2527-4ed8-af37-95f8f6a02428", forHTTPHeaderField: "x-api-key")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        // Add custom headers
        for (key, value) in headers {
            urlRequest.addValue(value, forHTTPHeaderField: key)
        }
        
        // Add Authorization header if token exists
        let authToken = UserDefault.shared.getAccessToken()
        if !authToken.isEmpty {
            urlRequest.addValue(authToken, forHTTPHeaderField: "Authorization")
        }
        
        print("URLRequest->\(urlRequest)")
        print("Authorization Token: \(authToken)")
        
        URLSession.shared.dataTask(with: urlRequest) { (data, httpUrlResponse, error) in
            if let data = data, !data.isEmpty {
                do {
                    let reponseJson = try JSONSerialization.jsonObject(with: data)
                    print("Response JSON: \(reponseJson)")
                    let response = try JSONDecoder().decode(T.self, from: data)
                    completionHandler(response)
                }
                catch let decodingError {
                    debugPrint("Decoding Error: \(decodingError)")
                    completionHandler(nil) // Pass nil on error
                }
            } else {
                completionHandler(nil) // Pass nil if no data
            }
        }.resume()
    }
    
    func postApiDatawithoutParameter<T:Decodable>(requestUrl: URL, httpMethod: String, resultType: T.Type, completionHandler:@escaping(_ result: T)-> Void) {
        
        var urlRequest = URLRequest(url: requestUrl)
        urlRequest.httpMethod = httpMethod
        urlRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "content-type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.addValue("\(UserDefault.shared.getAccessToken())", forHTTPHeaderField: "Authorization")
        print("URLRequest->\(urlRequest)")
        print("\(UserDefault.shared.getAccessToken())")
        URLSession.shared.dataTask(with: urlRequest) { (data, httpUrlResponse, error) in
            if(data != nil && data?.count != 0) {
                do {
                    let response = try JSONDecoder().decode(T.self, from: data!)
                    _=completionHandler(response)
                    
                }
                catch let decodingError {
                    debugPrint(decodingError)
                }
            }
        }.resume()
    }
    
    // MARK: - Multiple image post
    
    func upload_Reimburse_WithDocuments<T: Decodable>(
        url: String,
        parameters: Parameters,
        mediaFiles: [String: MediaTypeImageVid],  // ✅ yaha change
        authToken: String,
        httpMethod: String,
        resultType: T.Type,
        completionHandler: @escaping (_ result: T?) -> Void
    ) {
        let leaveUrl = URL(string: url)!
        let boundary = "Boundary-\(UUID().uuidString)"
        var request = URLRequest(url: leaveUrl)
        request.httpMethod = httpMethod
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")

        let dataBody = createBodyWithMultipleParameters(
            parameters: parameters,
            mediaFiles: mediaFiles,
            boundary: boundary
        )
        request.httpBody = dataBody
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response { print(response) }
            if let data = data {
                do {
                    let responseJson = try JSONSerialization.jsonObject(with: data)
                    print(responseJson)
                    let json = try JSONDecoder().decode(T.self, from: data)
                    completionHandler(json)
                } catch {
                    print(error)
                    completionHandler(nil)
                }
            } else {
                completionHandler(nil)
            }
        }
        task.resume()
    }

       
    private func createBodyWithMultipleParameters(
        parameters: Parameters,
        mediaFiles: [String: MediaTypeImageVid],
        boundary: String
    ) -> Data {
        let body = NSMutableData()
        
        // Parameters
        for (key, value) in parameters {
            body.appendString("--\(boundary)\r\n")
            body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString("\(value)\r\n")
        }
        
        // Media
        for (fieldName, file) in mediaFiles {
            switch file {
            case .image(let image):
                if let imageData = image.jpegData(compressionQuality: 0.7) {
                    body.appendString("--\(boundary)\r\n")
                    body.appendString("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(UUID().uuidString).jpg\"\r\n")
                    body.appendString("Content-Type: image/jpeg\r\n\r\n")
                    body.append(imageData)
                    body.appendString("\r\n")
                }
            case .video(let videoURL):
                if let videoData = try? Data(contentsOf: videoURL) {
                    body.appendString("--\(boundary)\r\n")
                    body.appendString("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(UUID().uuidString).mp4\"\r\n")
                    body.appendString("Content-Type: video/mp4\r\n\r\n")
                    body.append(videoData)
                    body.appendString("\r\n")
                }
            }
        }
        
        body.appendString("--\(boundary)--\r\n")
        return body as Data
    }


    
    
    
    // MARK: - Decrypt Login Response (Token/Id)
    func decryptLoginData(encryptedData: String, completion: @escaping (LoginTokenResponse?) -> Void) {
        guard let url = URL(string: API.decrypt) else { completion(nil); return }
        let params = ["decrypt": encryptedData]
        guard let requestBody = params.percentEncoded() else { completion(nil); return }
        
        self.postApiData(
            requestUrl: url,
            requestBody: requestBody,
            httpMethod: "POST",
            resultType: DecryptLoginApiResponse.self
        ) { response in
            if let tokenData = response?.data?.data {
                completion(tokenData)
            } else {
                print("❌ Decrypt failed or invalid response structure - expected LoginTokenResponse")
                completion(nil)
            }
        }
    }
    
    // MARK: - Decrypt User Profile Response
    func decryptUserProfileData(encryptedData: String, completion: @escaping (UserData?) -> Void) {
        guard let url = URL(string: API.decrypt) else { completion(nil); return }
        let params = ["decrypt": encryptedData]
        guard let requestBody = params.percentEncoded() else { completion(nil); return }
        
        self.postApiData(
            requestUrl: url,
            requestBody: requestBody,
            httpMethod: "POST",
            resultType: DecryptProfileApiResponse.self
        ) { response in
            if let userData = response?.data?.data {
                print("Raw decrypted profile data: \(userData)")
                completion(userData)
            } else {
                print("❌ Decrypt failed or invalid response structure - expected UserData")
                completion(nil)
            }
        }
    }
    
    
    
    
    
    func decryptGroupListData(encryptedData: String, completion: @escaping (DecryptGroupList?) -> Void) {
        guard let url = URL(string: API.decrypt) else {
            completion(nil)
            return
        }
        
        let params = ["decrypt": encryptedData]
        guard let requestBody = params.percentEncoded() else {
            completion(nil)
            return
        }
        self.postApiData(
            requestUrl: url,
            requestBody: requestBody,
            httpMethod: "POST",
            resultType: GroupDecryptListApiResponse<DecryptGroupList>.self
        ) { response in
            if let decrypted = response?.data {
                completion(decrypted)
            } else {
                print("❌ Failed to decode DecryptGroupList directly")
                completion(nil)
            }
        }
    }
    
    func decryptGroupDetailtData(encryptedData: String, completion: @escaping (DecryptGroupDetailsList?) -> Void) {
        guard let url = URL(string: API.decrypt) else { completion(nil)
            return
        }
        
        let params = ["decrypt": encryptedData]
        guard let requestBody = params.percentEncoded() else { completion(nil)
            return
        }
        self.postApiData(
            requestUrl: url,
            requestBody: requestBody,
            httpMethod: "POST",
            resultType: GroupDecryptDetailApiResponse<DecryptGroupDetailsList>.self
        ) { response in
            if let decrypted = response?.data {  completion(decrypted)
            } else {
                print("❌ Failed to decode DecryptGroupList directly")
                completion(nil)
            }
        }
    }
    
    
    func decryptGroupMembertData(encryptedData: String, completion: @escaping ([GroupMemberData]?) -> Void) {
        guard let url = URL(string: API.decrypt) else {
            completion(nil)
            return
        }
        
        let params = ["decrypt": encryptedData]
        guard let requestBody = params.percentEncoded() else {
            completion(nil)
            return
        }
        
        self.postApiData(
            requestUrl: url,
            requestBody: requestBody,
            httpMethod: "POST",
            resultType: DecryptGroupMemberResponse.self
        ) { response in
            if let decryptedArray = response?.data?.data {
                completion(decryptedArray)   // return the array of members
            } else {
                print("❌ Failed to decode DecryptGroupMemberResponse")
                completion(nil)
            }
        }
    }
    
    
    
}


