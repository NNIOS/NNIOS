//
//  AlertAction.swift
//  Manish Mishra
//
//  Created by Manish on 6/17/21.
//  Copyright © 2021 Manish Mishra. All rights reserved.
//

import Foundation
import UIKit

public struct AlertAction {
    
    var text : String
    var style : UIAlertAction.Style = .default
    var actionHandler : (() -> ())?
    
    init(text : String, style : UIAlertAction.Style = .default, actionHandler : (() -> ())? = nil) {
        self.text = text
        self.style = style
        self.actionHandler = actionHandler
    }
    
}

//extension UIAlertController {
//    
//    class func showAlert(withTitle title : String, message : String, style : UIAlertController.Style, buttons : [AlertAction]) {
//        DispatchQueue.main.async {
//            DispatchQueue.main.async {
//                let alert = UIAlertController(title: title, message: message, preferredStyle: style)
//                for button in buttons {
//                    alert.addAction(UIAlertAction(title: button.text, style: button.style, handler: { (action) in
//                        button.actionHandler?()
//                    }))
//                }
//                if #available(iOS 13.0, *) {
//                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                    if var topController = appDelegate.window?.rootViewController {
////                    if var topController = UIApplication.shared.keyWindow?.rootViewController  {
//                        while let presentedViewController = topController.presentedViewController {
//                            topController = presentedViewController
//                        }
//                        topController.present(alert, animated: true, completion: nil)
//                    }
//                }else{
//                    let alertWindow = UIWindow(frame: UIScreen.main.bounds)
//                    alertWindow.rootViewController = UIViewController()
//                    alertWindow.windowLevel = UIWindow.Level.alert + 1
//                    alertWindow.makeKeyAndVisible()
//                    alertWindow.rootViewController?.present(alert, animated: true, completion: nil)
//                }
//            }
//        }
//    }
//}
