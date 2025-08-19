import Foundation

extension String {
  
  // MARK:- ----------------Instance Methods----------
  // To Check Whether Email is valid
  func isEmail() -> Bool {
    
    let emailRegex: String = "[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}"
    let emailText = NSPredicate(format: "SELF MATCHES %@",emailRegex)
    return emailText.evaluate(with: self)
  }
  
  // To Check Whether Password is valid
  func isValidPassword() -> Bool {
    
    let passwordRegex: String = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
    let passwordText = NSPredicate(format: "SELF MATCHES %@",passwordRegex)
    return passwordText.evaluate(with: self)
  }
  
    
    func isValidEmail() -> Bool {
        let emailRegEx = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        
        guard emailTest.evaluate(with: self) else { return false }
        
        // Extra check: prevent double TLDs like `.com.com`, `.in.in`, etc.
        if let domain = self.split(separator: "@").last {
            let components = domain.split(separator: ".")
            if components.count >= 2 {
                let last = components.last
                let secondLast = components.dropLast().last
                if last == secondLast {
                    return false
                }
            }
        }
        
        return true
    }

  // To Check Whether String is valid or not
  func isValid() -> Bool {
    
    if self == "<null>" || self == "(null)"
    {
      return false
    }
    return true
  }
  
  // To Check Whether Name is valid
  func isName() -> Bool {
    
    let nameRegex = "[A-Za-z]{2,40}"
    let nameText  = NSPredicate(format:"SELF MATCHES %@", nameRegex)
    return nameText.evaluate(with: self)
  }
  
  // To Check Whether Phone Number is valid
  func isPhoneNumber() -> Bool {
    
    if self.isEmpty() {
      return false
    }
    let phoneRegex: String = "^\\d{4,13}$"
    let phoneText = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
    return phoneText.evaluate(with: self)
  }
  
  // To Check Whether URL is valid
  func isURL() -> Bool {
    
    let urlRegex: String = "(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+"
    let urlText = NSPredicate(format: "SELF MATCHES %@", urlRegex)
    let isValid = urlText.evaluate(with: self) as Bool
    return isValid
  }
  
  // To Check Whether Image URL is valid
  func isImageURL() -> Bool {
    
    if self.isURL() {
      
      if self.range(of: ".png") != nil || self.range(of: ".jpg") != nil || self.range(of: ".jpeg") != nil {
        
        return true
      }
    }
    return false
  }
  
  // To get length of String
  func length() -> Int {
    
    return self.stringByTrimmingWhiteSpaceAndNewLine().count
  }
  
  // To Check Whether String is empty
  func isEmpty() -> Bool {
    
    return self.stringByTrimmingWhiteSpace().count == 0 ? true : false
  }
  
  // Get string by removing White Space & New Line
  func stringByTrimmingWhiteSpaceAndNewLine() -> String {
    
    return self.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
  }
  
  // Get string by removing White Space
  func stringByTrimmingWhiteSpace() -> String {
    
    return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
  }
  
  // Remove Substring from a string
  mutating func removeSubString(subString: String) -> String {
    
    if self.contains(subString) {
      guard let stringRange = self.range(of: subString) else { return self }
      return self.replacingCharacters(in: stringRange, with: "")
    }
    return self
  }
  
  //TODO:- ----------------This function is incomplete----------------
  // Get Substring between a range
  func getSubStringFrom(begin: NSInteger, to end: NSInteger) -> String {
    
    //var strRange = begin..<end
    //let str = self.substringWithRange(strRange)
    return ""
  }
  
  //MARK:- ----------------Static Methods----------
  static func getString(_ message: Any?) -> String {
    
    guard let strMessage = message as? String else {
      guard let doubleValue = message as? Double else {
        guard let intValue = message as? Int else {
          guard let int64Value = message as? Int64 else {
            return ""
          }
          return String(int64Value)
        }
        return String(intValue)
      }
      
      let formatter = NumberFormatter()
      formatter.minimumFractionDigits = 0
      formatter.maximumFractionDigits = 6
      formatter.minimumIntegerDigits = 1
      guard let formattedNumber = formatter.string(from: NSNumber(value: doubleValue)) else {
        return ""
      }
      return formattedNumber
    }
    return strMessage.stringByTrimmingWhiteSpaceAndNewLine()
  }
  
  static func random(length: Int = 8) -> String {
    
    let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    var randomString: String = ""
    
    for _ in 0..<length {
      let randomValue = arc4random_uniform(UInt32(base.count))
      randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
    }
    return randomString
  }
  
  /*
   // To check whether String contains Only Letters
   func stringContainsOnlyLetters() -> Bool
   {
   let characterSet = NSCharacterSet.letterCharacterSet()
   return self.rangeOfCharacterFromSet(characterSet) != nil ? true : false
   }
   
   // To check whether String contains Only Numbers
   func stringContainsOnlyNumbers() -> Bool
   {
   let characterSet = NSCharacterSet.decimalDigitCharacterSet()
   return self.rangeOfCharacterFromSet(characterSet) != nil ? true : false
   }
   */
}

//extension String {
//    var decodeEmoji: String{
//        let data = self.data(using: String.Encoding.utf8);
//        let decodedStr = NSString(data: data!, encoding: String.Encoding.nonLossyASCII.rawValue)
//        if let str = decodedStr{
//            return str as String
//        }
//        return self
//    }
//}

extension String {
    var encodeEmoji: String{
        if let encodeStr = NSString(cString: self.cString(using: .nonLossyASCII)!, encoding: String.Encoding.utf8.rawValue){
            return encodeStr as String
        }
        return self
    }
}
