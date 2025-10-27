//
//  Register_VM.swift
//  Neighbrsnooks
//
//  Created by Irshad Malik on 18/09/25.
//

import Foundation
import UIKit

//MARK: - Register
class Register_VM: NSObject {
    func goToRegister(parameter: Parameters, request: Register_Request, completion: @escaping (_ result: RegisterFirstResponse?) -> Void) {
        let registerUrl = URL(string: API.registerFirst)!   // <- endpoint
        let httpUtility = HttpUtility()
        
        guard let registerPostBody = parameter.percentEncoded() else {
            completion(nil)
            return
        }
        
        httpUtility.postApiData(
            requestUrl: registerUrl,
            requestBody: registerPostBody,
            httpMethod: "POST",
            resultType: RegisterFirstResponse.self
        ) { (registerApiResponse) in
            completion(registerApiResponse)
        }
    }
}

//MARK: - Decrypt
class Decrypt_VM: NSObject {
    func goToDecrypt(encryptedData: String, completion: @escaping (_ result: DecryptResponseData?) -> Void) {
        let decryptUrl = URL(string: API.decrypt)!   
        let httpUtility = HttpUtility()
        
        let param = ["decrypt": encryptedData]
        
        guard let postBody = param.percentEncoded() else {
            completion(nil)
            return
        }
        
        httpUtility.postApiData(
            requestUrl: decryptUrl,
            requestBody: postBody,
            httpMethod: "POST",
            resultType: DecryptResponseData.self
        ) { (decryptApiResponse) in
            completion(decryptApiResponse)
        }
    }
    
    
}

//MARK: - Send OTP
class Otp_VM: NSObject {
    func sendOtp(parameter: Parameters, completion: @escaping (_ result: SendOtpResponse?) -> Void) {
        let otpUrl = URL(string: API.sendOtp)!   
        let httpUtility = HttpUtility()
        
        guard let postBody = parameter.percentEncoded() else {
            completion(nil)
            return
        }
        
        httpUtility.postApiData(
            requestUrl: otpUrl,
            requestBody: postBody,
            httpMethod: "POST",
            resultType: SendOtpResponse.self
        ) { (otpApiResponse) in
            completion(otpApiResponse)
        }
    }
}


//MARK: - Verify OTP
class Otp_Verify_VM:NSObject{
    func verifyOtp(parameter: Parameters, completion: @escaping (_ result: VerifyOtpResponse?) -> Void) {
        let verifyUrl = URL(string: API.verifyOtp)!  // <- endpoint for OTP verification
        let httpUtility = HttpUtility()
        
        guard let postBody = parameter.percentEncoded() else {
            completion(nil)
            return
        }
        
        httpUtility.postApiData(
            requestUrl: verifyUrl,
            requestBody: postBody,
            httpMethod: "POST",
            resultType: VerifyOtpResponse.self
        ) { (verifyApiResponse) in
            completion(verifyApiResponse)
        }
    }
}



//MARK: - Verify Email
class Email_Verify_VM:NSObject{
    func verifyEmail(parameter: Parameters, completion: @escaping (_ result: emailVerifyModel?) -> Void) {
        let verifyUrl = URL(string: API.verifyEmail)!  // <- endpoint for OTP verification
        let httpUtility = HttpUtility()
        guard let postBody = parameter.percentEncoded() else {
            completion(nil)
            return
        }
        httpUtility.postApiData(
            requestUrl: verifyUrl,
            requestBody: postBody,
            httpMethod: "POST",
            resultType: emailVerifyModel.self
        ) { (verifyApiResponse) in
            completion(verifyApiResponse)
        }
    }
}



//MARK: - User Pic Update

class UserPicUpdate: NSObject {
    static let shared = UserPicUpdate()
    
    func UserPicUploadApi(
        parameters: Parameters,
        documents: [String: UIImage],
        completion: @escaping (_ result: userPicUpdateModel?) -> Void)
    {
        let apiUrl = API.UpdateUserpic
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
        let httpUtility = HttpUtility()
        
        var mediaFiles = [String: MediaTypeImageVid]()
        for (key, image) in documents {
            mediaFiles[key] = .image(image)  // Create enum case instance
        }
        
        httpUtility.upload_Reimburse_WithDocuments(
            url: apiUrl,
            parameters: parameters,
            mediaFiles: mediaFiles,
            authToken: "Bearer \(token)",
            httpMethod: "POST",
            resultType: userPicUpdateModel.self
        ) { result in
            completion(result)
        }
    }
}
