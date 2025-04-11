import Foundation
@available(iOS 16.0, *)
extension UserDefaults {
  
  //MARK: - Properties -
  var isUserLoggedIn: Bool { return (self.getLoggedInUserDetails().isEmpty == false) }
  var accessToken: String { return "" }
  
//  var loggedInUserModel: LoginModel {
//
//    let userDict = self.getLoggedInUserDetails()
//    return LoginModel(userDict)
//  }
  
  func deviceToken() -> String {
    
    guard let token = FunctionsConstants.kSharedUserDefaults.string(forKey: KeyConstants.kDeviceToken) else {
      
      return "51654561561scnkjdsjkdnsr"
    }
    return token
  }
  
  func updateLoggedInUserDetails(forKey key: String, andUpdatedValue value: Any) {
    
    if let userData = self.data(forKey: KeyConstants.kUserDetails),var dictUser = (try? JSONSerialization.jsonObject(with: userData, options: .mutableContainers)) as? Dictionary<String, Any> {
      
      dictUser[key] = value
      setLoggedInUserDetails(loggedInUserDetails: dictUser)
    }
    self.synchronize()
  }
  
  //MARK: - Methods -
  func setLoggedInUserDetails(loggedInUserDetails dictUser: Dictionary<String, Any>) {
    
    if let userData = try? JSONSerialization.data(withJSONObject: dictUser, options: .prettyPrinted) {
      
      self.set(userData, forKey: KeyConstants.kUserDetails)
    }
    self.synchronize()
  }
  
  func getLoggedInUserDetails() -> Dictionary<String, Any> {
    
    if let userData = self.data(forKey: KeyConstants.kUserDetails),let dictUser = (try? JSONSerialization.jsonObject(with: userData, options: .mutableContainers)) as? Dictionary<String, Any> {
      
      return dictUser
    }
    return [:]
  }
  
  func clearAllData() -> Void {
    
    for (key, _) in self.dictionaryRepresentation() {
      
      if key != KeyConstants.kDeviceToken { self.removeObject(forKey: key) }
    }
    self.synchronize()
  }
}
