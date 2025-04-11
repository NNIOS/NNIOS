import Foundation

extension Double {
  
  static func getDouble(_ value: Any?) -> Double {
    
    guard let doubleValue = value as? Double else {
      
      let strDouble = String.getString(value)
      guard let doubleValueOfString = Double(strDouble) else { return 0.0 }
      return doubleValueOfString
    }
    return doubleValue
  }
}

extension Double {
    func string(fractionDigits:Int) -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = fractionDigits
        formatter.maximumFractionDigits = fractionDigits
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
