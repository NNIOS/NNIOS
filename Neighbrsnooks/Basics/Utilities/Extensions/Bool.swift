import Foundation

extension Bool {
  
  static func getBool(_ value: Any?) -> Bool {
    
    guard let boolValue = value as? Bool else {
      
      let strBool = String.getString(value)
      guard let boolValueOfString = Bool(strBool) else {
        
        if strBool == "1" {
          
          return true
        } else {
          
          return false
        }
      }
      return boolValueOfString
    }
    return boolValue
  }
}

extension Data {
  
  var hexString: String {
    
    let hexString = map { String(format: "%02.2hhx", $0) }.joined()
    return hexString
  }
}

extension Array where Element: Equatable {

    func reorder(by preferredOrder: [Element]) -> [Element] {

        return self.sorted { (a, b) -> Bool in
            guard let first = preferredOrder.firstIndex(of: a) else {
                return false
            }

            guard let second = preferredOrder.firstIndex(of: b) else {
                return true
            }

            return first < second
        }
    }
}

extension Array where Element: Reorderable {

    func reorder(by preferredOrder: [Element.OrderElement]) -> [Element] {
        sorted {
            guard let first = preferredOrder.firstIndex(of: $0.orderElement) else {
                return false
            }

            guard let second = preferredOrder.firstIndex(of: $1.orderElement) else {
                return true
            }

            return first < second
        }
    }
}

protocol Reorderable {
    associatedtype OrderElement: Equatable
    var orderElement: OrderElement { get }
}
