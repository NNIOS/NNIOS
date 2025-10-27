//
//  RegistationSecondVM.swift
//  Neighbrsnooks
//
//  Created by Irshad Malik on 19/09/25.
//

import Foundation

//MARK: - Current_Location
class LocationServiceManager: NSObject {
    static let shared = LocationServiceManager()    // Singleton pattern
    
    func saveCurrentLocation(parameters: Parameters, completion: @escaping (_ result: LocationResponse?) -> Void) {
        guard let url = URL(string: API.currentLocation) else {
            completion(nil)
            return
        }
        let httpUtility = HttpUtility()
        guard let postBody = parameters.percentEncoded() else {
            completion(nil)
            return
        }

        // Fetch token from UserDefaults
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
        let headers = ["Authorization": "Bearer \(token)"]

        httpUtility.postApiData(
            requestUrl: url,
            requestBody: postBody,
            httpMethod: "POST",
            resultType: LocationResponse.self, headers: headers
        ) { response in
            completion(response)
        }
    }
}

//MARK: - Device Registation

class DeviceRegisterManager: NSObject {
    static let shared = DeviceRegisterManager()    // Singleton pattern
    
    func saveDeviceRegisterManager(parameters: Parameters, completion: @escaping (_ result: DeviceRegisterModel?) -> Void) {
        guard let url = URL(string: API.DeviceRegister) else {
            completion(nil)
            return
        }
        let httpUtility = HttpUtility()
        guard let postBody = parameters.percentEncoded() else {
            completion(nil)
            return
        }

        // Fetch token from UserDefaults
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
        let headers = ["Authorization": "Bearer \(token)"]

        httpUtility.postApiData(
            requestUrl: url,
            requestBody: postBody,
            httpMethod: "POST",
            resultType: DeviceRegisterModel.self, headers: headers
        ) { response in
            completion(response)
        }
    }
}





//MARK: - SearchNeighborhood 
class SearchNeighborhoodManager: NSObject {
    static let shared = SearchNeighborhoodManager()

    func SearchNeighborhood(parameters: Parameters, completion: @escaping (_ result: SearchNeighborhoodModel?) -> Void) {
        guard let url = URL(string: API.searchneighborhood) else {
            completion(nil)
            return
        }
        let httpUtility = HttpUtility()
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
            resultType: SearchNeighborhoodModel.self,
            headers: headers
        ) { response in
            completion(response)
        }
    }

    // ----------- YEH LINE ZAROOR ADD KARO -------------
    // Yeh function apni manager class ke andar rakho:
    func decryptNeighborhoodData(encryptedString: String, completion: @escaping (DecryptedNeighborhoodModel?) -> Void) {
        guard let url = URL(string: API.decrypt) else {
            completion(nil)
            return
        }
        let httpUtility = HttpUtility()
        
        // Yahan field name change karo: "decrypt" hona chahiye (pehle "data" tha)
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
            resultType: DecryptedNeighborhoodModel.self,
            headers: headers
        ) { response in
            completion(response)
        }
    }

    // ---------------------------------------------------
}


class ReachOutNeighborhoodV_M: NSObject {
    static let shared = ReachOutNeighborhoodV_M()
    
    func ReachOutNeighborhood(parameters: Parameters, completion: @escaping (_ result: ReachOutModel?) -> Void) {
        guard let url = URL(string: API.ReachOutCaseApi) else {
            completion(nil)
            return
        }
        let httpUtility = HttpUtility()
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
            resultType: ReachOutModel.self,
            headers: headers
        ) { response in
            completion(response)
        }
    }
}




class SecondSteepCompleteV_M: NSObject {
    static let shared = SecondSteepCompleteV_M()
    
    func SearchNeighborhood(parameters: Parameters, completion: @escaping (_ result: SecondCompleteModel?) -> Void) {
        guard let url = URL(string: API.register_2Api) else {
            completion(nil)
            return
        }
        let httpUtility = HttpUtility()
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
            resultType: SecondCompleteModel.self,
            headers: headers
        ) { response in
            completion(response)
        }
    }
}


func decryptCompleteData(encryptedString: String, completion: @escaping (DecryptedModelSecondSteep?) -> Void) {
    guard let url = URL(string: API.decrypt) else {
        completion(nil)
        return
    }
    let httpUtility = HttpUtility()
    
    // Yahan field name change karo: "decrypt" hona chahiye (pehle "data" tha)
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
        resultType: DecryptedModelSecondSteep.self,
        headers: headers
    ) { response in
        completion(response)
    }
}
