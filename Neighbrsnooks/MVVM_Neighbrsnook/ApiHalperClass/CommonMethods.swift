//
//  CommonMethods.swift
//  Manish Mishra
//
//  Created by Manish Mishra on 10/09/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import UIKit
import Foundation
import SystemConfiguration
//import AAPickerView
import CoreData
import SwiftyJSON

class CommonMethods: NSObject {
    
    /**
     @developer: Manish Mishra
     @description: Method used for email validation
     @parameters:  (_ email: String)
     @returns:Bool
     */
    class func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    /**
     @developer: Manish Mishra
     @description: Method used for go to next controller
     @parameters:  (storyboard:UIStoryboard, identifier:String, navigation:UINavigationController)
     @returns:Nil
     */
    class func goToViewController(storyboard:UIStoryboard, identifier:String, navigation:UINavigationController) {
        let objVC = storyboard.instantiateViewController(withIdentifier: identifier)
        navigation.pushViewController(objVC, animated: true)
    }
    
    /**
     @developer: Manish Mishra
     @description: Method used for show alert message
     @parameters:  (title: String, message: String, view: UIViewController)
     @returns:Nil
     */
    class func showAlertMessage(title: String, message: String, view: UIViewController) {
        let objAlert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        //Create and an option action
        let nextAction: UIAlertAction = UIAlertAction(title: "OK", style: .cancel) { action -> Void in
            //Do some other stuff
        }
        objAlert.addAction(nextAction)
        view.present(objAlert, animated: true, completion: nil)
    }
    
    /**
     @developer: Manish Mishra
     @description: Method used for show alert message
     @parameters:  (title: String, message: String, view: UIViewController)
     @returns:Nil
     */
    class func showAlertMessageWithHandler(title: String, message: String, view: UIViewController, completion: @escaping () -> Void) {
        let objAlert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        //Create and an option action
        let nextAction: UIAlertAction = UIAlertAction(title: "OK", style: .cancel) { action -> Void in
            //Do some other stuff
            completion()
        }
        objAlert.addAction(nextAction)
        view.present(objAlert, animated: true, completion: nil)
    }
    
    /**
     @developer: Manish Mishra
     @description: Method used for show alert message
     @parameters:  (title: String, message: String, view: UIViewController)
     @returns:Nil
     */
    class func showAlertMessageWithOkAndCancel(title: String, message: String, view: UIViewController, completion: @escaping () -> Void) {
        let objAlert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        //Create and an option action
        let nextAction: UIAlertAction = UIAlertAction(title: "OK", style: .default) { action -> Void in
            //Do some other stuff
            completion()
        }
        let cancelActon: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            //Do some other stuff
        }
        
        objAlert.addAction(cancelActon)
        objAlert.addAction(nextAction)
        view.present(objAlert, animated: true, completion: nil)
    }
    
    /**
     @developer: Manish Mishra
     @description: Method used for show alert message
     @parameters:  (title: String, message: String, view: UIViewController)
     @returns:Nil
     */
    class func showAlertMessageWithLoginAndCancel(title: String, message: String, view: UIViewController, completion: @escaping () -> Void) {
        let objAlert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelActon: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            //Do some other stuff
        }
        //Create and an option action
        let nextAction: UIAlertAction = UIAlertAction(title: "Login", style: .default) { action -> Void in
            //Do some other stuff
            completion()
        }
        objAlert.addAction(nextAction)
        objAlert.addAction(cancelActon)
        view.present(objAlert, animated: true, completion: nil)
    }
    
    /**
     @developer: Manish Mishra
     @description: Method used for show alert message
     @parameters:  (title: String, message: String, view: UIViewController)
     @returns:Bool
     */
    class func isValidPassword(_ password: String) -> Bool {
        // least one uppercase,
        // least one digit
        // least one lowercase
        // least one symbol
        //  min 8 characters total
        let passwordRegx = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-15])(?=.*?[#?!@$%^&<>*~:`-]).{8,}$"
        let passwordCheck = NSPredicate(format: "SELF MATCHES %@",passwordRegx)
        return passwordCheck.evaluate(with: password)
        
    }
    
    /**
     @developer: Manish Mishra
     @description: This method will be used for Check Internet Connection.
     @parameter: Nil
     @returns:Bool value
     */
    //  MARK:-
    //  MARK:-  Check Internet Connection
    class func isInternetAvailable() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    
//    /**
//    @developer: Manish Mishra
//    @description: This method will be used for Date Picker
//    @parameter: (textField:AAPickerView)
//    @returns: Nil
//    */
//    class func configDatePicker(dateFormate:String ,textField:AAPickerView) {
//        textField.pickerType = .date
//        textField.datePicker?.datePickerMode = .date
//        textField.datePicker?.maximumDate = Date()
//        textField.dateFormatter.dateFormat =  dateFormate//"dd-MM-YYYY"
//        textField.valueDidSelected = { date in
//            print("selectedDate ", date as! Date )
//        }
//    }
    
    /*
     @description: Method used for to create UI for date picker
     @parameters:  datePicker
     @returns:strDate
     */
    class func createUiForDatePicker(datePicker: UIDatePicker) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/yyyy"
        let strDate = dateFormatter.string(from: datePicker.date)
        return strDate
    }
    
//    /**
//    @developer: Manish Mishra
//    @description: This method will be used for Date Picker
//    @parameter: (textField:AAPickerView)
//    @returns: Nil
//    */
//    class func configStringPicker(prefix:String, stringData:NSMutableArray ,textField:AAPickerView) {
//        textField.pickerType = .string(data: stringData as! [String])
//        textField.heightForRow = 40
////        textField.pickerRow.font = UIFont(name: "American Typewriter", size: 30)
//        textField.toolbar.barTintColor = .darkGray
//        textField.toolbar.tintColor = .black
//        textField.valueDidSelected = { (index) in
//            print("selectedString ", stringData[index as! Int])
//            textField.text = String(format: "%@%@",prefix, stringData[index as! Int] as! String)
//        }
//        textField.valueDidChange = { value in
//            print(value)
//        }
//    }
    
    class func convertTextIntoLink(linkText:String, text:String) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.link, value: linkText, range: NSRange(location: 19, length: 55))
        return attributedString
    }

    /*
     @developer: Manish Mishra
     @description: This method will used for clear core data.
     @parameter: (entity: String)
     @returns:nil
     */
    class func deleteAllData(entity: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try managedContext.fetch(fetchRequest)
            for managedObject in results {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
                try managedContext.save()
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    /*****-------***** Save Status *****-------*****/
    class func saveStatusForKey(status:Bool, forKey:String) {
        UserDefaults.standard.set(status, forKey: forKey)
        UserDefaults.standard.synchronize()
    }

    /*****-------***** Get Status *****-------*****/
    class func getStatusForKey(forKey:String) -> Bool{
        return UserDefaults.standard.bool(forKey:forKey)
    }
    
    /*****-------***** Save Value *****-------*****/
    class func saveValueForKey(value:String, forKey:String) {
        UserDefaults.standard.set(value, forKey: forKey)
        UserDefaults.standard.synchronize()
    }
    
    /*****-------***** Get Value *****-------*****/
    class func getValueForKey(key:String) -> String {
        return UserDefaults.standard.value(forKey: key) as? String ?? "0"
    }
    
    
    class func checkUnauthentication() {
        CommonMethods.deleteAllData(entity: "BL_Login")
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
//        sceneDel?.validateUserLoginOrNot()
    }
}


struct Constant {
    //MARK:- Screen Width/Height MACRO
    static let userDefaults = UserDefaults.standard

    static let SCREEN_WIDTH=UIScreen.main.bounds.width
    static let SCREEN_HEIGHT=UIScreen.main.bounds.height

    static let IPHONE_6 = UIScreen.main.preferredMode?.size.equalTo(CGSize(width: 750, height: 1334))
    static let IPHONE_6P = UIScreen.main.preferredMode?.size.equalTo(CGSize(width: 1242, height: 2208))
    static let IPHONE_7 = UIScreen.main.preferredMode?.size.equalTo(CGSize(width: 828, height: 1472))
    static let IPHONE_7P = UIScreen.main.preferredMode?.size.equalTo(CGSize(width: 750, height: 1334))
    static let IPHONE_5 = UIScreen.main.preferredMode?.size.equalTo(CGSize(width: 640, height: 1136))
    static let IPHONE_13 = UIScreen.main.preferredMode?.size.equalTo(CGSize(width: 1170, height: 2532))
    static let IS_LOWER_EQUAL_IPHONE_5 = (UIScreen.main.preferredMode?.size.height ?? 0 <= CGFloat(1136.0))
    static let IPHONE_4 = UIScreen.main.preferredMode?.size.equalTo(CGSize(width: 640, height: 960))
    static let IPHONE_4S = UIScreen.main.preferredMode?.size.equalTo(CGSize(width: 320.0, height: 480.0))
    static let appDelegate = (UIApplication.shared.delegate as? AppDelegate)
    static let IPAD = UI_USER_INTERFACE_IDIOM() == .pad //UIUserInterfaceIdiomPad
    static var IS_IPHONEX = (UI_USER_INTERFACE_IDIOM() == .phone && UIScreen.main.nativeBounds.height == 2436)//UIUserInterfaceIdiomPad
//    static let BOT_TAB_HEIGHT = CGFloat((IPAD || IS_IPHONEX ) ? 90.0 : 49.0)
    static var BOT_TAB_HEIGHT: CGFloat{
        if IPAD || IS_IPHONEX || (IPHONE_13 != nil) {
            return 80.0
        }else {
            return 60.0
        }
    }

    static var REAL_IPHONEX_TOP_HEIGHT : CGFloat = 30
    static var IPHONEX_TOP_HEIGHT : CGFloat = 0
    static var statusBarBannerHeight : CGFloat = Constant.IS_IPHONEX ? 70 : 40

    static let LOCAL_ENUS = Locale.init(identifier: "en_US")
    
    static let DefaultServerDateFormat          = "yyyy-MM-dd HH:mm:ssZ"// "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"//yyyy-MM-dd HH:mm:ss"
    
    static let NewDefaultServerDateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z"
    static let MediumDateFormat                 = "yyyy-MM-dd hh:mm:ss"
    static let ShortDateFormat                  = "yyyy/mm/dd"//"dd-MM-YYYY"//"YYYY-mm-dd"
    static let TimeFormat                       = "hh:mm a"
    static let ShortDateFormatInput             = "yyyy-MM-dd"//"YYYY-mm-dd"
    static let Time24Format                     = "HH:mm"
    static let NewsDateFormat                   = "MMM d, yyyy"//"dd MMM yyyy"
    static let NewDateFormate                   = "dd-mm-yyyy"
    


    static let tutorialKey                      = "tutorialKey"
    static let securityIdelTime                      = "securityIdelTime"
    static let activeSecurityKey                      = "isActiveSecurity"
    static let maxFaceTime : Double? = 180.0
//    static var maxIdleTime: Double? = Platform.isSimulator ? 90000000000: Constant.maxFaceTime
    
}

class MyDateFormatter : DateFormatter {
    static func shared() -> MyDateFormatter {
        MyDateFormatter.sharedInstance.timeZone = TimeZone(identifier:"GMT")!
        MyDateFormatter.sharedInstance.locale =  NSLocale(localeIdentifier: "en_US_POSIX") as Locale?

        return MyDateFormatter.sharedInstance
    }

    static let sharedInstance : MyDateFormatter = {
        let instance = MyDateFormatter.init()
        return instance
    }()

    func getStringFromServerDate(_ serverDate : String, dataFormat : String = Constant.DefaultServerDateFormat, outputFormat : String = Constant.NewsDateFormat) -> String? {

        self.dateFormat = dataFormat
        self.timeZone = TimeZone(identifier:"GMT")

        if let dt = self.date(from: serverDate) {
            self.timeZone = TimeZone.current
            self.dateFormat = outputFormat

            return self.string(from: dt)
        }

        return nil
    }

    func getNowDate(_ timeZone : TimeZone = TimeZone.current, outputFormat : String = Constant.DefaultServerDateFormat) -> String? {
        self.timeZone = timeZone
        self.dateFormat = outputFormat
        return self.string(from: Date())
    }
}
