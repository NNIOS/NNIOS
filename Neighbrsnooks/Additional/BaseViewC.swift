//
//  BrainBlurbBaseViewC.swift
//  BrainBlurb
//
//  Created by MacBook 1 on 28/01/20.
//  Copyright © 2020 iDigitalWeb. All rights reserved.
//

import UIKit
//import Alamofire
import CoreLocation
import SVProgressHUD
//import PKHUD

class BaseViewC: UIViewController {
    
  var bounds = UIScreen.main.bounds
  var width : CGFloat?
  var fridayHeadings = ["Fajr","Sunrise","Jumu'ah","Asr","Maghrib","Isha"]
  //MARK:- --------------View Controller Life Cycle-------------- -
  override func viewDidLoad() {
    super.viewDidLoad()
     width = bounds.size.width
//      setBackgroundImage()
   // var height = bounds.size.height
   // var height = bounds.size.height
  }
  
  //MARK:- --------------UIAlertController-------------- -
  func showOkAlert(withMessage message: String) {
    
    let alert = UIAlertController.didShowOkAlert(withMessage: message)
    present(alert, animated: true, completion: nil)
  }
    
    func showAlert(Message: String) {
            let alert = UIAlertController(title: "", message: Message, preferredStyle: .alert)

            // Define the font and color attributes
            let messageFont = UIFont(name: "Montserrat-Regular", size: 18) ?? UIFont.systemFont(ofSize: 18, weight: .medium)
            let messageColor = UIColor(red: 0.36, green: 0.36, blue: 0.36, alpha: 1)
            let messageAttributes: [NSAttributedString.Key: Any] = [
                .font: messageFont,
                .foregroundColor: messageColor
            ]

            let messageAttrString = NSAttributedString(string: Message, attributes: messageAttributes)
            alert.setValue(messageAttrString, forKey: "attributedMessage")

            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))

            self.present(alert, animated: true, completion: nil)
            SVProgressHUD.dismiss()
        }

    
    private func setBackgroundImage() {
              let backgroundImage = UIImage(named: "WhatsApp Image 2024-05-29 at 5.00.19 PM")
              let imageView = UIImageView(frame: self.view.bounds)
              imageView.image = backgroundImage
              imageView.contentMode = .scaleAspectFill
              imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
              self.view.insertSubview(imageView, at: 0)
          }
  
  
  
  func showOkAlert(withMessage message: String, andHandler handler:@escaping () -> Void) {
    
    let alert = UIAlertController.didShowOkAlert(withCancelVisibility: false, alertMessage: message) {
      return handler()
    }
    present(alert, animated: true, completion: nil)
  }
  
  func showOkAndCancelAlert(withMessage message: String, andHandler handler:@escaping () -> Void) {
    
    let alert = UIAlertController.didShowOkAlert(withCancelVisibility: true, alertMessage: message) {
      return handler()
    }
    present(alert, animated: true, completion: nil)
  }
  
  func showTextFieldAlert(withMessage message: String, placeholderText placeholder: String, textFieldText text: String, andHandler handler:@escaping (_ string: String) -> Void) {
    
    let alert = UIAlertController.didShowTextFieldAlert(withMessage: message, placeholderText: placeholder, textFieldText: text) { (_ string: String) in
      return handler(string)
    }
    present(alert, animated: true, completion: nil)
  }
  
  func showActionSheetStyleAlert(withTitle title: String?, withAlertMessage message: String?, selectionOptions options: [String], handler:@escaping (_ selectedIndex: Int) -> Void) {
    
    let alert = UIAlertController.didShowActionSheetStyleAlert(withTitle: title, alertMessage: message, selectionOptions: options) { (_ selectedIndex: Int) in
      return handler(selectedIndex)
    }
    present(alert, animated: true, completion: nil)
  }
  
  func pushViewController(withName name: String, fromStoryboard storyboard: String) -> UIViewController {
    
    let storyboard = UIStoryboard.init(name: storyboard, bundle: nil)
    let viewController = storyboard.instantiateViewController(withIdentifier: name)
    self.navigationController?.pushViewController(viewController, animated: true)
    return viewController
  }
  
  func presentViewController(withName name: String, fromStoryboard storyboard: String) -> UIViewController {
    
    let storyboard = UIStoryboard.init(name: storyboard, bundle: nil)
    let viewController = storyboard.instantiateViewController(withIdentifier: name)
    self.present(viewController, animated: true, completion: nil)
    return viewController
  }
  
//  func getCurrentCountryCode() -> String {
//
//    let locale = Locale.current
//    let bundle = Bundle(for: LocalePickerViewController.self)
//    let path = "Countries.bundle/Data/CountryCodes"
//
//    guard let jsonPath = bundle.path(forResource: path, ofType: "json"), let jsonData = try? Data(contentsOf: URL(fileURLWithPath: jsonPath)) else { return "+1" }
//
//    if let jsonObjects = (try? JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments)) as? Array<Any> {
//      for jsonObject in jsonObjects {
//        guard let countryObj = jsonObject as? Dictionary<String, Any> else { continue }
//        if String.getString(countryObj["code"]) == String.getString(locale.regionCode) {
//          return String.getString(countryObj["dial_code"])
//        }
//      }
//    }
//    return "+1"
//  }
    
    func getAddressFromLatLon(latitude: Double, longitude: Double, handler completionBlock: @escaping (_ formattedAddress: String?,_ city: String?,_ zipcode: String?) -> ())  { // Call this function
        
        let geoCoder = CLGeocoder.init()
        geoCoder.reverseGeocodeLocation(CLLocation.init(latitude: latitude, longitude:longitude)) { (places, error) in
            if error == nil{
                let placeMark = places! as [CLPlacemark]
                
                if placeMark.count > 0 {
                    let placeMark = places![0]
                    var addressString : String = ""
                    var city: String = ""
                    var street: String = ""
                    var location: String = ""
                    var zip: String = ""
                    var state: String = ""
                    var streetAddress: String = ""
                    
                    if placeMark.subThoroughfare != nil {
                        addressString = addressString + placeMark.subThoroughfare! + ", "
                    }
                    if placeMark.thoroughfare != nil {
                       streetAddress = placeMark.thoroughfare! + ", "
                        addressString = addressString + placeMark.thoroughfare! + ", "
                    }
                    if placeMark.subLocality != nil {
                        
                        addressString = addressString + placeMark.subLocality! + ", "
                    }
                    
                    if placeMark.locality != nil {
                        city = placeMark.locality!
                        addressString = addressString + placeMark.locality! + ", "
                    }
                    if placeMark.administrativeArea != nil {
                        state = placeMark.administrativeArea! + ", "
                        addressString = addressString + placeMark.administrativeArea! + ", "
                    }
                    if placeMark.country != nil {
                        addressString = addressString + placeMark.country! + ", "
                    }
                    if placeMark.postalCode != nil {
                        zip = placeMark.postalCode! + " "
                        addressString = addressString + placeMark.postalCode! + " "
                    }
                    UserDefaults.standard.setValue(addressString, forKey: "FULLADDRESS")
                    print(addressString)
//                    self.location = addressString
//                    self.lblUpdateLocation.text = self.location
                    completionBlock(addressString, city ,zip)
                }
            }
        }
    }
    
  func getCurrentDay() -> String{
    let date = Date()
    let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
    let dayOfTheWeekString = dateFormatter.string(from: date)
    return dayOfTheWeekString
  }
    
  func currentTime() -> String{
    let date = Date()
    let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
    let time = formatter.string(from: date)
    return time
  }
    
    func currentTimeInString() -> String{
      let date = Date()
      let formatter = DateFormatter()
          formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
      let time = formatter.string(from: date)
      return time
    }
    
  func serverToLocal(date:String) -> Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
     dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    let localDate = dateFormatter.date(from: date)

    return localDate
  }
    
    func timeFromwebToApp(_ date: String) -> String {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
      dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
      let date = dateFormatter.date(from: date)
      dateFormatter.dateFormat = "h:mm a"
      dateFormatter.timeZone = TimeZone(abbreviation: "IST")
      return  dateFormatter.string(from: date ?? NSDate() as Date)
    }
 
    func openGoogleNavigation(currentlatitude:Double,currentLongitude:Double,destinationlatitude:Double,destinationLongitude:Double) {
        if UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!) {
            UIApplication.shared.open(URL.init(string: "comgooglemaps://?center=\(currentlatitude),\(currentLongitude)&zoom=14&views=traffic&q=\(destinationlatitude),\(destinationLongitude)")!, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.open(URL(string:
                "https://maps.google.com/?q=@\(destinationlatitude),\(destinationLongitude)")! as URL)
            
            
            print("Can't use comgooglemaps://")
        }
        
    }
    
//    func  dateFormateChange(apiDateFromate: String) -> String{
//
//      let apiString = String.getString(apiDateFromate)
//      let apiSubstring = apiString.prefix(19)
//      let apiDateString = String(apiSubstring)
//      let reqiuredDate = apiDateString.toDateString(inputDateFormat: "yyyy-MM-dd'T'HH:mm:ss", ouputDateFormat: "MMM d, yyyy")
//      return reqiuredDate
//    }
//
//
//    func  timeFormateChange(apiDateFromate: String) -> String{
//
//      let apiString = String.getString(apiDateFromate)
//      let apiSubstring = apiString.prefix(19)
//      let apiDateString = String(apiSubstring)
//
//      let reqiuredDate = apiDateString.toDateString(inputDateFormat: "yyyy-MM-dd'T'HH:mm:ss", ouputDateFormat: "h:mm a")
//
//      return reqiuredDate
//    }
    
    //  func  timeFormateChange(apiDateFromate: String) -> String{
    //
    //    let apiString = String.getString(apiDateFromate)
    //    let apiSubstring = apiString.prefix(19)
    //    let apiDateString = String(apiSubstring)
    //    let reqiuredDate = apiDateString.toDateString(inputDateFormat: "yyyy-MM-dd'T'HH:mm:ss", ouputDateFormat: "h:mm a")
    //    return reqiuredDate
    //  }
}

