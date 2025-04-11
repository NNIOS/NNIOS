import Foundation
import UIKit

extension UIViewController {
  
  static func id() -> String {
    
    return String(describing: self)
  }
  
  static func segueIdentifier() -> String {
    
    return "show" + String(describing: self)
  }
}
