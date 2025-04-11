import Foundation
import UIKit

extension UIAlertController {
  
  static func didShowOkAlert(withMessage message: String) -> UIAlertController {
    
    let alert = UIAlertController(title: GeneralConstants.kAppName, message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: AlertConstants.OK, style: .cancel, handler: nil)
    alert.addAction(okAction)
    return alert
  }
  
  static func didShowOkAlert(withCancelVisibility isVisible: Bool, alertMessage message: String, andHandler handler:@escaping () -> Void) -> UIAlertController {
    
    let alert = UIAlertController(title: GeneralConstants.kAppName, message: message, preferredStyle: .alert)
    let okAction =  UIAlertAction(title: AlertConstants.OK, style: .default) { (action) -> Void in
      return handler()
    }
    alert.addAction(okAction)
    
    if isVisible {
      let cancelAction = UIAlertAction(title: AlertConstants.CANCEL, style: .cancel) { (action) -> Void in }
      alert.addAction(cancelAction)
    }
    
    return alert
  }
  
  static func didShowTextFieldAlert(withMessage strMessage: String, placeholderText placeholder: String, textFieldText text: String, andHandler handler:@escaping (_ text: String) -> Void) -> UIAlertController {
    
    let alert = UIAlertController(title: GeneralConstants.kAppName, message: strMessage, preferredStyle: .alert)
    alert.addTextField { (textField: UITextField) in
      textField.placeholder = placeholder
      textField.text = text
      textField.keyboardType = .numberPad
    }
    let okAction =  UIAlertAction(title: AlertConstants.SUBMIT, style: .default) { (action) -> Void in
      guard let textField = alert.textFields?.first else { return }
      return handler(String.getString(textField.text))
    }
    let cancelAction = UIAlertAction(title: AlertConstants.CANCEL, style: .cancel) { (action) -> Void in }
    alert.addAction(okAction)
    alert.addAction(cancelAction)
    return alert
  }
  
  static func didShowActionSheetStyleAlert(withTitle title: String?, alertMessage message: String?, selectionOptions options: [String], handler:@escaping (_ selectedIndex: Int) -> Void) -> UIAlertController {
    
    let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
    for option in options {
      
      let anyAction =  UIAlertAction(title: option, style: .default) { (action) -> Void in
        guard let selectedIndex = options.firstIndex(of: option) else { return handler(-1) }
        return handler(selectedIndex)
      }
      alert.addAction(anyAction)
    }
    
    let cancelAction = UIAlertAction(title:AlertConstants.CANCEL, style: .cancel) { (action) -> Void in
    }
    
    alert.addAction(cancelAction)
    return alert
  }
}
