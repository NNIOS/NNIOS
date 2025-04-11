import Foundation
import UIKit
//import SideMenuSwift
import Alamofire

@available(iOS 16.0, *)
class WebService {

  static let sharedInstance = WebService()

    func callLoginWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: LoginModel) -> ()) {
          RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kLogin, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
          {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            let dictResponse = FunctionsConstants.kShared.getDictionary(result)
            switch statusCode {
            case .SUCCESS:
              do {
                let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                  FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                let data = try JSONDecoder().decode(LoginModel.self, from: result!)
                completionClosure(data)
              } catch {
                print(error.localizedDescription)
              }
            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
              print("")
              self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
            case .UNAUTHORIZED:
                print(error)
           //   self.showLogoutAlert()
            default:
              break
            }
          }
    }
    
    
    func callOTPWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: OtpModel) -> ()) {
          RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kOtp, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
          {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            let dictResponse = FunctionsConstants.kShared.getDictionary(result)
            switch statusCode {
            case .SUCCESS:
              do {
                let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                  FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                let data = try JSONDecoder().decode(OtpModel.self, from: result!)
                completionClosure(data)
              } catch {
                print(error.localizedDescription)
              }

            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
              print("")
              self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
            case .UNAUTHORIZED:
                print(error)
           //   self.showLogoutAlert()
            default:
              break
            }
          }
    }
    
    
    func callForgetOTPWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: ForgetOTPModel) -> ()) {
          RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kForgetOtp, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
          {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            let dictResponse = FunctionsConstants.kShared.getDictionary(result)
            switch statusCode {
            case .SUCCESS:
              do {
                let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                  FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                let data = try JSONDecoder().decode(ForgetOTPModel.self, from: result!)
                completionClosure(data)
              } catch {
                print(error.localizedDescription)
              }

            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
              print("")
              self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
            case .UNAUTHORIZED:
                print(error)
           //   self.showLogoutAlert()
            default:
              break
            }
          }
    }
    
    func callRegisterWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: RegisterModel) -> ()) {
          RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kRegister, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
          {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            let dictResponse = FunctionsConstants.kShared.getDictionary(result)
            switch statusCode {
            case .SUCCESS:
              do {
                let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                  FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                let data = try JSONDecoder().decode(RegisterModel.self, from: result!)
                completionClosure(data)
              } catch {
                print(error.localizedDescription)
              }

            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
              print("")
              self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
            case .UNAUTHORIZED:
                print(error)
           //   self.showLogoutAlert()
            default:
              break
            }
          }
    }
    
    
    func callVerifyOTPWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: MatchOTPModel) -> ()) {
          RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kVerifyOTP, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
          {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            let dictResponse = FunctionsConstants.kShared.getDictionary(result)
            switch statusCode {
            case .SUCCESS:
              do {
                let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                  FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)
 
                  let data = try JSONDecoder().decode(MatchOTPModel.self, from: result!)
                 
                  
                completionClosure(data)
              } catch {
                print(error.localizedDescription)
              }

            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
              print("")
              self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
            case .UNAUTHORIZED:
                print(error)
           //   self.showLogoutAlert()
            default:
              break
            }
          }
    }
    
    func CallProffesoinWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: ProffessionModel) -> ()) {
          RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kProffesion, requestMethod: .GET, requestParameters: dictParams, withProgressHUD: true)
          {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            let dictResponse = FunctionsConstants.kShared.getDictionary(result)
            switch statusCode {
            case .SUCCESS:
              do {
                let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])

                let data = try JSONDecoder().decode(ProffessionModel.self, from: result!)
                completionClosure(data)
              } catch {
                print(error.localizedDescription)
              }

            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
              print("")
              self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
            case .UNAUTHORIZED:
                print(error)
           //   self.showLogoutAlert()
            default:
              break
            }
          }
    }
    
    func CallIntrestWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: IntrestModel) -> ()) {
          RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kintrset, requestMethod: .GET, requestParameters: dictParams, withProgressHUD: true)
          {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            let dictResponse = FunctionsConstants.kShared.getDictionary(result)
            switch statusCode {
            case .SUCCESS:
              do {
                let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])

                let data = try JSONDecoder().decode(IntrestModel.self, from: result!)
                completionClosure(data)
              } catch {
                print(error.localizedDescription)
              }

            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
              print("")
              self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
            case .UNAUTHORIZED:
                print(error)
           //   self.showLogoutAlert()
            default:
              break
            }
          }
    }
    
    func CallNeighbourWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: NeighbourModel) -> ()) {
          RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kReason, requestMethod: .GET, requestParameters: dictParams, withProgressHUD: true)
          {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            let dictResponse = FunctionsConstants.kShared.getDictionary(result)
            switch statusCode {
            case .SUCCESS:
              do {
                let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])

                let data = try JSONDecoder().decode(NeighbourModel.self, from: result!)
                completionClosure(data)
              } catch {
                print(error.localizedDescription)
              }

            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
              print("")
              self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
            case .UNAUTHORIZED:
                print(error)
           //   self.showLogoutAlert()
            default:
              break
            }
          }
    }
    
//   CallReachoutWebService     *******************
    func CallReachoutWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ reachoutModel: ReachoutNeighborhoodModel) -> ()) {
        RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kReachout, requestMethod: .GET, requestParameters: dictParams, withProgressHUD: true)
        { (result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            let dictResponse = FunctionsConstants.kShared.getDictionary(result)
            switch statusCode {
            case .SUCCESS:
                do {
                    // Decoding the response to ReachoutNeighborhoodModel
                    let data = try JSONDecoder().decode(ReachoutNeighborhoodModel.self, from: result!)
                    completionClosure(data) // Return the decoded data
                } catch {
                    print(error.localizedDescription)
                }
            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
                print("")
                self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
            case .UNAUTHORIZED:
                print(error)
            default:
                break
            }
        }
    }
    
    
    
    
    
//    
//    func callMoreYouWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: RegisterFirstModel) -> ()) {
//        RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kMoreYou, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true) { (result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
//            
//            // Safely unwrap the result first
//            guard let result = result else {
//                print("Error: result is nil")
//                self.showAlert(withMessage: "Failed to receive data from the server.")
//                return
//            }
//            
//            // Try to convert result to dictionary safely
//            let dictResponse = FunctionsConstants.kShared.getDictionary(result)
//            
//            switch statusCode {
//            case .SUCCESS:
//                do {
//                    if let dictData = dictResponse[KeyConstants.kData] as? [String: Any] {
//                        let dictResult = FunctionsConstants.kShared.getDictionary(dictData)
//                        FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)
//                        
//                        // Try decoding the response
//                        let data = try JSONDecoder().decode(RegisterFirstModel.self, from: result)
//                        completionClosure(data)
//                    } else {
//                        print("Error: Could not find data key in the response.")
//                        self.showAlert(withMessage: "Invalid response from the server.")
//                    }
//                } catch {
//                    print("Decoding error: \(error.localizedDescription)")
//                    self.showAlert(withMessage: "Failed to decode server response.")
//                }
//            
//            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
//                print("Error: \(FunctionsConstants.kShared.getErrorMessage(dictResponse))")
//                self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
//            
//            case .UNAUTHORIZED:
//                print("Unauthorized access")
//                // self.showLogoutAlert()
//            
//            default:
//                print("Unhandled error type: \(errorType)")
//                break
//            }
//        }
//    }

    
    
    func callMoreYouWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: Welcome) -> ()) {
          RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kMoreYou, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
          {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            let dictResponse = FunctionsConstants.kShared.getDictionary(result)
            switch statusCode {
            case .SUCCESS:
              do {
                let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                  FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                let data = try JSONDecoder().decode(Welcome.self, from: result!)
                completionClosure(data)
              } catch {
                print(error.localizedDescription)
              }

            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
              print("")
              self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
            case .UNAUTHORIZED:
                print(error)
           //   self.showLogoutAlert()
            default:
              break
            }
          }
    }
    
  //     RegSec call api
    
    func callRegSecWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: RegistrationSecModel) -> ()) {
          RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kRegSec, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
          {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            let dictResponse = FunctionsConstants.kShared.getDictionary(result)
            switch statusCode {
            case .SUCCESS:
              do {
                let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                  FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                let data = try JSONDecoder().decode(RegistrationSecModel.self, from: result!)
                completionClosure(data)
              } catch {
                print(error.localizedDescription)
              }

            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
              print("")
              self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
            case .UNAUTHORIZED:
                print(error)
           //   self.showLogoutAlert()
            default:
              break
            }
          }
    }
    
    
    
    func callCountryWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: CountryModel) -> ()) {
          RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kCountry, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
          {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            let dictResponse = FunctionsConstants.kShared.getDictionary(result)
            switch statusCode {
            case .SUCCESS:
              do {
                let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                  FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                let data = try JSONDecoder().decode(CountryModel.self, from: result!)
                completionClosure(data)
              } catch {
                print(error.localizedDescription)
              }

            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
              print("")
              self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
            case .UNAUTHORIZED:
                print(error)
           //   self.showLogoutAlert()
            default:
              break
            }
          }
    }
    
    
    
    
    
    
    
    func callStateWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: StateModel) -> ()) {
        RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kstate, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
        { (result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            
            let dictResponse = FunctionsConstants.kShared.getDictionary(result)
            
            switch statusCode {
            case .SUCCESS:
                // Safely unwrap result
                guard let result = result else {
                    print("Result is nil")
                    return
                }
                
                do {
                    let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                    FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)
                    
                    let data = try JSONDecoder().decode(StateModel.self, from: result)
                    completionClosure(data)
                } catch {
                    print("Decoding error: \(error.localizedDescription)")
                }
                
            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
                print("Error message: \(FunctionsConstants.kShared.getErrorMessage(dictResponse))")
                self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
                
            case .UNAUTHORIZED:
                print("Unauthorized error: \(error?.localizedDescription ?? "Unknown error")")
                // self.showLogoutAlert() // Uncomment if logout is needed
                
            default:
                print("Unhandled status code: \(statusCode)")
            }
        }
    }

    
    func callCityWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: cityModel) -> ()) {
        RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kCity, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
        { (result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            
            // Safely unwrap result
            guard let result = result else {
                print("Result is nil")
                return
            }

            // Check status code
            let dictResponse = FunctionsConstants.kShared.getDictionary(result)
            switch statusCode {
            case .SUCCESS:
                do {
                    // Decode the response
                    let data = try JSONDecoder().decode(cityModel.self, from: result)
                    completionClosure(data)
                } catch {
                    print("Decoding error: \(error.localizedDescription)")
                }

            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
                print("Error message: \(FunctionsConstants.kShared.getErrorMessage(dictResponse))")
                self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))

            case .UNAUTHORIZED:
                print("Unauthorized error: \(error?.localizedDescription ?? "Unknown error")")
                // Uncomment if logout is needed
                // self.showLogoutAlert()

            default:
                print("Unhandled status code: \(statusCode)")
            }
        }
    }

    
    func callSearchNeighbrWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: NgbbrhoodModel) -> ()) {
          RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kSearchNeighbr, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
          {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            let dictResponse = FunctionsConstants.kShared.getDictionary(result)
            switch statusCode {
            case .SUCCESS:
              do {
                let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                  FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                let data = try JSONDecoder().decode(NgbbrhoodModel.self, from: result!)
                completionClosure(data)
              } catch {
                print(error.localizedDescription)
              }

            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
              print("")
              self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
            case .UNAUTHORIZED:
                print(error)
           //   self.showLogoutAlert()
            default:
              break
            }
          }
    }
  
    
    
//    --------------------- Neighborhood Status By State/City/Pincode ------------------------------------/
    
    
    func callNeighborhoodStatusByState(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: NeighborhoodStatusByStateModel) -> ()) {
          RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kNeighborhoodStatusByState, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
          {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            let dictResponse = FunctionsConstants.kShared.getDictionary(result)
            switch statusCode {
            case .SUCCESS:
              do {
                let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                  FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                let data = try JSONDecoder().decode(NeighborhoodStatusByStateModel.self, from: result!)
                completionClosure(data)
              } catch {
                print(error.localizedDescription)
              }

            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
              print("")
              self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
            case .UNAUTHORIZED:
                print(error)
           //   self.showLogoutAlert()
            default:
              break
            }
          }
    }
    
    
    
    
    
    
    
    
    
    
    
//   **************************------------ post api Device Info --------------------************************************
    
    func callDeviceInfo(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: DeviceInfoModel) -> ()) {
          RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kDeviceInfo, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
          {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            let dictResponse = FunctionsConstants.kShared.getDictionary(result)
            switch statusCode {
            case .SUCCESS:
              do {
                let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                  FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                let data = try JSONDecoder().decode(DeviceInfoModel.self, from: result!)
                completionClosure(data)
              } catch {
                print(error.localizedDescription)
              }

            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
              print("")
              self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
            case .UNAUTHORIZED:
                print(error)
           //   self.showLogoutAlert()
            default:
              break
            }
          }
    }
    
    func callpopupVerificationWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: PopUpVerificationModel) -> ()) {
              RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kpopVerify, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
              {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
                let dictResponse = FunctionsConstants.kShared.getDictionary(result)
                switch statusCode {
                case .SUCCESS:
                  do {
                    let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                      FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                    let data = try JSONDecoder().decode(PopUpVerificationModel.self, from: result!)
                    completionClosure(data)
                  } catch {
                    print(error.localizedDescription)
                  }

                case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
                  print("")
                  self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
                case .UNAUTHORIZED:
                    print(error)
               //   self.showLogoutAlert()
                default:
                  break
                }
              }
        }
    
    
    
    
    
    func callDeletePostWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: DeletePostModel) -> ()) {
              RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kDeletePost, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
              {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
                let dictResponse = FunctionsConstants.kShared.getDictionary(result)
                switch statusCode {
                case .SUCCESS:
                  do {
                    let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                      FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                    let data = try JSONDecoder().decode(DeletePostModel.self, from: result!)
                    completionClosure(data)
                  } catch {
                    print(error.localizedDescription)
                  }

                case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
                  print("")
                  self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
                case .UNAUTHORIZED:
                    print(error)
               //   self.showLogoutAlert()
                default:
                  break
                }
              }
        }
    
    func callDeletePostComentWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: DeletePostCommentModel) -> ()) {
              RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kDeletePostCmnd, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
              {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
                let dictResponse = FunctionsConstants.kShared.getDictionary(result)
                switch statusCode {
                case .SUCCESS:
                  do {
                    let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                      FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                    let data = try JSONDecoder().decode(DeletePostCommentModel.self, from: result!)
                    completionClosure(data)
                  } catch {
                    print(error.localizedDescription)
                  }

                case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
                  print("")
                  self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
                case .UNAUTHORIZED:
                    print(error)
               //   self.showLogoutAlert()
                default:
                  break
                }
              }
        }
    
    
    
    
    func callCurrentSearchNeighbrWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: NgbbrhoodModel) -> ()) {
          RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kSearchNeighbr, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
          {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            let dictResponse = FunctionsConstants.kShared.getDictionary(result)
            switch statusCode {
            case .SUCCESS:
              do {
                let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                  FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                let data = try JSONDecoder().decode(NgbbrhoodModel.self, from: result!)
                completionClosure(data)
              } catch {
                print(error.localizedDescription)
              }

            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
              print("")
              self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
            case .UNAUTHORIZED:
                print(error)
           //   self.showLogoutAlert()
            default:
              break
            }
          }
    }
    
    func callAddressWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: AddressModel) -> ()) {
          RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kAddress, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
          {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            let dictResponse = FunctionsConstants.kShared.getDictionary(result)
            switch statusCode {
            case .SUCCESS:
              do {
                let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                  FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                let data = try JSONDecoder().decode(AddressModel.self, from: result!)
                completionClosure(data)
              } catch {
                print(error.localizedDescription)
              }

            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
              print("")
              self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
            case .UNAUTHORIZED:
                print(error)
           //   self.showLogoutAlert()
            default:
              break
            }
          }
    }
    
    
    
    
   
   
    
    
    
//    func callHomeWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: HomeModel) -> ()) {
//          RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kHome, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
//          {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
//            let dictResponse = FunctionsConstants.kShared.getDictionary(result)
//            switch statusCode {
//            case .SUCCESS:
//              do {
//                let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
//                  FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)
//
//             //   let data = try JSONDecoder().decode(HomeModel.self, from: result!)
//                  let data = try JSONDecoder().decode(HomeModel.self, from: result!)
//                completionClosure(data)
//              } catch {
//                print(error.localizedDescription)
//              }
//
//            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
//              print("")
//              self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
//            case .UNAUTHORIZED:
//                print(error)
//           //   self.showLogoutAlert()
//            default:
//              break
//            }
//          }
//    }
    
    // Function to call User Profile Web Service
    func callUserProfileWebService(withParams dictParams: [String: Any], _ completionClosure: @escaping (_ profileModel: ProfileModel) -> ()) {
        RSNetworkManager.shared.newRequestApi(
            withServiceName: WebServiceName.kUserProfile,
            requestMethod: .POST,
            requestParameters: dictParams,
            withProgressHUD: true
        ) { (result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            // Parse the raw response data
            let dictResponse = FunctionsConstants.kShared.getDictionary(result)
            
            // Debug: Print raw JSON response
            print("Raw JSON Response: \(dictResponse)")
            
            switch statusCode {
            case .SUCCESS:
                do {
                    // Decode ProfileModel
                    let data = try JSONDecoder().decode(ProfileModel.self, from: result!)
                    completionClosure(data)
                } catch {
                    print("Decoding Error: \(error.localizedDescription)")
                    self.showAlert(withMessage: "Error in decoding response")
                }
            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
                print("Error Response: \(FunctionsConstants.kShared.getErrorMessage(dictResponse))")
                self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
            default:
                break
            }
        }
    }

    
    func callProfileUploadWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: UploadProfileModel) -> ()) {
          RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kUploadPhoto, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
          {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            let dictResponse = FunctionsConstants.kShared.getDictionary(result)
            switch statusCode {
            case .SUCCESS:
              do {
                let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                  FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                let data = try JSONDecoder().decode(UploadProfileModel.self, from: result!)
                completionClosure(data)
              } catch {
                print(error.localizedDescription)
              }

            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
              print("")
              self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
            case .UNAUTHORIZED:
                print(error)
           //   self.showLogoutAlert()
            default:
              break
            }
          }
    }
    
    func callMyNeighbrhoodWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: MyNeighbhoodModel) -> ()) {
          RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kNeighbrhood, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
          {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            let dictResponse = FunctionsConstants.kShared.getDictionary(result)
            switch statusCode {
            case .SUCCESS:
              do {
                let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                  FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                let data = try JSONDecoder().decode(MyNeighbhoodModel.self, from: result!)
                completionClosure(data)
              } catch {
                print(error.localizedDescription)
              }

            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
              print("")
              self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
            case .UNAUTHORIZED:
                print(error)
           //   self.showLogoutAlert()
            default:
              break
            }
          }
    }
    
    func callBusinessListWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: BussinessListModel) -> ()) {
          RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kbusnisees, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
          {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            let dictResponse = FunctionsConstants.kShared.getDictionary(result)
            switch statusCode {
            case .SUCCESS:
              do {
                let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                  FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                let data = try JSONDecoder().decode(BussinessListModel.self, from: result!)
                completionClosure(data)
              } catch {
                print(error.localizedDescription)
              }

            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
              print("")
              self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
            case .UNAUTHORIZED:
                print(error)
           //   self.showLogoutAlert()
            default:
              break
            }
          }
    }
    
    func callFollowWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: FollowModel) -> ()) {
          RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kSubscribe, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
          {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            let dictResponse = FunctionsConstants.kShared.getDictionary(result)
            switch statusCode {
            case .SUCCESS:
              do {
                let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                  FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                let data = try JSONDecoder().decode(FollowModel.self, from: result!)
                completionClosure(data)
              } catch {
                print(error.localizedDescription)
              }

            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
              print("")
              self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
            case .UNAUTHORIZED:
                print(error)
           //   self.showLogoutAlert()
            default:
              break
            }
          }
    }
    
    func callMemberListWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: MembersModel) -> ()) {
          RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kMemberList, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
          {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            let dictResponse = FunctionsConstants.kShared.getDictionary(result)
            switch statusCode {
            case .SUCCESS:
              do {
                let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                  FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                let data = try JSONDecoder().decode(MembersModel.self, from: result!)
                completionClosure(data)
              } catch {
                print(error.localizedDescription)
              }

            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
              print("")
              self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
            case .UNAUTHORIZED:
                print(error)
           //   self.showLogoutAlert()
            default:
              break
            }
          }
    }

    func callGroupListWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: GropsListModel) -> ()) {
          RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kGrouplist, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
          {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            let dictResponse = FunctionsConstants.kShared.getDictionary(result)
            switch statusCode {
            case .SUCCESS:
              do {
                let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                  FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                let data = try JSONDecoder().decode(GropsListModel.self, from: result!)
                completionClosure(data)
              } catch {
                print(error.localizedDescription)
              }

            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
              print("")
              self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
            case .UNAUTHORIZED:
                print(error)
           //   self.showLogoutAlert()
            default:
              break
            }
          }
    }
    
    func callEventListWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: EventListModel) -> ()) {
          RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kEventList, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
          {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            let dictResponse = FunctionsConstants.kShared.getDictionary(result)
            switch statusCode {
            case .SUCCESS:
              do {
                let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                  FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                let data = try JSONDecoder().decode(EventListModel.self, from: result!)
                completionClosure(data)
              } catch {
                print(error.localizedDescription)
              }

            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
              print("")
              self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
            case .UNAUTHORIZED:
                print(error)
           //   self.showLogoutAlert()
            default:
              break
            }
          }
    }
    
    
    
    func callPollsListWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: PollsModel) -> ()) {
          RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kPollS, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
          {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            let dictResponse = FunctionsConstants.kShared.getDictionary(result)
            switch statusCode {
            case .SUCCESS:
              do {
                let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                  FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                let data = try JSONDecoder().decode(PollsModel.self, from: result!)
                completionClosure(data)
              } catch {
                print(error.localizedDescription)
              }

            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
              print("")
              self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
            case .UNAUTHORIZED:
                print(error)
           //   self.showLogoutAlert()
            default:
              break
            }
          }
    }
    
//    func callPostListWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: PostListModel) -> ()) {
//          RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kPostList, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
//          {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
//            let dictResponse = FunctionsConstants.kShared.getDictionary(result)
//            switch statusCode {
//            case .SUCCESS:
//              do {
//                let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
//                  FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)
//
//                let data = try JSONDecoder().decode(PostListModel.self, from: result!)
//                completionClosure(data)
//              } catch {
//                print(error.localizedDescription)
//              }
//
//            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
//              print("")
//              self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
//            case .UNAUTHORIZED:
//                print(error)
//           //   self.showLogoutAlert()
//            default:
//              break
//            }
//          }
//    }

    func callNoticationWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: NotificationModel) -> ()) {
          RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kNotification, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
          {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            let dictResponse = FunctionsConstants.kShared.getDictionary(result)
            switch statusCode {
            case .SUCCESS:
              do {
                let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                  FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                let data = try JSONDecoder().decode(NotificationModel.self, from: result!)
                completionClosure(data)
              } catch {
                print(error.localizedDescription)
              }

            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
              print("")
              self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
            case .UNAUTHORIZED:
                print(error)
           //   self.showLogoutAlert()
            default:
              break
            }
          }
    }

    func callCreateGroupWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: CreateGroupModel) -> ()) {
          RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kCreateGroup, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
          {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            let dictResponse = FunctionsConstants.kShared.getDictionary(result)
            switch statusCode {
            case .SUCCESS:
              do {
                let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                  FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                let data = try JSONDecoder().decode(CreateGroupModel.self, from: result!)
                completionClosure(data)
              } catch {
                print(error.localizedDescription)
              }

            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
              print("")
              self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
            case .UNAUTHORIZED:
                print(error)
           //   self.showLogoutAlert()
            default:
              break
            }
          }
    }
    
    func callChatListWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: DirectMessageModel) -> ()) {
          RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kChat, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
          {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            let dictResponse = FunctionsConstants.kShared.getDictionary(result)
            switch statusCode {
            case .SUCCESS:
              do {
                let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                  FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                let data = try JSONDecoder().decode(DirectMessageModel.self, from: result!)
                completionClosure(data)
              } catch {
                print(error.localizedDescription)
              }

            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
              print("")
              self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
            case .UNAUTHORIZED:
                print(error)
           //   self.showLogoutAlert()
            default:
              break
            }
          }
    }

    func callChatMemberListWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: ChatMemberModel) -> ()) {
          RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kChatMember, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
          {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            let dictResponse = FunctionsConstants.kShared.getDictionary(result)
            switch statusCode {
            case .SUCCESS:
              do {
                let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                  FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                let data = try JSONDecoder().decode(ChatMemberModel.self, from: result!)
                completionClosure(data)
              } catch {
                print(error.localizedDescription)
              }

            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
              print("")
              self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
            case .UNAUTHORIZED:
                print(error)
           //   self.showLogoutAlert()
            default:
              break
            }
          }
    }

    func callChatMessageListWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: MessageModel) -> ()) {
          RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kChatMessage, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
          {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            let dictResponse = FunctionsConstants.kShared.getDictionary(result)
            switch statusCode {
            case .SUCCESS:
              do {
                let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                  FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                let data = try JSONDecoder().decode(MessageModel.self, from: result!)
                completionClosure(data)
              } catch {
                print(error.localizedDescription)
              }

            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
              print("")
              self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
            case .UNAUTHORIZED:
                print(error)
           //   self.showLogoutAlert()
            default:
              break
            }
          }
    }

    func callUserChatMessageListWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: ChatMessageModel) -> ()) {
          RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kUserChat, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
          {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            let dictResponse = FunctionsConstants.kShared.getDictionary(result)
            switch statusCode {
            case .SUCCESS:
              do {
                let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                  FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                let data = try JSONDecoder().decode(ChatMessageModel.self, from: result!)
                completionClosure(data)
              } catch {
                print(error.localizedDescription)
              }

            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
              print("")
              self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
            case .UNAUTHORIZED:
                print(error)
           //   self.showLogoutAlert()
            default:
              break
            }
          }
    }
    
    func callContactUsWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: ContactUsModel) -> ()) {
          RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kContactus, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
          {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            let dictResponse = FunctionsConstants.kShared.getDictionary(result)
            switch statusCode {
            case .SUCCESS:
              do {
                let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                  FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                let data = try JSONDecoder().decode(ContactUsModel.self, from: result!)
                completionClosure(data)
              } catch {
                print(error.localizedDescription)
              }

            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
              print("")
              self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
            case .UNAUTHORIZED:
                print(error)
           //   self.showLogoutAlert()
            default:
              break
            }
          }
    }
    
    func callSettingsWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: SettingsModel) -> ()) {
          RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kSettings, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
          {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            let dictResponse = FunctionsConstants.kShared.getDictionary(result)
            switch statusCode {
            case .SUCCESS:
              do {
                let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                  FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                let data = try JSONDecoder().decode(SettingsModel.self, from: result!)
                completionClosure(data)
              } catch {
                print(error.localizedDescription)
              }

            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
              print("")
              self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
            case .UNAUTHORIZED:
                print(error)
           //   self.showLogoutAlert()
            default:
              break
            }
          }
    }
    
    func callGetSettingsWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: SettingsModel) -> ()) {
          RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kSettings, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
          {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            let dictResponse = FunctionsConstants.kShared.getDictionary(result)
            switch statusCode {
            case .SUCCESS:
              do {
                let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                  FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                let data = try JSONDecoder().decode(SettingsModel.self, from: result!)
                completionClosure(data)
              } catch {
                print(error.localizedDescription)
              }

            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
              print("")
              self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
            case .UNAUTHORIZED:
                print(error)
           //   self.showLogoutAlert()
            default:
              break
            }
          }
    }
    
    func callChangePasswordWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: ChangePasswordModel) -> ()) {
          RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kChangePassword, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
          {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            let dictResponse = FunctionsConstants.kShared.getDictionary(result)
            switch statusCode {
            case .SUCCESS:
              do {
                let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                  FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                let data = try JSONDecoder().decode(ChangePasswordModel.self, from: result!)
                completionClosure(data)
              } catch {
                print(error.localizedDescription)
              }

            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
              print("")
              self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
            case .UNAUTHORIZED:
                print(error)
           //   self.showLogoutAlert()
            default:
              break
            }
          }
    }
    
    func callCatBussinessWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: CategoryBussinessModel) -> ()) {
          RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kCatBusiness, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
          {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            let dictResponse = FunctionsConstants.kShared.getDictionary(result)
            switch statusCode {
            case .SUCCESS:
              do {
                let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                  FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                let data = try JSONDecoder().decode(CategoryBussinessModel.self, from: result!)
                completionClosure(data)
              } catch {
                print(error.localizedDescription)
              }

            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
              print("")
              self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
            case .UNAUTHORIZED:
                print(error)
           //   self.showLogoutAlert()
            default:
              break
            }
          }
    }
    
    func callCreateBussinessWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: CreateBussinessModel) -> ()) {
          RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kCreateBussines, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
          {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            let dictResponse = FunctionsConstants.kShared.getDictionary(result)
            switch statusCode {
            case .SUCCESS:
              do {
                let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                  FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                let data = try JSONDecoder().decode(CreateBussinessModel.self, from: result!)
                completionClosure(data)
              } catch {
                print(error.localizedDescription)
              }

            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
              print("")
              self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
            case .UNAUTHORIZED:
                print(error)
           //   self.showLogoutAlert()
            default:
              break
            }
          }
    }
    
    func callExitGroupWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: ExitGroupModel) -> ()) {
          RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kExitGroup, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
          {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            let dictResponse = FunctionsConstants.kShared.getDictionary(result)
            switch statusCode {
            case .SUCCESS:
              do {
                let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                  FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                let data = try JSONDecoder().decode(ExitGroupModel.self, from: result!)
                completionClosure(data)
              } catch {
                print(error.localizedDescription)
              }

            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
              print("")
              self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
            case .UNAUTHORIZED:
                print(error)
           //   self.showLogoutAlert()
            default:
              break
            }
          }
    }
    
    func callJoinGroupWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: JoinGroupModel) -> ()) {
          RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kJoinGroup, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
          {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            let dictResponse = FunctionsConstants.kShared.getDictionary(result)
            switch statusCode {
            case .SUCCESS:
              do {
                let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                  FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                let data = try JSONDecoder().decode(JoinGroupModel.self, from: result!)
                completionClosure(data)
              } catch {
                print(error.localizedDescription)
              }

            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
              print("")
              self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
            case .UNAUTHORIZED:
                print(error)
           //   self.showLogoutAlert()
            default:
              break
            }
          }
    }
    
    func callDetailsGroupWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: GroupDetailsModel) -> ()) {
          RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kGroupDetails, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
          {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            let dictResponse = FunctionsConstants.kShared.getDictionary(result)
            switch statusCode {
            case .SUCCESS:
              do {
                let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                  FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                let data = try JSONDecoder().decode(GroupDetailsModel.self, from: result!)
                completionClosure(data)
              } catch {
                print(error.localizedDescription)
              }

            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
              print("")
              self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
            case .UNAUTHORIZED:
                print(error)
           //   self.showLogoutAlert()
            default:
              break
            }
          }
    }
    
    func callGroupListGroupWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: GroupListModel) -> ()) {
          RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kGroupList, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
          {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            let dictResponse = FunctionsConstants.kShared.getDictionary(result)
            switch statusCode {
            case .SUCCESS:
              do {
                let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                  FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                let data = try JSONDecoder().decode(GroupListModel.self, from: result!)
                completionClosure(data)
              } catch {
                print(error.localizedDescription)
              }

            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
              print("")
              self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
            case .UNAUTHORIZED:
                print(error)
           //   self.showLogoutAlert()
            default:
              break
            }
          }
    }
    
    func callAcceptGroupWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: ApproveGroupModel) -> ()) {
          RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kAcceptGroup, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
          {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            let dictResponse = FunctionsConstants.kShared.getDictionary(result)
            switch statusCode {
            case .SUCCESS:
              do {
                let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                  FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                let data = try JSONDecoder().decode(ApproveGroupModel.self, from: result!)
                completionClosure(data)
              } catch {
                print(error.localizedDescription)
              }

            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
              print("")
              self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
            case .UNAUTHORIZED:
                print(error)
           //   self.showLogoutAlert()
            default:
              break
            }
          }
    }
    
    func callGroupChatListWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: GroupChatListModel) -> ()) {
          RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kGroupChatList, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
          {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            let dictResponse = FunctionsConstants.kShared.getDictionary(result)
            switch statusCode {
            case .SUCCESS:
              do {
                let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                  FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                let data = try JSONDecoder().decode(GroupChatListModel.self, from: result!)
                completionClosure(data)
              } catch {
                print(error.localizedDescription)
              }

            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
              print("")
              self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
            case .UNAUTHORIZED:
                print(error)
           //   self.showLogoutAlert()
            default:
              break
            }
          }
    }
    
    func callGroupMessageWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: GroupChatModel) -> ()) {
          RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kMessageGroup, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
          {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            let dictResponse = FunctionsConstants.kShared.getDictionary(result)
            switch statusCode {
            case .SUCCESS:
              do {
                let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                  FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                let data = try JSONDecoder().decode(GroupChatModel.self, from: result!)
                completionClosure(data)
              } catch {
                print(error.localizedDescription)
              }

            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
              print("")
              self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
            case .UNAUTHORIZED:
                print(error)
           //   self.showLogoutAlert()
            default:
              break
            }
          }
    }
    
    func callGroupDeleteWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: GroupDeleteModel) -> ()) {
          RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kDeleteGroup, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
          {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            let dictResponse = FunctionsConstants.kShared.getDictionary(result)
            switch statusCode {
            case .SUCCESS:
              do {
                let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                  FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                let data = try JSONDecoder().decode(GroupDeleteModel.self, from: result!)
                completionClosure(data)
              } catch {
                print(error.localizedDescription)
              }

            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
              print("")
              self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
            case .UNAUTHORIZED:
                print(error)
           //   self.showLogoutAlert()
            default:
              break
            }
          }
    }
    
    func callUpdateGroupWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: UpdateGroupModel) -> ()) {
          RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kUpdateGroup, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
          {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            let dictResponse = FunctionsConstants.kShared.getDictionary(result)
            switch statusCode {
            case .SUCCESS:
              do {
                let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                  FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                let data = try JSONDecoder().decode(UpdateGroupModel.self, from: result!)
                completionClosure(data)
              } catch {
                print(error.localizedDescription)
              }

            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
              print("")
              self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
            case .UNAUTHORIZED:
                print(error)
           //   self.showLogoutAlert()
            default:
              break
            }
          }
    }
    
    func callDelUserGroupWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: DeleteUserModel) -> ()) {
          RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kDelUser, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
          {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            let dictResponse = FunctionsConstants.kShared.getDictionary(result)
            switch statusCode {
            case .SUCCESS:
              do {
                let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                  FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                let data = try JSONDecoder().decode(DeleteUserModel.self, from: result!)
                completionClosure(data)
              } catch {
                print(error.localizedDescription)
              }

            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
              print("")
              self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
            case .UNAUTHORIZED:
                print(error)
           //   self.showLogoutAlert()
            default:
              break
            }
          }
    }
    
    func callPostListWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: PostListModel) -> ()) {
          RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kPostList, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
          {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            let dictResponse = FunctionsConstants.kShared.getDictionary(result)
            switch statusCode {
            case .SUCCESS:
              do {
                let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                  FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                let data = try JSONDecoder().decode(PostListModel.self, from: result!)
                completionClosure(data)
              } catch {
                print(error.localizedDescription)
              }

            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
              print("")
              self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
            case .UNAUTHORIZED:
                print(error)
           //   self.showLogoutAlert()
            default:
              break
            }
          }
    }
    
    func callPostLikeWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: LikePostModel) -> ()) {
          RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kLikePost, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
          {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            let dictResponse = FunctionsConstants.kShared.getDictionary(result)
            switch statusCode {
            case .SUCCESS:
              do {
                let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                  FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                let data = try JSONDecoder().decode(LikePostModel.self, from: result!)
                completionClosure(data)
              } catch {
                print(error.localizedDescription)
              }

            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
              print("")
              self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
            case .UNAUTHORIZED:
                print(error)
           //   self.showLogoutAlert()
            default:
              break
            }
          }
    }
    
    func callPostUnLikeWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: LikePostModel) -> ()) {
          RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kLikePost, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
          {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            let dictResponse = FunctionsConstants.kShared.getDictionary(result)
            switch statusCode {
            case .SUCCESS:
              do {
                let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                  FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                let data = try JSONDecoder().decode(LikePostModel.self, from: result!)
                completionClosure(data)
              } catch {
                print(error.localizedDescription)
              }

            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
              print("")
              self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
            case .UNAUTHORIZED:
                print(error)
           //   self.showLogoutAlert()
            default:
              break
            }
          }
    }
    
    func callPostCommenteWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: CommentPostModel) -> ()) {
          RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kCommentPosts, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
          {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            let dictResponse = FunctionsConstants.kShared.getDictionary(result)
            switch statusCode {
            case .SUCCESS:
              do {
                let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                  FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                let data = try JSONDecoder().decode(CommentPostModel.self, from: result!)
                completionClosure(data)
              } catch {
                print(error.localizedDescription)
              }

            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
              print("")
              self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
            case .UNAUTHORIZED:
                print(error)
           //   self.showLogoutAlert()
            default:
              break
            }
          }
    }
    
    func callCommentePostWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: PostCommentModel) -> ()) {
          RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kPostComment, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
          {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            let dictResponse = FunctionsConstants.kShared.getDictionary(result)
            switch statusCode {
            case .SUCCESS:
              do {
                let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                  FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                let data = try JSONDecoder().decode(PostCommentModel.self, from: result!)
                completionClosure(data)
              } catch {
                print(error.localizedDescription)
              }

            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
              print("")
              self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
            case .UNAUTHORIZED:
                print(error)
           //   self.showLogoutAlert()
            default:
              break
            }
          }
    }
    
    func callLikeListPostWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: LikeListModel) -> ()) {
          RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kLikeList, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
          {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            let dictResponse = FunctionsConstants.kShared.getDictionary(result)
            switch statusCode {
            case .SUCCESS:
              do {
                let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                  FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                let data = try JSONDecoder().decode(LikeListModel.self, from: result!)
                completionClosure(data)
              } catch {
                print(error.localizedDescription)
              }

            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
              print("")
              self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
            case .UNAUTHORIZED:
                print(error)
           //   self.showLogoutAlert()
            default:
              break
            }
          }
    }
    
    func callCategoryPostWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: CategoryPostModel) -> ()) {
          RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kPostcategory, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
          {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            let dictResponse = FunctionsConstants.kShared.getDictionary(result)
            switch statusCode {
            case .SUCCESS:
              do {
                let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                  FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                let data = try JSONDecoder().decode(CategoryPostModel.self, from: result!)
                completionClosure(data)
              } catch {
                print(error.localizedDescription)
              }

            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
              print("")
              self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
            case .UNAUTHORIZED:
                print(error)
           //   self.showLogoutAlert()
            default:
              break
            }
          }
    }
    
    func callCreatePostWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: CreatePostModel) -> ()) {
          RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kCreatePost, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
          {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            let dictResponse = FunctionsConstants.kShared.getDictionary(result)
            switch statusCode {
            case .SUCCESS:
              do {
                let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                  FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                  let data = try JSONDecoder().decode(CreatePostModel.self, from: result!)
                completionClosure(data)
              } catch {
                print(error.localizedDescription)
              }

            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
              print("")
              self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
            case .UNAUTHORIZED:
                print(error)
           //   self.showLogoutAlert()
            default:
              break
            }
          }
    }
    
    func callHomeAllWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: HomeAllModel) -> ()) {
          RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kAllHomeDataa, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
          {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            let dictResponse = FunctionsConstants.kShared.getDictionary(result)
            switch statusCode {
            case .SUCCESS:
              do {
                let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                  FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                  let data = try JSONDecoder().decode(HomeAllModel.self, from: result!)
                completionClosure(data)
              } catch {
                print(error.localizedDescription)
              }

            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
              print("")
              self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
            case .UNAUTHORIZED:
                print(error)
           //   self.showLogoutAlert()
            default:
              break
            }
          }
    }

    func callFavouriteListPostWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: FavouriteListModel) -> ()) {
          RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kFavouriteList, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
          {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            let dictResponse = FunctionsConstants.kShared.getDictionary(result)
            switch statusCode {
            case .SUCCESS:
              do {
                let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                  FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                let data = try JSONDecoder().decode(FavouriteListModel.self, from: result!)
                completionClosure(data)
              } catch {
                print(error.localizedDescription)
              }

            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
              print("")
              self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
            case .UNAUTHORIZED:
                print(error)
           //   self.showLogoutAlert()
            default:
              break
            }
          }
    }
    
    func callBussinesDetailPostWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: BusinessDetailModel) -> ()) {
          RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kBussinesDetail, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
          {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            let dictResponse = FunctionsConstants.kShared.getDictionary(result)
            switch statusCode {
            case .SUCCESS:
              do {
                let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                  FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                let data = try JSONDecoder().decode(BusinessDetailModel.self, from: result!)
                completionClosure(data)
              } catch {
                print(error.localizedDescription)
              }

            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
              print("")
              self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
            case .UNAUTHORIZED:
                print(error)
           //   self.showLogoutAlert()
            default:
              break
            }
          }
    }
    
    func callBussinesReviewDetailPostWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: BusinessReviewModel) -> ()) {
          RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kBusinessReview, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
          {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            let dictResponse = FunctionsConstants.kShared.getDictionary(result)
            switch statusCode {
            case .SUCCESS:
              do {
                let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                  FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                let data = try JSONDecoder().decode(BusinessReviewModel.self, from: result!)
                completionClosure(data)
              } catch {
                print(error.localizedDescription)
              }

            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
              print("")
              self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
            case .UNAUTHORIZED:
                print(error)
           //   self.showLogoutAlert()
            default:
              break
            }
          }
    }
    
    
    // MARK: - Delete BussinessReviewDelete
    
    func callBussinesReviewDeleteWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: DeleteBusinessReviewModel) -> ()) {
          RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kDeleteBusinessReview, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
          {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            let dictResponse = FunctionsConstants.kShared.getDictionary(result)
            switch statusCode {
            case .SUCCESS:
              do {
                let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                  FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                let data = try JSONDecoder().decode(DeleteBusinessReviewModel.self, from: result!)
                completionClosure(data)
              } catch {
                print(error.localizedDescription)
              }

            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
              print("")
              self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
            case .UNAUTHORIZED:
                print(error)
           //   self.showLogoutAlert()
            default:
              break
            }
          }
    }
    
    
    
    
    
    func callBussinesTypePostWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: BusinessCategoryModel) -> ()) {
          RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kBusinessType, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
          {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            let dictResponse = FunctionsConstants.kShared.getDictionary(result)
            switch statusCode {
            case .SUCCESS:
              do {
                let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                  FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                let data = try JSONDecoder().decode(BusinessCategoryModel.self, from: result!)
                completionClosure(data)
              } catch {
                print(error.localizedDescription)
              }

            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
              print("")
              self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
            case .UNAUTHORIZED:
                print(error)
           //   self.showLogoutAlert()
            default:
              break
            }
          }
    }

    func callReviewCommentWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: ReviewCommentModel) -> ()) {
          RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kReviwcomment, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
          {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            let dictResponse = FunctionsConstants.kShared.getDictionary(result)
            switch statusCode {
            case .SUCCESS:
              do {
                let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                  FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                let data = try JSONDecoder().decode(ReviewCommentModel.self, from: result!)
                completionClosure(data)
              } catch {
                print(error.localizedDescription)
              }

            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
              print("")
              self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
            case .UNAUTHORIZED:
                print(error)
           //   self.showLogoutAlert()
            default:
              break
            }
          }
    }
    
    func callRatingBusinessWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: BusinessRatingModel) -> ()) {
          RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kRatingBusiness, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
          {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            let dictResponse = FunctionsConstants.kShared.getDictionary(result)
            switch statusCode {
            case .SUCCESS:
              do {
                let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                  FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                let data = try JSONDecoder().decode(BusinessRatingModel.self, from: result!)
                completionClosure(data)
              } catch {
                print(error.localizedDescription)
              }

            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
              print("")
              self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
            case .UNAUTHORIZED:
                print(error)
           //   self.showLogoutAlert()
            default:
              break
            }
          }
    }
    
    func callDeleteBusinessWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: DeleteBusinessModel) -> ()) {
          RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kDeleteBusiness, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
          {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            let dictResponse = FunctionsConstants.kShared.getDictionary(result)
            switch statusCode {
            case .SUCCESS:
              do {
                let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                  FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                let data = try JSONDecoder().decode(DeleteBusinessModel.self, from: result!)
                completionClosure(data)
              } catch {
                print(error.localizedDescription)
              }

            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
              print("")
              self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
            case .UNAUTHORIZED:
                print(error)
           //   self.showLogoutAlert()
            default:
              break
            }
          }
    }
    
    func callUpdateBusinessWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: UpdateBusinessModel) -> ()) {
          RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kUpdateBusiness, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
          {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            let dictResponse = FunctionsConstants.kShared.getDictionary(result)
            switch statusCode {
            case .SUCCESS:
              do {
                let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                  FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                let data = try JSONDecoder().decode(UpdateBusinessModel.self, from: result!)
                completionClosure(data)
              } catch {
                print(error.localizedDescription)
              }

            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
              print("")
              self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
            case .UNAUTHORIZED:
                print(error)
           //   self.showLogoutAlert()
            default:
              break
            }
          }
    }
    
    func callEventDetailWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: EventDetailModel) -> ()) {
          RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kEventDetail, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
          {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            let dictResponse = FunctionsConstants.kShared.getDictionary(result)
            switch statusCode {
            case .SUCCESS:
              do {
                let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                  FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                let data = try JSONDecoder().decode(EventDetailModel.self, from: result!)
                completionClosure(data)
              } catch {
                print(error.localizedDescription)
              }

            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
              print("")
              self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
            case .UNAUTHORIZED:
                print(error)
           //   self.showLogoutAlert()
            default:
              break
            }
          }
    }
    
    func callEventUploadImgWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: UploadEventDetailModel) -> ()) {
          RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kUploadImageEventt, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
          {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            let dictResponse = FunctionsConstants.kShared.getDictionary(result)
            switch statusCode {
            case .SUCCESS:
              do {
                let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                  FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                let data = try JSONDecoder().decode(UploadEventDetailModel.self, from: result!)
                completionClosure(data)
              } catch {
                print(error.localizedDescription)
              }

            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
              print("")
              self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
            case .UNAUTHORIZED:
                print(error)
           //   self.showLogoutAlert()
            default:
              break
            }
          }
    }
    
    
    func callCreateEventWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: CreateEventModel) -> ()) {
          RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kCreateEvent, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
          {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            let dictResponse = FunctionsConstants.kShared.getDictionary(result)
            switch statusCode {
            case .SUCCESS:
              do {
                let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                  FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                let data = try JSONDecoder().decode(CreateEventModel.self, from: result!)
                completionClosure(data)
              } catch {
                print(error.localizedDescription)
              }

            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
              print("")
              self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
            case .UNAUTHORIZED:
                print(error)
           //   self.showLogoutAlert()
            default:
              break
            }
          }
    }
    
    func callEventJoinListWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: EventJionListModel) -> ()) {
          RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kEventJointList, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
          {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            let dictResponse = FunctionsConstants.kShared.getDictionary(result)
            switch statusCode {
            case .SUCCESS:
              do {
                let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                  FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                let data = try JSONDecoder().decode(EventJionListModel.self, from: result!)
                completionClosure(data)
              } catch {
                print(error.localizedDescription)
              }

            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
              print("")
              self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
            case .UNAUTHORIZED:
                print(error)
           //   self.showLogoutAlert()
            default:
              break
            }
          }
    }
    
    func callEventDeleteListWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: DeleteEventModel) -> ()) {
          RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kDelteEvent, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
          {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            let dictResponse = FunctionsConstants.kShared.getDictionary(result)
            switch statusCode {
            case .SUCCESS:
              do {
                let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                  FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                let data = try JSONDecoder().decode(DeleteEventModel.self, from: result!)
                completionClosure(data)
              } catch {
                print(error.localizedDescription)
              }

            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
              print("")
              self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
            case .UNAUTHORIZED:
                print(error)
           //   self.showLogoutAlert()
            default:
              break
            }
          }
    }
    
    func callEventImgDelWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: DeleteImgEventModel) -> ()) {
          RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kEventImgDel, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
          {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            let dictResponse = FunctionsConstants.kShared.getDictionary(result)
            switch statusCode {
            case .SUCCESS:
              do {
                let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                  FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                let data = try JSONDecoder().decode(DeleteImgEventModel.self, from: result!)
                completionClosure(data)
              } catch {
                print(error.localizedDescription)
              }

            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
              print("")
              self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
            case .UNAUTHORIZED:
                print(error)
           //   self.showLogoutAlert()
            default:
              break
            }
          }
    }
    
    func callEventYesjointWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: EventYesJointModel) -> ()) {
          RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kEventYesJoint, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
          {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            let dictResponse = FunctionsConstants.kShared.getDictionary(result)
            switch statusCode {
            case .SUCCESS:
              do {
                let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                  FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                let data = try JSONDecoder().decode(EventYesJointModel.self, from: result!)
                completionClosure(data)
              } catch {
                print(error.localizedDescription)
              }

            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
              print("")
              self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
            case .UNAUTHORIZED:
                print(error)
           //   self.showLogoutAlert()
            default:
              break
            }
          }
    }
    
    func callEventNojointWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: EventYesJointModel) -> ()) {
          RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kEventYesJoint, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
          {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            let dictResponse = FunctionsConstants.kShared.getDictionary(result)
            switch statusCode {
            case .SUCCESS:
              do {
                let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                  FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                let data = try JSONDecoder().decode(EventYesJointModel.self, from: result!)
                completionClosure(data)
              } catch {
                print(error.localizedDescription)
              }

            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
              print("")
              self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
            case .UNAUTHORIZED:
                print(error)
           //   self.showLogoutAlert()
            default:
              break
            }
          }
    }
    
    func callEventLikeWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: EventYesJointModel) -> ()) {
          RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kEventYesJoint, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
          {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            let dictResponse = FunctionsConstants.kShared.getDictionary(result)
            switch statusCode {
            case .SUCCESS:
              do {
                let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                  FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                let data = try JSONDecoder().decode(EventYesJointModel.self, from: result!)
                completionClosure(data)
              } catch {
                print(error.localizedDescription)
              }

            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
              print("")
              self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
            case .UNAUTHORIZED:
                print(error)
           //   self.showLogoutAlert()
            default:
              break
            }
          }
    }
    
    func callNewNotificationWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: NewNotificationModel) -> ()) {
          RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kNewNotification, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
          {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            let dictResponse = FunctionsConstants.kShared.getDictionary(result)
            switch statusCode {
            case .SUCCESS:
              do {
                let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                  FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                let data = try JSONDecoder().decode(NewNotificationModel.self, from: result!)
                completionClosure(data)
              } catch {
                print(error.localizedDescription)
              }

            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
              print("")
              self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
            case .UNAUTHORIZED:
                print(error)
           //   self.showLogoutAlert()
            default:
              break
            }
          }
    }
    
    func callMarketcatWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: MarketCatModel) -> ()) {
          RSNetworkManager.shared.newMarketRequestApi(withServiceName: WebServiceName.kMarketcat, requestMethod: .GET, requestParameters: dictParams, withProgressHUD: true)
          {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            let dictResponse = FunctionsConstants.kShared.getDictionary(result)
            switch statusCode {
            case .SUCCESS:
              do {
                let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                  FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                let data = try JSONDecoder().decode(MarketCatModel.self, from: result!)
                completionClosure(data)
              } catch {
                print(error.localizedDescription)
              }

            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
              print("")
              self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
            case .UNAUTHORIZED:
                print(error)
           //   self.showLogoutAlert()
            default:
              break
            }
          }
    }
    
    func callAllMarketWallWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: MarketWallModel) -> ()) {
          RSNetworkManager.shared.newMarketRequestApi(withServiceName: WebServiceName.kMarketWall, requestMethod: .GET, requestParameters: dictParams, withProgressHUD: true)
          {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            let dictResponse = FunctionsConstants.kShared.getDictionary(result)
            switch statusCode {
            case .SUCCESS:
              do {
                let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                  FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                let data = try JSONDecoder().decode(MarketWallModel.self, from: result!)
                completionClosure(data)
              } catch {
                print(error.localizedDescription)
              }

            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
              print("")
              self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
            case .UNAUTHORIZED:
                print(error)
           //   self.showLogoutAlert()
            default:
              break
            }
          }
    }
    
    
    
    func callProductListWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: TodaProductListModel) -> ()) {
              RSNetworkManager.shared.newMarketRequestApi(withServiceName: WebServiceName.kProductListl, requestMethod: .GET, requestParameters: dictParams, withProgressHUD: true)
              {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
                let dictResponse = FunctionsConstants.kShared.getDictionary(result)
                switch statusCode {
                case .SUCCESS:
                  do {
                    let data = try JSONDecoder().decode(TodaProductListModel.self, from: result!)
                    completionClosure(data)
                  } catch {
                    print(error.localizedDescription)
                  }
                  
                case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
                  print("")
                  self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
                case .UNAUTHORIZED:
                    print(error)
               //   self.showLogoutAlert()
                default:
                  break
                }
              }
        }
    
    
    
    
    
    
    
    func callHomebookayWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: HomeBookayModel) -> ()) {
              RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kHomeBookay, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
              {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
                let dictResponse = FunctionsConstants.kShared.getDictionary(result)
                switch statusCode {
                case .SUCCESS:
                  do {
                    let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                      FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                    let data = try JSONDecoder().decode(HomeBookayModel.self, from: result!)
                    completionClosure(data)
                  } catch {
                    print(error.localizedDescription)
                  }

                case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
                  print("")
                  self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
                case .UNAUTHORIZED:
                    print(error)
               //   self.showLogoutAlert()
                default:
                  break
                }
              }
        }
        
        func callHomeLikeWelWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: HomeLikeWelcomeModel) -> ()) {
              RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kHomeBookay, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
              {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
                let dictResponse = FunctionsConstants.kShared.getDictionary(result)
                switch statusCode {
                case .SUCCESS:
                  do {
                    let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                      FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                    let data = try JSONDecoder().decode(HomeLikeWelcomeModel.self, from: result!)
                    completionClosure(data)
                  } catch {
                    print(error.localizedDescription)
                  }

                case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
                  print("")
                  self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
                case .UNAUTHORIZED:
                    print(error)
               //   self.showLogoutAlert()
                default:
                  break
                }
              }
        }
    
    
    
    func callFavouriteBussinessWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: FavouriteBussinessModel) -> ()) {
              RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kFavouirtBuss, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
              {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
                let dictResponse = FunctionsConstants.kShared.getDictionary(result)
                switch statusCode {
                case .SUCCESS:
                  do {
                    let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                      FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                    let data = try JSONDecoder().decode(FavouriteBussinessModel.self, from: result!)
                    completionClosure(data)
                  } catch {
                    print(error.localizedDescription)
                  }

                case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
                  print("")
                  self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
                case .UNAUTHORIZED:
                    print(error)
               //   self.showLogoutAlert()
                default:
                  break
                }
              }
        }
        
        func callFavouriteRemoveBussinessWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: RemoveFavouriteBussiness) -> ()) {
              RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kRemoveFavouirtBuss, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
              {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
                let dictResponse = FunctionsConstants.kShared.getDictionary(result)
                switch statusCode {
                case .SUCCESS:
                  do {
                    let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                      FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                    let data = try JSONDecoder().decode(RemoveFavouriteBussiness.self, from: result!)
                    completionClosure(data)
                  } catch {
                    print(error.localizedDescription)
                  }

                case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
                  print("")
                  self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
                case .UNAUTHORIZED:
                    print(error)
               //   self.showLogoutAlert()
                default:
                  break
                }
              }
        }
    
    
    
    func callReportPostWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: ReportCategory) -> ()) {
              RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kReportpost, requestMethod: .GET, requestParameters: dictParams, withProgressHUD: true)
              {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
                let dictResponse = FunctionsConstants.kShared.getDictionary(result)
                switch statusCode {
                case .SUCCESS:
                  do {
                    let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                      FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                    let data = try JSONDecoder().decode(ReportCategory.self, from: result!)
                    completionClosure(data)
                  } catch {
                    print(error.localizedDescription)
                  }

                case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
                  print("")
                  self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
                case .UNAUTHORIZED:
                    print(error)
               //   self.showLogoutAlert()
                default:
                  break
                }
              }
        }
    
    
    func calldirectoryWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: PublicDirectoryModel) -> ()) {
              RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kPublicDirect, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
              {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
                let dictResponse = FunctionsConstants.kShared.getDictionary(result)
                switch statusCode {
                case .SUCCESS:
                  do {
                    let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                      FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                    let data = try JSONDecoder().decode(PublicDirectoryModel.self, from: result!)
                    completionClosure(data)
                  } catch {
                    print(error.localizedDescription)
                  }

                case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
                  print("")
                  self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
                case .UNAUTHORIZED:
                    print(error)
               //   self.showLogoutAlert()
                default:
                  break
                }
              }
        }
    
    
    func callReportPostFinalWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: FinalReportModel) -> ()) {
              RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kReportFinalpost, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
              {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
                let dictResponse = FunctionsConstants.kShared.getDictionary(result)
                switch statusCode {
                case .SUCCESS:
                  do {
                    let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                      FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                    let data = try JSONDecoder().decode(FinalReportModel.self, from: result!)
                    completionClosure(data)
                  } catch {
                    print(error.localizedDescription)
                  }

                case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
                  print("")
                  self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
                case .UNAUTHORIZED:
                    print(error)
               //   self.showLogoutAlert()
                default:
                  break
                }
              }
        }
    
    
    func callPollDeleteWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: DeletePollModel) -> ()) {
              RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kDeletepoll, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
              {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
                let dictResponse = FunctionsConstants.kShared.getDictionary(result)
                switch statusCode {
                case .SUCCESS:
                  do {
                    let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                      FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                    let data = try JSONDecoder().decode(DeletePollModel.self, from: result!)
                    completionClosure(data)
                  } catch {
                    print(error.localizedDescription)
                  }

                case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
                  print("")
                  self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
                case .UNAUTHORIZED:
                    print(error)
               //   self.showLogoutAlert()
                default:
                  break
                }
              }
        }
    
    func callPollVotedWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: PollVotedModel) -> ()) {
              RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kpollVoted, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
              {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
                let dictResponse = FunctionsConstants.kShared.getDictionary(result)
                switch statusCode {
                case .SUCCESS:
                  do {
                    let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                      FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                    let data = try JSONDecoder().decode(PollVotedModel.self, from: result!)
                    completionClosure(data)
                  } catch {
                    print(error.localizedDescription)
                  }

                case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
                  print("")
                  self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
                case .UNAUTHORIZED:
                    print(error)
               //   self.showLogoutAlert()
                default:
                  break
                }
              }
        }
    
    func callPollDetailWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: PollDetailModel) -> ()) {
              RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kpollDetail, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
              {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
                let dictResponse = FunctionsConstants.kShared.getDictionary(result)
                switch statusCode {
                case .SUCCESS:
                  do {
                    let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                      FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                     let data = try JSONDecoder().decode(PollDetailModel.self, from: result!)
                    completionClosure(data)
                  } catch {
                    print(error.localizedDescription)
                  }

                case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
                  print("")
                  self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
                case .UNAUTHORIZED:
                    print(error)
               //   self.showLogoutAlert()
                default:
                  break
                }
              }
        }
    
    
    
    
    func callFAQWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: FAQModel) -> ()) {
              RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kFAQ, requestMethod: .GET, requestParameters: dictParams, withProgressHUD: true)
              {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
                let dictResponse = FunctionsConstants.kShared.getDictionary(result)
                switch statusCode {
                case .SUCCESS:
                  do {
                    let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                      FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                    let data = try JSONDecoder().decode(FAQModel.self, from: result!)
                    completionClosure(data)
                  } catch {
                    print(error.localizedDescription)
                  }

                case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
                  print("")
                  self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
                case .UNAUTHORIZED:
                    print(error)
               //   self.showLogoutAlert()
                default:
                  break
                }
              }
        }
    
    
    
    func callPollCreateWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: CreatePollModel) -> ()) {
              RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kpollCreate, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
              {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
                let dictResponse = FunctionsConstants.kShared.getDictionary(result)
                switch statusCode {
                case .SUCCESS:
                  do {
                    let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                      FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                    let data = try JSONDecoder().decode(CreatePollModel.self, from: result!)
                    completionClosure(data)
                  } catch {
                    print(error.localizedDescription)
                  }

                case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
                  print("")
                  self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
                case .UNAUTHORIZED:
                    print(error)
               //   self.showLogoutAlert()
                default:
                  break
                }
              }
        }
    
    
    
    func callNotificationCountWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: NotificationCountModel) -> ()) {
              RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kNotificationCounta, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
              {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
                let dictResponse = FunctionsConstants.kShared.getDictionary(result)
                switch statusCode {
                case .SUCCESS:
                  do {
                    let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                      FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                    let data = try JSONDecoder().decode(NotificationCountModel.self, from: result!)
                    completionClosure(data)
                  } catch {
                    print(error.localizedDescription)
                  }

                case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
                  print("")
                  self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
                case .UNAUTHORIZED:
                    print(error)
               //   self.showLogoutAlert()
                default:
                  break
                }
              }
        }
    
    
    
    func callpostDetailWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: PostDetailModel) -> ()) {
              RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kpostDetail, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
              {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
                let dictResponse = FunctionsConstants.kShared.getDictionary(result)
                switch statusCode {
                case .SUCCESS:
                  do {
                    let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                      FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                    let data = try JSONDecoder().decode(PostDetailModel.self, from: result!)
                    completionClosure(data)
                  } catch {
                    print(error.localizedDescription)
                  }

                case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
                  print("")
                  self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
                case .UNAUTHORIZED:
                    print(error)
               //   self.showLogoutAlert()
                default:
                  break
                }
              }
        }
    
    
    
    
    
    func callPollEditWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: PollEditModel) -> ()) {
              RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kpollEdit, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
              {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
                let dictResponse = FunctionsConstants.kShared.getDictionary(result)
                switch statusCode {
                case .SUCCESS:
                  do {
                    let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                      FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                     let data = try JSONDecoder().decode(PollEditModel.self, from: result!)
                    completionClosure(data)
                  } catch {
                    print(error.localizedDescription)
                  }

                case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
                  print("")
                  self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
                case .UNAUTHORIZED:
                    print(error)
               //   self.showLogoutAlert()
                default:
                  break
                }
              }
        }
    
    // Web service method which expects Data and returns decoded UploadedDocumentsModel
    func callUploadDocumnetWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ uploadedDocumentsModel: UploadedDocumentsModel) -> ()) {
        RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kUploadedDocuments, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true) { (result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
            let dictResponse = FunctionsConstants.kShared.getDictionary(result)
            switch statusCode {
            case .SUCCESS:
                do {
                    // Assuming the response data is a dictionary and decoding it to model
                    let data = try JSONDecoder().decode(UploadedDocumentsModel.self, from: result!)
                    completionClosure(data) // Pass the decoded model to the closure
                } catch {
                    print("Failed to decode: \(error.localizedDescription)")
                }
            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
                print("Error: \(FunctionsConstants.kShared.getErrorMessage(dictResponse))")
            case .UNAUTHORIZED:
                print("Unauthorized error")
            default:
                break
            }
        }
    }
    
    func callUpdateEventWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: UpdateEventModel) -> ()) {
                  RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kUpdateEvent, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
                  {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
                    let dictResponse = FunctionsConstants.kShared.getDictionary(result)
                    switch statusCode {
                    case .SUCCESS:
                      do {
                        let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                          FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                        let data = try JSONDecoder().decode(UpdateEventModel.self, from: result!)
                        completionClosure(data)
                      } catch {
                        print(error.localizedDescription)
                      }

                    case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
                      print("")
                      self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
                    case .UNAUTHORIZED:
                        print(error)
                   //   self.showLogoutAlert()
                    default:
                      break
                    }
                  }
            }
    
    
    func callAboutUsWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: AboutusModel) -> ()) {
              RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kaboutUs, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
              {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
                let dictResponse = FunctionsConstants.kShared.getDictionary(result)
                switch statusCode {
                case .SUCCESS:
                  do {
                    let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                      FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                    let data = try JSONDecoder().decode(AboutusModel.self, from: result!)
                    completionClosure(data)
                  } catch {
                    print(error.localizedDescription)
                  }

                case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
                  print("")
                  self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
                case .UNAUTHORIZED:
                    print(error)
               //   self.showLogoutAlert()
                default:
                  break
                }
              }
        }
    
    func callHideNotificationWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: HideNotificationModel) -> ()) {
              RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kHideNotification, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
              {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
                let dictResponse = FunctionsConstants.kShared.getDictionary(result)
                switch statusCode {
                case .SUCCESS:
                  do {
                    let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                      FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                    let data = try JSONDecoder().decode(HideNotificationModel.self, from: result!)
                    completionClosure(data)
                  } catch {
                    print(error.localizedDescription)
                  }

                case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
                  print("")
                  self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
                case .UNAUTHORIZED:
                    print(error)
               //   self.showLogoutAlert()
                default:
                  break
                }
              }
        }
    
    
    func callEventAttendesImgDelWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: DeleteImgEventModel) -> ()) {
              RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kEventImgDel, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
              {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
                let dictResponse = FunctionsConstants.kShared.getDictionary(result)
                switch statusCode {
                case .SUCCESS:
                  do {
                    let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                      FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                    let data = try JSONDecoder().decode(DeleteImgEventModel.self, from: result!)
                    completionClosure(data)
                  } catch {
                    print(error.localizedDescription)
                  }

                case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
                  print("")
                  self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
                case .UNAUTHORIZED:
                    print(error)
               //   self.showLogoutAlert()
                default:
                  break
                }
              }
        }
    
    func callEventLikeListWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: EventLikeListModel) -> ()) {
              RSNetworkManager.shared.newRequestApi(withServiceName: WebServiceName.kEventLikeList, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
              {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
                let dictResponse = FunctionsConstants.kShared.getDictionary(result)
                switch statusCode {
                case .SUCCESS:
                  do {
                    let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
                      FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)

                    let data = try JSONDecoder().decode(EventLikeListModel.self, from: result!)
                    completionClosure(data)
                  } catch {
                    print(error.localizedDescription)
                  }

                case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
                  print("")
                  self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
                case .UNAUTHORIZED:
                    print(error)
               //   self.showLogoutAlert()
                default:
                  break
                }
              }
        }
    
    
    
//    func callAddressProofWebService(withParams dictParams: Dictionary<String, Any>, _ completionClosure: @escaping (_ subCategoryModel: AdressProofModel) -> ()) {
//          RSNetworkManager.shared.requestMultipartApi(withServiceName: WebServiceName.kAddressProof, requestMethod: .POST, requestParameters: dictParams, withProgressHUD: true)
//          {(result: Data?, error: Error?, errorType: ErrorType, statusCode: HTTPStatusCodeConstants) in
//            let dictResponse = FunctionsConstants.kShared.getDictionary(result)
//            switch statusCode {
//            case .SUCCESS:
//              do {
//                let dictResult = FunctionsConstants.kShared.getDictionary(dictResponse[KeyConstants.kData])
//                  FunctionsConstants.kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dictResult)
//
//                let data = try JSONDecoder().decode(AdressProofModel.self, from: result!)
//                completionClosure(data)
//              } catch {
//                print(error.localizedDescription)
//              }
//
//            case .NO_CONTENT, .FORBIDDEN, .BAD_REQUEST:
//              print("")
//              self.showAlert(withMessage: FunctionsConstants.kShared.getErrorMessage(dictResponse))
//            case .UNAUTHORIZED:
//                print(error)
//           //   self.showLogoutAlert()
//            default:
//              break
//            }
//          }
//    }
    
//  private func showAlert(withMessage message: String) {
//
//    if #available(iOS 13.0, *) {
//
//      NotificationCenter.default.post(name: Notification.Name.showAlert, object: nil, userInfo: [KeyConstants.kMessage: message])
//    } else {
//
//      let alert = UIAlertController.didShowOkAlert(withMessage: message)
////      guard let navigation = FunctionsConstants.kSharedAppDelegate.window?.rootViewController as? UINavigationController else {
////        guard let sideMenuC = FunctionsConstants.kSharedAppDelegate.window?.rootViewController as? SideMenuController else { return }
////        sideMenuC.present(alert, animated: true, completion: nil)
////        return
////      }
////      navigation.viewControllers.first?.present(alert, animated: true, completion: nil)
//    }
//  }
//
////  private func showLogoutAlert() {
////
////    FunctionsConstants.kSharedUserDefaults.clearAllData()
////    if #available(iOS 13.0, *) {
////
////      NotificationCenter.default.post(name: Notification.Name.showLogoutAlert, object: nil, userInfo: [KeyConstants.kMessage: AlertConstants.PLEASE_LOGIN_AGAIN])
////    } else {
////
////      let alert = UIAlertController.didShowOkAlert(withCancelVisibility: true, alertMessage: AlertConstants.PLEASE_LOGIN_AGAIN) {
////
////        FunctionsConstants.kSharedAppDelegate.showApplicableViewController()
////      }
////      guard let navigation = FunctionsConstants.kSharedAppDelegate.window?.rootViewController as? UINavigationController else {
////        guard let sideMenuC = FunctionsConstants.kSharedAppDelegate.window?.rootViewController as? SideMenuController else { return }
////        sideMenuC.present(alert, animated: true, completion: nil)
////        return
////      }
////      navigation.viewControllers.first?.present(alert, animated: true, completion: nil)
////    }
////  }
    private func showAlert(withMessage message: String) {

      if #available(iOS 13.0, *) {

        NotificationCenter.default.post(name: Notification.Name.showAlert, object: nil, userInfo: [KeyConstants.kMessage: message])
      } else {

        let alert = UIAlertController.didShowOkAlert(withMessage: message)
  //      guard let navigation = FunctionsConstants.kSharedAppDelegate.window?.rootViewController as? UINavigationController else {
  //        guard let sideMenuC = FunctionsConstants.kSharedAppDelegate.window?.rootViewController as? SideMenuController else { return }
  //        sideMenuC.present(alert, animated: true, completion: nil)
  //        return
  //      }
  //      navigation.viewControllers.first?.present(alert, animated: true, completion: nil)
      }
    }
}
//dev.neighbrsnook.com/admin/api/posting?flag=createpost
