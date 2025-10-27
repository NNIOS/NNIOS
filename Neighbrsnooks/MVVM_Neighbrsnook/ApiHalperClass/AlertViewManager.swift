//
//  Alerts.swift
//  Manish Mishra
//
//  Created by Manish on 6/17/21.
//  Copyright © 2021 Manish Mishra. All rights reserved.
//

import Foundation
import UIKit

class AlertViewManager{
    
    static let shared = AlertViewManager()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func alertWebServiceMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        appDelegate.window?.rootViewController?.present(alert, animated: true, completion: nil)

    }
    
    func alertMessage(title: String, message: String, controller: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        controller.present(alert, animated: true, completion: nil)
    }
    
    
    
    func alertMessageWithURL(title: String, message: String, url:String, controller: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let action = UIAlertAction(title: "Ok", style: .default) {  (result : UIAlertAction) -> Void in
            print("You pressed button")
            DispatchQueue.main.async {
                UIApplication.shared.open(URL(string: url)!, options: [:], completionHandler: nil)
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .default) {  (result : UIAlertAction) -> Void in
            print("You pressed button")
        }
        
        alert.addAction(action)
        alert.addAction(cancel)
        controller.present(alert, animated: true, completion: nil)

    }
    
    func alertMessageWithAction(title: String,controller: UIViewController, message: String, action:@escaping ()->()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let action = UIAlertAction(title: "Ok", style: .default) {  (result : UIAlertAction) -> Void in
            print("You pressed Upload")
            
            action()
            
        }
        alert.addAction(action)
       controller.present(alert, animated: true, completion: nil)

    }
    
    func updateApp(title: String, message: String,controller: UIViewController, action:@escaping ()->()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let action = UIAlertAction(title: "Update", style: .default) {  (result : UIAlertAction) -> Void in
            print("You pressed Update")
            
            action()
            
        }
        alert.addAction(action)
        
       controller.present(alert, animated: true, completion: nil)

    }
    
    func alertMessageWithActionAndCancel(title: String,controller: UIViewController, message: String, action:@escaping ()->()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let action = UIAlertAction(title: "Yes", style: .default) {  (result : UIAlertAction) -> Void in
            print("You pressed Upload")
            action()
        }
        let cancelBtn = UIAlertAction(title: "No", style: .default) {  (result : UIAlertAction) -> Void in
            print("You pressed Upload")
        }
        
        alert.addAction(cancelBtn)
        alert.addAction(action)

       controller.present(alert, animated: true, completion: nil)

    }
}

protocol galleryProtocol {
    func selectedItem(image : UIImage)
}
