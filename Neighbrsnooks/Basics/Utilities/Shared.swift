import Foundation
import UIKit

class Shared: NSObject {
  
  static let sharedInstance = Shared()
  private override init() {
  }
  
  func getArray(_ array: Any?) -> [Any] {
    
    guard let arr = array as? [Any] else { return [] }
    return arr
  }
  
  func getArray(withDictionary array: Any?) -> [Dictionary<String, Any>] {
    
    guard let arr = array as? [Dictionary<String, Any>] else { return [] }
    return arr
  }
  
  func getDictionary(_ dictData: Any?) -> Dictionary<String, Any> {
    
    guard let dict = dictData as? Dictionary<String, Any> else {
      
      guard let arr = dictData as? [Any] else { return ["":""] }
      return getDictionary(arr.count > 0 ? arr[0] : ["":""])
    }
    return dict
  }
  
  func getErrorMessage(_ dictResponse: Dictionary<String, Any>) -> String {
    
    if !String.getString(dictResponse[KeyConstants.kMessage]).isEmpty {
      
      return String.getString(dictResponse[KeyConstants.kMessage])
    } else {
      
      return "Something went wrong"
    }
  }
}
