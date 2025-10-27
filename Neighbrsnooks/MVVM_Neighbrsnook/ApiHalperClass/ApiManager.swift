//
//  APIManager.swift
//  Vedmir
//
//  Created by Admin on 20/08/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON



let noInternetConnectionMsg = "Connection error."

//Test
let SERVER_API_URL_TEST = "https://beta.neighbrsnook.com/api/"

let appDel = UIApplication.shared.delegate as! AppDelegate
@available(iOS 13.0, *)
let scene = UIApplication.shared.connectedScenes.first
//let sceneDel = (scene?.delegate as? SceneDelegate)
let SCREEN_SIZE: CGRect = UIScreen.main.bounds
let NAVIGATION_BAR_HEIGHT = CGFloat(50)


// MARK: API Manager Delegate

protocol ApiManagerDelegate : class {
    func didFinishCallingApiWithFailer(_ apiName: String)
    func receiveData(_ jsonData: AnyObject?, apiName: String)
}

// A dictionary of parameters to apply to a `URLRequest`.
public typealias Parameters = [String: Any]


class APIManager: NSObject {
    
    weak var delegate: ApiManagerDelegate! = nil
    static let authUsername: String = ""
    static let authPassword: String = ""
    var isPrintApiData : Bool = false
    
    func getMainHeaders() -> HTTPHeaders {
        var mainHeaders: HTTPHeaders
        mainHeaders = [:]
        mainHeaders["Authorization"] = "\(UserDefault.shared.getAccessToken())"
        return mainHeaders
    }
    
    static let sharedInstance: APIManager = {
        let instance = APIManager()
        return instance
    }()
    
    func callAPI(apiModel: API_Model,param: Parameters?,completion completionBlock: ApiResponseHandler? = nil){
        self.executeApi(SERVER_API_URL_TEST+apiModel.newPath, param: param, apiMethod: apiModel.method, forDelegate: nil, userName: APIManager.authUsername, passWord: APIManager.authPassword, isRawData: apiModel.isRawData, completion: completionBlock)
    }
    
    func executeApi(_ apiName: String, param: Parameters?, apiMethod : HTTPMethod = .get, forDelegate: ApiManagerDelegate? = nil, userName : String = authUsername, passWord : String = authPassword, isRawData : Bool = false, completion completionBlock: ApiResponseHandler? = nil){
        delegate = forDelegate
        if Reach().isInternet() == true {
            print("API=>\(apiName)")
            print("Parameter=>\(param)")
            var headers: HTTPHeaders = getMainHeaders()

            var parEncoding: ParameterEncoding = (apiMethod == .get ? URLEncoding.default : URLEncoding.default)  // URLEncoding.httpBody Ye tha phle

            if isRawData == true {
//                parEncoding = JSONEncoding(options: [])         //Manish
                parEncoding = JSONEncoding(options: [.fragmentsAllowed])
                headers["Content-Type"] = "application/json"
            }
            headers["Authorization"] = UserDefault.shared.getAccessToken()

            //For SSL
            var newParam : Parameters!
            newParam = (param != nil) ?  param : [:]
            
            AF.request(apiName, method: apiMethod, parameters: newParam, encoding:parEncoding, headers: headers).responseJSON { (response) in
                switch response.result{
                case .success:
                    do{
                        let json = try JSONSerialization.jsonObject(with: response.data!, options: [])
                        self.responseSend(isSuccess: true, apiStatusCode: response.response?.statusCode, apiName: apiName, resultData: json as AnyObject, param: param, completionBlock: completionBlock)
                    }catch let error{
                        self.failMessageSend(apiName: apiName, completionBlock: completionBlock, errorMsg: error.localizedDescription)
                        print(error.localizedDescription)
                    }
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    
                }
            }
        } else {
            self.failMessageSend(apiName: apiName, completionBlock: completionBlock, errorMsg: WebServiceCallErrorMessage.ErrorInternetConnectionNotAvailableMessage)
        }
    }
    
//    MARK: - upload Image
    func callUploadImageApi(_ apiName: String, photoImage: UIImage?, param: Parameters? = nil, fileName : String = "file", forDelegate: ApiManagerDelegate? = nil, completion completionBlock: ApiResponseHandler? = nil) {
        delegate = forDelegate
        if Reach().isInternet() == true {
            let headers: HTTPHeaders = getMainHeaders()
            AF.upload(multipartFormData: { (multipartFormData) in
                if let param = param {
                    for (key, value) in param {
                        multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                    }
                }
                if let photoImage = photoImage {
                    if let data = photoImage.pngData() {
//                    if let data = photoImage.compress
                        multipartFormData.append(data, withName: fileName, fileName: "profile.png", mimeType: "image/*")
                    }
                }
            },to: apiName, usingThreshold: UInt64.init(),
              method: .post,
              headers: headers).response{ response in
                switch response.result{
                case .success(_):
                    do{
                        if let jsonData = response.data{
                            let json = try JSONSerialization.jsonObject(with: jsonData, options: [])
                            print(apiName,param!,headers)
                            print(json)
                            if let completionBlock = completionBlock {
                                completionBlock(true, JSON.init(json), 200)
                            }
//                        self.delegate.receiveData(response.value as AnyObject, apiName: apiName)
                        }
                    }catch let error{
                        print(error.localizedDescription)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    self.failMessageSend(apiName: apiName, completionBlock: completionBlock, errorMsg : error.localizedDescription)
                }
            }
        } else {
            self.failMessageSend(apiName: apiName, completionBlock: completionBlock)
        }
    }
    
//  MARK: - UploadDocument_Image
    func callUploadImage_DocumentApi(_ apiName: String, doc_Image: Data, param: Parameters? = nil, fileName : String = "file", forDelegate: ApiManagerDelegate? = nil, completion completionBlock: ApiResponseHandler? = nil) {
        delegate = forDelegate
        if Reach().isInternet() == true {
            let headers: HTTPHeaders = getMainHeaders()
            AF.upload(multipartFormData: { (multipartFormData) in
                if let param = param {
                    for (key, value) in param {
                        multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                    }
                }
                multipartFormData.append(doc_Image, withName: fileName, fileName: "profile.png", mimeType: "image/*")
            },to: apiName, usingThreshold: UInt64.init(),
              method: .post,
              headers: headers).response{ response in
                switch response.result{
                case .success(_):
                    do{
                        if let jsonData = response.data{
                            let json = try JSONSerialization.jsonObject(with: jsonData, options: [])
                            print(apiName,param!,headers)
                            print(json)
                            if let completionBlock = completionBlock {
                                completionBlock(true, JSON.init(json), 200)
                            }
                        }
                    }catch let error{
                        print(error.localizedDescription)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    self.failMessageSend(apiName: apiName, completionBlock: completionBlock, errorMsg : error.localizedDescription)
                }
            }
        } else {
            self.failMessageSend(apiName: apiName, completionBlock: completionBlock)
        }
    }
    
    func responseSend(isSuccess : Bool, apiStatusCode : Int?, apiName : String, resultData : AnyObject?, param : Parameters?, completionBlock : ApiResponseHandler?) {
        
        
        var newIsSuccess : Bool = isSuccess
        if apiStatusCode == 200 {
            newIsSuccess = true
        }
        if newIsSuccess == false {
            self.isPrintApiData = true
            print("status code 403")
        }
        
        if apiStatusCode == 403 {
         print("malik code 403")
            newIsSuccess = false
            
        }
        
        
        
        
        
        if apiStatusCode == 401 {  // Unauthorization
            if let completionBlock = completionBlock {
                let isValid : Bool = false
                if let stringDict = resultData as? Parameters {
                    if let isValidValue = stringDict["status "] {
                        print("irshad malik status code 403")

                    }
                }
                if let resultData = resultData {
                    completionBlock(isValid, JSON.init(resultData), apiStatusCode)
                } else {
                    completionBlock(isValid, JSON.init([:]), apiStatusCode)
                }
            }
            guard newIsSuccess else {
                self.delegate?.didFinishCallingApiWithFailer(apiName)
                return
            }
            self.delegate?.receiveData(resultData!, apiName: apiName)
        }else {
            if let completionBlock = completionBlock {
                let isValid : Bool = false
                if let stringDict = resultData as? Parameters {
                    if let isValidValue = stringDict["status"] {
                        //                    isValid = isValidValue as! Bool
                    }
                }
                if let resultData = resultData {
                    completionBlock(isValid, JSON.init(resultData), apiStatusCode)
                } else {
                    completionBlock(isValid, JSON.init([:]), apiStatusCode)
                }
            }
            guard newIsSuccess else {
                self.delegate?.didFinishCallingApiWithFailer(apiName)
                return
            }
            self.delegate?.receiveData(resultData!, apiName: apiName)
        }
    }
    
    func failMessageSend(apiName : String, completionBlock : ApiResponseHandler?, errorMsg : String = noInternetConnectionMsg) {
//        errorMsg.showAsAlert()
        self.delegate?.didFinishCallingApiWithFailer(apiName)
        if let completionBlock = completionBlock {
            completionBlock(false, JSON.init(["message":errorMsg]), nil)
        }
    }
    
    func printText(_ text : Any) {
        if isPrintApiData {
            print(text)
        }
    }
    
}

