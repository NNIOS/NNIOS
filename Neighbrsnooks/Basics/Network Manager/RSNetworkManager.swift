import Foundation
import Alamofire
import AlamofireImage
import SVProgressHUD

public enum kHTTPMethod: String {
  
  case GET, POST, PUT, PATCH, DELETE
}

public enum ErrorType: Error {
  
  case noNetwork, requestSuccess, requestFailed, requestCancelled
}

public class RSNetworkManager {
  
  // MARK: - Properties
  
  /**
   A shared instance of `Manager`, used by top-level Alamofire request methods, and suitable for use directly
   for any ad hoc requests.
   */
  internal static let shared: RSNetworkManager = {
    return RSNetworkManager()
  }()
  
  //MARK:- Public Method
  /**
   *  Initiates HTTPS or HTTP request over |kHTTPMethod| method and returns call back in success and failure block.
   *
   *  @param serviceName  name of the s.,ervice
   *  @param method       method type like Get and Post
   *  @param postData     parameters
   *  @param responeBlock call back in block
   */
    
    func newRequestApi(withServiceName serviceName: String, requestMethod method: kHTTPMethod, requestParameters dictParams: Dictionary<String, Any>, withProgressHUD showProgress: Bool, completionClosure:@escaping (_ result: Data?, _ error: Error?, _ errorType: ErrorType, _ statusCode: HTTPStatusCodeConstants) -> ()) -> Void {
          
          if NetworkReachabilityManager()?.isReachable == true {
            
    //        if showProgress {
    //          showProgressHUD()
    //        }
            
            let headers = getHeader()
            let serviceUrl = getServiceUrl(string: serviceName)
            let params  = getPrintableParamsFromJson(postData: dictParams)
            
            print("Header: \(headers)")
            print("Connecting to Host with URL \(kBASEURL)\(serviceName) with parameters: \(params)")
            
            //NSAssert Statements
            assert(method != .GET || method != .POST, "kHTTPMethod should be one of kHTTPMethodGET|kHTTPMethodPOST|kHTTPMethodPOSTMultiPart.");
            
            switch method
            {
            case .GET:
              Alamofire.Session.default.request(serviceUrl, method: .get, parameters: dictParams, encoding: URLEncoding.default, headers: headers).responseJSON(completionHandler:
                { (DataResponse) in
                //  SVProgressHUD.dismiss()
                  switch DataResponse.result
                  {
                  case .success(let JSON):
                    print( "Success with JSON: \(JSON)")
                    
                    print( "Success with status Code: \(String(describing: DataResponse.response?.statusCode))")
                  //  let response = self.getResponseDataDictionaryFromData(data: DataResponse.data!)
                    completionClosure(DataResponse.data!, DataResponse.error, .requestSuccess, self.getHTTPStatusCode(DataResponse.response?.statusCode))
                  case .failure(let error):
                    print( "json error: \(error.localizedDescription)")
                    completionClosure(nil, error, .requestFailed, self.getHTTPStatusCode(DataResponse.response?.statusCode))
                  }
              })
            case .POST:
              Alamofire.Session.default.request(serviceUrl, method: .post, parameters: dictParams, encoding: URLEncoding.default, headers: headers).responseJSON(completionHandler:
                { (DataResponse) in
                //  SVProgressHUD.dismiss()
                  switch DataResponse.result
                  {
                  case .success(let JSON):
                    print( "Success with JSON: \(JSON)")
                    print( "Success with status Code: \(String(describing: DataResponse.response?.statusCode))")
                    let response = self.getResponseDataDictionaryFromData(data: DataResponse.data!)
                    completionClosure(DataResponse.data!, response.error, .requestSuccess, self.getHTTPStatusCode(DataResponse.response?.statusCode))
                  case .failure(let error):
                    print( "json error: \(error.localizedDescription)")
                    completionClosure(nil, error, .requestFailed, self.getHTTPStatusCode(DataResponse.response?.statusCode))
                  }
              })
            case .PUT:
              Alamofire.Session.default.request(serviceUrl, method: .put, parameters: dictParams, encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler:
                { (DataResponse) in
                  SVProgressHUD.dismiss()
                  switch DataResponse.result
                  {
                  case .success(let JSON):
                    print( "Success with JSON: \(JSON)")
                    print( "Success with status Code: \(String(describing: DataResponse.response?.statusCode))")
                    let response = self.getResponseDataDictionaryFromData(data: DataResponse.data!)
                    completionClosure(DataResponse.data!, response.error, .requestSuccess, self.getHTTPStatusCode(DataResponse.response?.statusCode))
                  case .failure(let error):
                    print( "json error: \(error.localizedDescription)")
                    completionClosure(nil, error, .requestFailed, self.getHTTPStatusCode(DataResponse.response?.statusCode))
                  }
              })
            case .PATCH:
              Alamofire.Session.default.request(serviceUrl, method: .patch, parameters: dictParams, encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler:
                { (DataResponse) in
                  SVProgressHUD.dismiss()
                  switch DataResponse.result
                  {
                  case .success(let JSON):
                    print( "Success with JSON: \(JSON)")
                    print( "Success with status Code: \(String(describing: DataResponse.response?.statusCode))")
                    let response = self.getResponseDataDictionaryFromData(data: DataResponse.data!)
                    completionClosure(DataResponse.data!, response.error, .requestSuccess, self.getHTTPStatusCode(DataResponse.response?.statusCode))
                  case .failure(let error):
                    print( "json error: \(error.localizedDescription)")
                    completionClosure(nil, error, .requestFailed, self.getHTTPStatusCode(DataResponse.response?.statusCode))
                  }
              })
            case .DELETE:
              Alamofire.Session.default.request(serviceUrl, method: .delete, parameters: dictParams, encoding: URLEncoding.default, headers: headers).responseJSON(completionHandler:
                { (DataResponse) in
                  SVProgressHUD.dismiss()
                  switch DataResponse.result
                  {
                  case .success(let JSON):
                    print( "Success with JSON: \(JSON)")
                    print( "Success with status Code: \(String(describing: DataResponse.response?.statusCode))")
                    let response = self.getResponseDataDictionaryFromData(data: DataResponse.data!)
                    completionClosure(DataResponse.data!, response.error, .requestSuccess, self.getHTTPStatusCode(DataResponse.response?.statusCode))
                  case .failure(let error):
                    print( "json error: \(error.localizedDescription)")
                    completionClosure(nil, error, .requestFailed, self.getHTTPStatusCode(DataResponse.response?.statusCode))
                  }
              })
            }
          }
          else
          {
            SVProgressHUD.dismiss()
            completionClosure(nil, nil, .noNetwork, .NO_RESPONSE)
          }
        }
    
    func newMarketRequestApi(withServiceName serviceName: String, requestMethod method: kHTTPMethod, requestParameters dictParams: Dictionary<String, Any>, withProgressHUD showProgress: Bool, completionClosure:@escaping (_ result: Data?, _ error: Error?, _ errorType: ErrorType, _ statusCode: HTTPStatusCodeConstants) -> ()) -> Void {
      
      if NetworkReachabilityManager()?.isReachable == true {
        
//        if showProgress {
//          showProgressHUD()
//        }
        
        let headers = getHeader()
        let serviceUrl = getServiceUrl(string: serviceName)
        let params  = getPrintableParamsFromJson(postData: dictParams)
        
        print("Header: \(headers)")
        print("Connecting to Host with URL \(kMBASEURL)\(serviceName) with parameters: \(params)")
        
        //NSAssert Statements
        assert(method != .GET || method != .POST, "kHTTPMethod should be one of kHTTPMethodGET|kHTTPMethodPOST|kHTTPMethodPOSTMultiPart.");
        
        switch method
        {
        case .GET:
          Alamofire.Session.default.request(serviceUrl, method: .get, parameters: dictParams, encoding: URLEncoding.default, headers: headers).responseJSON(completionHandler:
            { (DataResponse) in
            //  SVProgressHUD.dismiss()
              switch DataResponse.result
              {
              case .success(let JSON):
                print( "Success with JSON: \(JSON)")
                
                print( "Success with status Code: \(String(describing: DataResponse.response?.statusCode))")
              //  let response = self.getResponseDataDictionaryFromData(data: DataResponse.data!)
                completionClosure(DataResponse.data!, DataResponse.error, .requestSuccess, self.getHTTPStatusCode(DataResponse.response?.statusCode))
              case .failure(let error):
                print( "json error: \(error.localizedDescription)")
                completionClosure(nil, error, .requestFailed, self.getHTTPStatusCode(DataResponse.response?.statusCode))
              }
          })
        case .POST:
          Alamofire.Session.default.request(serviceUrl, method: .post, parameters: dictParams, encoding: URLEncoding.default, headers: headers).responseJSON(completionHandler:
            { (DataResponse) in
            //  SVProgressHUD.dismiss()
              switch DataResponse.result
              {
              case .success(let JSON):
                print( "Success with JSON: \(JSON)")
                print( "Success with status Code: \(String(describing: DataResponse.response?.statusCode))")
                let response = self.getResponseDataDictionaryFromData(data: DataResponse.data!)
                completionClosure(DataResponse.data!, response.error, .requestSuccess, self.getHTTPStatusCode(DataResponse.response?.statusCode))
              case .failure(let error):
                print( "json error: \(error.localizedDescription)")
                completionClosure(nil, error, .requestFailed, self.getHTTPStatusCode(DataResponse.response?.statusCode))
              }
          })
        case .PUT:
          Alamofire.Session.default.request(serviceUrl, method: .put, parameters: dictParams, encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler:
            { (DataResponse) in
              SVProgressHUD.dismiss()
              switch DataResponse.result
              {
              case .success(let JSON):
                print( "Success with JSON: \(JSON)")
                print( "Success with status Code: \(String(describing: DataResponse.response?.statusCode))")
                let response = self.getResponseDataDictionaryFromData(data: DataResponse.data!)
                completionClosure(DataResponse.data!, response.error, .requestSuccess, self.getHTTPStatusCode(DataResponse.response?.statusCode))
              case .failure(let error):
                print( "json error: \(error.localizedDescription)")
                completionClosure(nil, error, .requestFailed, self.getHTTPStatusCode(DataResponse.response?.statusCode))
              }
          })
        case .PATCH:
          Alamofire.Session.default.request(serviceUrl, method: .patch, parameters: dictParams, encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler:
            { (DataResponse) in
              SVProgressHUD.dismiss()
              switch DataResponse.result
              {
              case .success(let JSON):
                print( "Success with JSON: \(JSON)")
                print( "Success with status Code: \(String(describing: DataResponse.response?.statusCode))")
                let response = self.getResponseDataDictionaryFromData(data: DataResponse.data!)
                completionClosure(DataResponse.data!, response.error, .requestSuccess, self.getHTTPStatusCode(DataResponse.response?.statusCode))
              case .failure(let error):
                print( "json error: \(error.localizedDescription)")
                completionClosure(nil, error, .requestFailed, self.getHTTPStatusCode(DataResponse.response?.statusCode))
              }
          })
        case .DELETE:
          Alamofire.Session.default.request(serviceUrl, method: .delete, parameters: dictParams, encoding: URLEncoding.default, headers: headers).responseJSON(completionHandler:
            { (DataResponse) in
              SVProgressHUD.dismiss()
              switch DataResponse.result
              {
              case .success(let JSON):
                print( "Success with JSON: \(JSON)")
                print( "Success with status Code: \(String(describing: DataResponse.response?.statusCode))")
                let response = self.getResponseDataDictionaryFromData(data: DataResponse.data!)
                completionClosure(DataResponse.data!, response.error, .requestSuccess, self.getHTTPStatusCode(DataResponse.response?.statusCode))
              case .failure(let error):
                print( "json error: \(error.localizedDescription)")
                completionClosure(nil, error, .requestFailed, self.getHTTPStatusCode(DataResponse.response?.statusCode))
              }
          })
        }
      }
      else
      {
        SVProgressHUD.dismiss()
        completionClosure(nil, nil, .noNetwork, .NO_RESPONSE)
      }
    }
  
//    (withServiceName serviceName: String, requestMethod method: kHTTPMethod, requestParameters dictParams: Dictionary<String, Any>, withProgressHUD showProgress: Bool, completionClosure:@escaping (_ result: Data?, _ error: Error?, _ errorType: ErrorType, _ statusCode: HTTPStatusCodeConstants) -> ())
    
  func requestMultipartApi(with serviceName: String, withRequestType requestType: HTTPMethod, withImage image: UIImage?, withImageName imageName: String,profileImage image2: UIImage?, profileImageName imageName2: String, postData dictParams: Dictionary<String, Any>, completionClosure: @escaping (_ result: Data?, _ error: Error?, _ errorType: ErrorType, _ statusCode: HTTPStatusCodeConstants) -> ()) -> Void {
    
    if NetworkReachabilityManager()?.isReachable == true {
      
   //   showProgressHUD()
      let headers = getHeader()
      let serviceUrl = getServiceUrl(string: serviceName)
      let params  = getPrintableParamsFromJson(postData: dictParams)
      
      print("Connecting to Host with URL \(kBASEURL)\(serviceName) with parameters: \(params)")
      
      Alamofire.Session.default.upload(multipartFormData:{ (multipartFormData: MultipartFormData) in
        
        for (key, value) in dictParams {
          if let requestData = String.getString(value).data(using: .utf8) {
            multipartFormData.append(requestData, withName: key)
          }
        }
        if let imageToUpload = image {
          if let imageData: Data = imageToUpload.jpegData(compressionQuality: 0.5) {
            multipartFormData.append(imageData, withName: imageName, fileName: "\(self.getCurrentTimeAsPathName())", mimeType: "image/jpeg")
          }
        }
          
          if let imageToUpload2 = image2 {
            if let imageData2: Data = imageToUpload2.jpegData(compressionQuality: 0.5) {
              multipartFormData.append(imageData2, withName: imageName2, fileName: "\(self.getCurrentTimeAsPathName())", mimeType: "image/jpeg")
            }
          }
      }, to: serviceUrl, method: requestType, headers: headers).responseJSON { (dataResponse: AFDataResponse<Any>) in
        
        switch dataResponse.result
        {
        case .success:
     //     SVProgressHUD.dismiss()
          let response = self.getResponseDataDictionaryFromData(data: dataResponse.data!)
            completionClosure(dataResponse.data, response.error, .requestSuccess, self.getHTTPStatusCode(dataResponse.response?.statusCode))
        case .failure(let error):
    //      SVProgressHUD.dismiss()
          completionClosure(nil, error, .requestFailed, self.getHTTPStatusCode(400))
        }
      }
    }
    else
    {
      SVProgressHUD.dismiss()
      completionClosure(nil, nil, .noNetwork, .NO_RESPONSE)
    }
  }
    
    
    
  func requestMultipartApi2(with serviceName: String, withRequestType requestType: HTTPMethod, withImage image: UIImage?, withImageName imageName: String, postData dictParams: Dictionary<String, Any>, completionClosure: @escaping (_ result: Data?, _ error: Error?, _ errorType: ErrorType, _ statusCode: HTTPStatusCodeConstants) -> ()) -> Void {
    
    if NetworkReachabilityManager()?.isReachable == true {
      
   //   showProgressHUD()
      let headers = getHeader()
      let serviceUrl = getServiceUrl(string: serviceName)
      let params  = getPrintableParamsFromJson(postData: dictParams)
      
      print("Connecting to Host with URL \(kBASEURL)\(serviceName) with parameters: \(params)")
      
      Alamofire.Session.default.upload(multipartFormData:{ (multipartFormData: MultipartFormData) in
        
        for (key, value) in dictParams {
          if let requestData = String.getString(value).data(using: .utf8) {
            multipartFormData.append(requestData, withName: key)
          }
        }
        if let imageToUpload = image {
          if let imageData: Data = imageToUpload.jpegData(compressionQuality: 0.5) {
            multipartFormData.append(imageData, withName: imageName, fileName: "\(self.getCurrentTimeAsPathName())", mimeType: "image/jpeg")
          }
        }
          
      }, to: serviceUrl, method: requestType, headers: headers).responseJSON { (dataResponse: AFDataResponse<Any>) in
        
        switch dataResponse.result
        {
        case .success:
     //     SVProgressHUD.dismiss()
          let response = self.getResponseDataDictionaryFromData(data: dataResponse.data!)
            completionClosure(dataResponse.data, response.error, .requestSuccess, self.getHTTPStatusCode(dataResponse.response?.statusCode))
        case .failure(let error):
    //      SVProgressHUD.dismiss()
          completionClosure(nil, error, .requestFailed, self.getHTTPStatusCode(400))
        }
      }
    }
    else
    {
      SVProgressHUD.dismiss()
      completionClosure(nil, nil, .noNetwork, .NO_RESPONSE)
    }
  }
    
    func requestMultipartAudioApi(with serviceName: String, withRequestType requestType: HTTPMethod, withUrl url: URL?, withImageName imageName: String, postData dictParams: Dictionary<String, Any>, completionClosure: @escaping (_ result: Any?, _ error: Error?, _ errorType: ErrorType, _ statusCode: HTTPStatusCodeConstants) -> ()) -> Void {
      
      if NetworkReachabilityManager()?.isReachable == true {
        
        showProgressHUD()
        let headers = getHeader()
        let serviceUrl = getServiceUrl(string: serviceName)
        let params  = getPrintableParamsFromJson(postData: dictParams)
        
        print("Connecting to Host with URL \(kBASEURL)\(serviceName) with parameters: \(params)")
        
        Alamofire.Session.default.upload(multipartFormData:{ (multipartFormData: MultipartFormData) in
          
          for (key, value) in dictParams {
            if let requestData = String.getString(value).data(using: .utf8) {
              multipartFormData.append(requestData, withName: key)
            }
          }
          if let audioToUpload = url {
      //      if let imageData: Data = imageToUpload.jpegData(compressionQuality: 0.5) {
    //          multipartFormData.append(imageData, withName: imageName, fileName: "\(String.getString(FunctionsConstants.kSharedUserDefaults.loggedInUserModel.id))_\(self.getCurrentTimeAsPathName())", mimeType: "audio/m4a")
              
     //         multipartFormData.append(url as Data, withName: "audio", fileName: "Audio", mimeType: "audio/m4a")

  //          }
          }
        }, to: serviceUrl, method: requestType, headers: headers).responseJSON { (dataResponse: AFDataResponse<Any>) in
          
          switch dataResponse.result
          {
          case .success:
            SVProgressHUD.dismiss()
            let response = self.getResponseDataDictionaryFromData(data: dataResponse.data!)
            completionClosure(response.responseData, response.error, .requestSuccess, self.getHTTPStatusCode(dataResponse.response?.statusCode))
          case .failure(let error):
            SVProgressHUD.dismiss()
            completionClosure(nil, error, .requestFailed, self.getHTTPStatusCode(400))
          }
        }
      }
      else
      {
        SVProgressHUD.dismiss()
        completionClosure(nil, nil, .noNetwork, .NO_RESPONSE)
      }
    }
  
  func cancelAllRequests(completionHandler: @escaping () -> ()) {
    
    let sessionManager = Alamofire.Session.default
    sessionManager.session.getTasksWithCompletionHandler { (dataTask: [URLSessionDataTask], uploadTask: [URLSessionUploadTask], downloadTask: [URLSessionDownloadTask]) in
      dataTask.forEach({ (task: URLSessionDataTask) in task.cancel() })
      uploadTask.forEach({ (task: URLSessionUploadTask) in task.cancel() })
      downloadTask.forEach({ (task: URLSessionDownloadTask) in task.cancel() })
      completionHandler()
    }
  }
  
  func downloadImage(forUrl strUrl: String, completionClosure:@escaping (_ image: UIImage?) -> ()) -> Void {
    
    Alamofire.Session.default.request(strUrl).responseImage { response in
      
      do {
        let image = try response.result.get()
        completionClosure(image)
      } catch {
      }
      completionClosure(nil)
    }
  }
  
  func getCurrentTimeAsPathName() -> String {
    
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd_HHmmss"
    return formatter.string(from: Date())
  }
  
  //MARK:- Private Method
  private func showProgressHUD() {
    
    SVProgressHUD.setDefaultMaskType(.none)
    SVProgressHUD.setDefaultStyle(.custom)
    SVProgressHUD.setForegroundColor(UIColor.black)
    SVProgressHUD.setBackgroundColor(UIColor.clear)
    SVProgressHUD.show()
  }
  
  private func getHTTPStatusCode(_ value: Any?) -> HTTPStatusCodeConstants {
    
    let statusCode = Int.getInt(value)
    switch statusCode {
    case 200:
      return .SUCCESS
    case 201:
      return .CREATED
    case 202:
      return .ACCEPTED
    case 204:
      return .NO_CONTENT
    case 400:
      return .BAD_REQUEST
    case 401:
      return .UNAUTHORIZED
    case 403:
      return .FORBIDDEN
    case 404:
      return .NOT_FOUND
    case 405:
      return .METHOD_NOT_ALLOWED
    case 409:
      return .CONFLICT
    case 422:
      return .USER_EXISTS
    default:
      return .NO_RESPONSE
    }
  }
  
    private func getHeader() -> HTTPHeaders {
        let token : String? = UserDefaults.standard.object(forKey: "accessToken") as? String
        var headers: HTTPHeaders = []
    //    headers.add(HTTPHeader.init(name: "accept", value: "application/json"))
    //    headers.add(HTTPHeader.init(name: "Content-Type", value: "application/json"))
    //    headers.add(HTTPHeader.init(name: "language", value: "en"))
          headers.add(HTTPHeader.init(name: "Authorization", value: "\("Bearer") \(token ?? "")"))
    //    if FunctionsConstants.kSharedUserDefaults.isUserLoggedIn {
    //      headers.add(HTTPHeader.init(name: KeyConstants.kAccessToken, value: FunctionsConstants.kSharedUserDefaults.loggedInUserModel.accessToken))
    //    }
        return headers
      }
  
  private func getServiceUrl(string: String) -> String {
    
    if string.contains("http") {
      
      return string
    }
    else {
      
      return kBASEURL + string
    }
  }
  
  private func getPrintableParamsFromJson(postData: Dictionary<String, Any>) -> String  {
    do {
      
      let jsonData = try JSONSerialization.data(withJSONObject: postData, options:JSONSerialization.WritingOptions.prettyPrinted)
      let theJSONText = String(data:jsonData, encoding:String.Encoding.ascii)
      return theJSONText ?? ""
    }
    catch let error as NSError {
      
      print( error)
      return ""
    }
  }
  
  private func getResponseDataArrayFromData(data: Data) -> (responseData: [Any]?, error: NSError?) {
    do {
    let responseData = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [Any]
      print("Success with JSON: \(responseData ?? [])")
      return (responseData, nil)
    }
    catch let error as NSError {
      
      print( "json error: \(error.localizedDescription)")
      return (nil, error)
    }
  }
  
  private func getResponseDataDictionaryFromData(data: Data) -> (responseData: Dictionary<String, Any>, error: Error?) {
    do {
      let responseData = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! Dictionary<String, Any>
      print("Success with JSON: \(responseData)")
      return (responseData, nil)
    }
    catch let error {
      print( "json error: \(error.localizedDescription)")
      return ([:], error)
    }
  }
  
  private func printResponseDataForResponse(response: DataResponse<Any, Error>) {
    print_debug(response.request ?? "")  // original URL request
    print_debug(response.response ?? "") // URL response
    print_debug(response.data ?? "")     // server data
    print_debug(response.result)   // result of response serialization
  }
  
  private func getCurrentTimeStamp()-> TimeInterval {
    return NSDate().timeIntervalSince1970.rounded()
  }
    
    
    
}
