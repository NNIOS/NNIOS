//
//  LoginViewModel.swift
//  Neighbrsnooks
//
//  Created by Irshad Malik on 16/09/25.
//

 
import Foundation
import UIKit


struct Login_Request: Encodable {
    let user, password : String
}

struct ValidationResponse {
    let message: String?
    let isValid: Bool
}

//MARK: ViewModel_Login
class Login_VM: NSObject {
    func goToLogin(parameter: Parameters, request: Login_Request, completion: @escaping (_ result: LoginApiResponse?) -> Void) {
        let loginUrl = URL(string: API.login)!
        let httpUtility = HttpUtility()
        let loginPostBody = parameter.percentEncoded()
        
        httpUtility.postApiData(
            requestUrl: loginUrl,
            requestBody: loginPostBody!,
            httpMethod: "POST",
            resultType: LoginApiResponse.self
        ) { (loginApiResponse) in
            completion(loginApiResponse)
        }
    }
}

class User_Profile: NSObject {
    func goToUserProfile(parameter: Parameters, request: Login_Request, completion: @escaping (_ result: LoginApiResponse?) -> Void) {
        let profileUrl = URL(string: API.user_Profile)!
        let httpUtility = HttpUtility()
        guard let profilePostBody = parameter.percentEncoded() else {
            completion(nil)
            return
        }
        // ⭐️ Use correct token key here!
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
        print("Profile API token: \(token)") // Debug print
        let headers = ["Authorization": "Bearer \(token)"]
        httpUtility.postApiData(
            requestUrl: profileUrl,
            requestBody: profilePostBody,
            httpMethod: "POST",
            resultType: LoginApiResponse.self,
            headers: headers
        ) { profileApiResponse in
            completion(profileApiResponse)
        }
    }
}



//MARK: - Validations
struct Validation_Service {
    func validate_Login(request: Login_Request) -> ValidationResponse {
        guard !request.user.isEmpty else {
            return ValidationResponse(message: AlertMessages.loginMailEmpty, isValid: false)
        }
        guard request.user.isValidEmail() else {
            return ValidationResponse(message: AlertMessages.loginMailInvalid, isValid: false)
        }
        guard !request.password.isEmpty else {
            return ValidationResponse(message: AlertMessages.loginPasswordEmpty, isValid: false)
        }
        guard request.password.count > 5 else {
            return ValidationResponse(message: AlertMessages.loginPasswordShort, isValid: false)
        }
        guard request.password.count < 16 else {
            return ValidationResponse(message: AlertMessages.loginPasswordLong, isValid: false)
        }
        return ValidationResponse(message: nil, isValid: true)
    }
}

