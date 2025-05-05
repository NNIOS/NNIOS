//
//  BaseViewController.swift
//  PicknDropPOS
//
//  Created by Faiz MacBook Pro on 14/04/21.
//  Copyright ©️ 2021 Qanvus Technologies Private Limited. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire

@available(iOS 16.0, *)
class BaseViewController: UIViewController, BottomPanelDelegate {
    
    let mainViewS = UIView()
    
    func updateTabAppearance(selectedIndex: Int) {
        
    }
    
    
    private let bottomPanel = BottomPanelView()
    private var isButtonTapInProgress = false // Flag to prevent multiple taps
    var selectedTabIndex: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        statusBarColorChange()
      //  setBackgroundImage()
        
        
//        let safeArea = view.safeAreaLayoutGuide
//        view.addSubview(mainViewS)
//        mainViewS.translatesAutoresizingMaskIntoConstraints = false
//       
//         NSLayoutConstraint.activate([
//            mainViewS.topAnchor.constraint(equalTo: safeArea.topAnchor),
//            mainViewS.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
//            mainViewS.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
//            mainViewS.heightAnchor.constraint(equalToConstant: 50)
//        ])

        
    }
    
    private func setupBottomPanel() {
            bottomPanel.delegate = self
            view.addSubview(bottomPanel)
            bottomPanel.translatesAutoresizingMaskIntoConstraints = false
            
        NSLayoutConstraint.activate([
            bottomPanel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomPanel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomPanel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -5), // Moves it downward
            bottomPanel.heightAnchor.constraint(equalToConstant: 70)
        ])

        }
    
    func didTapButton(at index: Int) {
        // Prevent multiple taps
        guard !isButtonTapInProgress else { return }
        isButtonTapInProgress = true

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        var viewController: UIViewController?

        switch index {
        case 0:
            if let vc = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController {
                vc.selectedTabIndex = index
                viewController = vc
            }
        case 1:
            if let vc = storyboard.instantiateViewController(withIdentifier: "DirectMessageViewController") as? DirectMessageViewController {
                vc.selectedTabIndex = index
                viewController = vc
            }
        case 2:
            if let vc = storyboard.instantiateViewController(withIdentifier: "FavoriteViewController") as? FavoriteViewController {
                vc.selectedTabIndex = index
                viewController = vc
            }
        case 3:
            if let vc = storyboard.instantiateViewController(withIdentifier: "NotificationViewController") as? NotificationViewController {
                vc.selectedTabIndex = index
                viewController = vc
            }
        case 4:
            if let vc = storyboard.instantiateViewController(withIdentifier: "HomeMarketViewController") as? HomeMarketViewController {
                vc.selectedTabIndex = index
                viewController = vc
            }
        default:
            isButtonTapInProgress = false // Reset the flag if no view controller is found
            return
        }

        if let vc = viewController {
            self.navigationController?.pushViewController(vc, animated: true)
            
            // Re-enable button tap after navigation
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.isButtonTapInProgress = false
            }
        } else {
            isButtonTapInProgress = false // Reset the flag if navigation fails
        }
    }





    
    private func setBackgroundImage() {
              let backgroundImage = UIImage(named: "WhatsApp Image 2024-05-29 at 5.00.19 PM")
              let imageView = UIImageView(frame: self.view.bounds)
              imageView.image = backgroundImage
              imageView.contentMode = .scaleAspectFill
              imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
              self.view.insertSubview(imageView, at: 0)
          }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
    }
    
    func showAlert(Message:String){

        let alert = UIAlertController (title: "", message: Message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ (alertOKAction) in }))
        self.present(alert, animated: true, completion: nil)
        SVProgressHUD.dismiss()
    }
//
    func validatePANCardNumber(_ strPANNumber : String) -> Bool{
        let regularExpression = "[A-Z]{5}[0-9]{4}[A-Z]{1}"
        let panCardValidation = NSPredicate(format : "SELF MATCHES %@", regularExpression)
        return panCardValidation.evaluate(with: strPANNumber)
    }
    
    func addViewShadow(view: UIView){
        view.layer.shadowColor = UIColor(red:154/255, green:154/255, blue:154/255, alpha:1).cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1.75)
        view.layer.shadowRadius = 1.7
        view.layer.shadowOpacity = 0.45
    }
    
//    func showAlertOk(Message:String,type: Int){
//
//        let alert = UIAlertController.init(title: BaseUrl.shared.projectName, message: Message, preferredStyle: .alert)
//
//        let yes = UIAlertAction(title: "Ok", style: .default) { (aelrt) in
//
//            if type == 1
//            {
//                let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//                self.navigationController?.pushViewController(vc, animated: true)
//            }
//            else if type == 2
//            {
//                let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateWithdrawalPinViewController") as! CreateWithdrawalPinViewController
//                self.navigationController?.pushViewController(vc, animated: true)
//            }
//            else if type == 3
//            {
//                appDelegate.pushToHomeViewContoller()
//            }
//            else
//            {
//                self.navigationController?.popViewController(animated: true)
//            }
//
//        }
//        alert.addAction(yes)
//
//        self.present(alert, animated: true)
//
//        SVProgressHUD.dismiss()
//    }
    
    func popThisView() {
        self.dismiss(animated: false, completion: nil)
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func isValidPassword(testStr:String?) -> Bool {
        guard testStr != nil else { return false }
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}")
        return passwordTest.evaluate(with: testStr)
    }
    
    func removeLastViewController()
    {
        guard let navigationController = self.navigationController else { return }
        var navigationArray = navigationController.viewControllers // To get all UIViewController stack as Array
        navigationArray.remove(at: navigationArray.count - 1) // To remove previous UIViewController
        self.navigationController?.viewControllers = navigationArray
    }
    
    func findDateDiff(time1Str: String, time2Str: String) -> Bool {
        let timeformatter = DateFormatter()
        timeformatter.dateFormat = "HH:mm:ss"

        guard let time1 = timeformatter.date(from: time1Str),
            let time2 = timeformatter.date(from: time2Str) else { return false }

        //You can directly use from here if you have two dates

        let interval = time2.timeIntervalSince(time1)
        let hour = interval / 3600;
        let minute = interval.truncatingRemainder(dividingBy: 3600) / 60
        let intervalInt = Int(interval)
        //return "\(intervalInt < 0 ? "-" : "+") \(Int(hour)) Hours \(Int(minute)) Minutes"
        
        debugPrint("\(intervalInt < 0 ? "-" : "+") \(Int(hour)) Hours \(Int(minute)) Minutes")
        
        if(Int(hour)>0)
        {
            return true
        }
        else if(Int(minute)<=0) //<60)
        {
            return false
        }
        else
        {
            return true
        }
    }
    
    func findTimeDiff(time1Str: String, time2Str: String) -> String {
        let timeformatter = DateFormatter()
        timeformatter.dateFormat = "hh:mm:ss"

        debugPrint("time1Str - ",time1Str)
        debugPrint("time2Str - ",time2Str)
        
        guard let time1 = timeformatter.date(from: time1Str),
            let time2 = timeformatter.date(from: time2Str) else { return "error" }

        //You can directly use from here if you have two dates

        let interval = time2.timeIntervalSince(time1)
        let hour = interval / 3600;
        let minute = interval.truncatingRemainder(dividingBy: 3600) / 60
        let intervalInt = Int(interval)
        debugPrint("\(Int(hour)) Hours \(Int(minute)) Minutes")
        
        var result : String = ""
        
        if minute == 0
        {
            result = "\(Int(hour)) hrs"
        }
        else
        {
            result = "\(Int(hour)) hrs \(Int(minute)) mins"
        }
        
        //let result : String = "\(Int(hour)) hrs \(Int(minute)) mins"
        
        debugPrint("result - ",result)
        
        return result
    }
    
    func findTimeNewDiff(time1Str: String, time2Str: String) -> String {
        let timeformatter = DateFormatter()
        timeformatter.dateFormat = "HH:mm:ss"

        debugPrint("time1Str - ",time1Str)
        debugPrint("time2Str - ",time2Str)
        
        guard let time1 = timeformatter.date(from: time1Str),
            let time2 = timeformatter.date(from: time2Str) else { return "error" }

        //You can directly use from here if you have two dates

        let interval = time2.timeIntervalSince(time1)
        let hour = interval / 3600;
        let minute = interval.truncatingRemainder(dividingBy: 3600) / 60
        let intervalInt = Int(interval)
        debugPrint("\(Int(hour)) Hours \(Int(minute)) Minutes")
        
        var result : String = ""
        
        if minute == 0
        {
            result = "\(Int(hour)) hrs"
        }
        else
        {
            result = "\(Int(hour)) hrs \(Int(minute)) mins"
        }
        
        //let result : String = "\(Int(hour)) hrs \(Int(minute)) mins"
        
        debugPrint("result - ",result)
        
        return result

    }
    
    func returnTimeDiff(time1Str: String, time2Str: String) -> Bool {
        let timeformatter = DateFormatter()
        timeformatter.dateFormat = "HH:mm:ss"

        guard let time1 = timeformatter.date(from: time1Str),
            let time2 = timeformatter.date(from: time2Str) else { return false }

        //You can directly use from here if you have two dates

        let interval = time2.timeIntervalSince(time1)
        let hour = interval / 3600;
        let minute = interval.truncatingRemainder(dividingBy: 3600) / 60
        let intervalInt = Int(interval)
        //return "\(intervalInt < 0 ? "-" : "+") \(Int(hour)) Hours \(Int(minute)) Minutes"
        
        debugPrint("\(intervalInt < 0 ? "-" : "+") \(Int(hour)) Hours \(Int(minute)) Minutes")
        
        if(Int(hour)>0)
        {
            return true
        }
        else if(Int(minute)<60)
        {
            return false
        }
        else
        {
            return true
        }
    }
    
    func isTimeIsInMinus(time1Str: String, time2Str: String) -> Bool {
        let timeformatter = DateFormatter()
        timeformatter.dateFormat = "HH:mm:ss"

        guard let time1 = timeformatter.date(from: time1Str),
            let time2 = timeformatter.date(from: time2Str) else { return false }

        //You can directly use from here if you have two dates

        let interval = time2.timeIntervalSince(time1)
        let hour = interval / 3600;
        let minute = interval.truncatingRemainder(dividingBy: 3600) / 60
        let intervalInt = Int(interval)
        //return "\(intervalInt < 0 ? "-" : "+") \(Int(hour)) Hours \(Int(minute)) Minutes"
        
        debugPrint("\(intervalInt < 0 ? "-" : "+") \(Int(hour)) Hours \(Int(minute)) Minutes")
        
        if(Int(hour)>0)
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    
    func dateTimeChangeFormat(str stringWithDate: String, inDateFormat: String, outDateFormat: String) -> String {
        let inFormatter = DateFormatter()
        inFormatter.locale = Locale(identifier: "en_US_POSIX")
        inFormatter.dateFormat = inDateFormat

        let outFormatter = DateFormatter()
        outFormatter.locale = Locale(identifier: "en_US_POSIX")
        outFormatter.dateFormat = outDateFormat

        let inStr = stringWithDate
        let date = inFormatter.date(from: inStr)!
        return outFormatter.string(from: date)
    }
    
    func changeDateFormat(stringDate : String) -> String
    {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd/MM/yyyy"

        if let date = dateFormatterGet.date(from: stringDate) {
            print("date formatted - ",dateFormatterPrint.string(from: date))
            return String(dateFormatterPrint.string(from: date))
        } else {
           print("There was an error decoding the string")
            return stringDate
        }
    }
    
    func changeTimeFormat(stringTimne : String) -> String
    {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "HH:mm:ss"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "hh:mm aa"

        if let date = dateFormatterGet.date(from: stringTimne) {
            print("date formatted - ",dateFormatterPrint.string(from: date))
            return String(dateFormatterPrint.string(from: date))
        } else {
           print("There was an error decoding the string")
            return stringTimne
        }
    }
    
    func changeDateTimeFormat(stringDate : String) -> String
    {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SS'Z'"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd-MM-yyyy"

        if let date = dateFormatterGet.date(from: stringDate) {
            print("date formatted - ",dateFormatterPrint.string(from: date))
            return String(dateFormatterPrint.string(from: date))
        } else {
           print("There was an error decoding the string")
            return stringDate
        }
    }
    
    func changeDateFormatNew(stringDate : String) -> String
    {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMMM dd,yyyy"

        if let date = dateFormatterGet.date(from: stringDate) {
            print("date formatted - ",dateFormatterPrint.string(from: date))
            return String(dateFormatterPrint.string(from: date))
        } else {
           print("There was an error decoding the string")
            return stringDate
        }
    }
    
    func changeDateFormatDash(stringDate : String) -> String
    {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd hh:mm:ss aa"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd-MMM-yy hh:mm aa"

        if let date = dateFormatterGet.date(from: stringDate) {
            print("date formatted - ",dateFormatterPrint.string(from: date))
            return String(dateFormatterPrint.string(from: date))
        } else {
           print("There was an error decoding the string")
            return stringDate
        }
    }
    
    func setButtonShadow(btn: UIButton) {
        
        btn.layer.shadowRadius = 10
        btn.layer.shadowOffset = .zero
        btn.layer.shadowOpacity = 0.2
        btn.layer.shadowColor = UIColor.lightGray.cgColor

    }
    
    func setViewShadow(view: UIView) {
        
        view.layer.shadowRadius = 10
        view.layer.shadowOffset = .zero
        view.layer.shadowOpacity = 0.2
        view.layer.shadowColor = UIColor.lightGray.cgColor

    }
    
    func setImageShadow(image: UIImageView) {
        
        image.layer.shadowRadius = 10
        image.layer.shadowOffset = .zero
        image.layer.shadowOpacity = 0.2
        image.layer.shadowColor = UIColor.lightGray.cgColor

    }
    
    func roundPriceDouble(price : Double) -> String
    {
        var result = ""
        
        let x = price
        let y = Double(round(10000*x)/1000000)
        print(y)  // 1.236
        
        result = String(y)
        
        return result
    }
    
    func rupeeSymbol() -> String
    {
        return "₹"
    }
    
    func dollarSymbol() -> String
    {
        return "$"
    }
    
    func roundPrice(price : Double) -> Double
    {
        let result = String(format: "%.2f", price)
        debugPrint("result : ",result)
        
        return Double(result)!
    }
    
    func round6Price(price : Double) -> String
    {
        let result = String(format: "%.6f", price)
        debugPrint("result : ",result)
        
        return result
    }

    func round2Price(price : Double) -> String
    {
        let result = String(format: "%.2f", price)
        debugPrint("result : ",result)
        
        return result
    }
    
  
    
    //MARK: - -------------------------    get Device info Irshad malik --------------------/
    
    func getDeviceInfo() -> (deviceModel: String, deviceIMEI: String, devicePlatform: String, deviceID: String) {
        let device = UIDevice.current
        
        // Operating system name (e.g., "iOS")
        let systemName = device.systemName
        
        // Unique device identifier (UUID)
        let uuid = device.identifierForVendor?.uuidString ?? "N/A"
        
        // Get specific model name
        let modelName = getDeviceModelName()
        
        return (deviceModel: modelName, deviceIMEI: uuid, devicePlatform: systemName, deviceID: uuid)
    }
    
    // Helper function to get the specific model name using hardware identifier
    func getDeviceModelName() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let modelCode = withUnsafePointer(to: &systemInfo.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                String(validatingUTF8: $0)
            }
        }
        
        // Mapping of model codes to specific iPhone models (only some examples shown here)
        let modelMap: [String: String] = [
            "iPhone14,2": "iPhone 13 Pro",
            "iPhone14,3": "iPhone 13 Pro Max",
            "iPhone13,4": "iPhone 12 Pro Max",
            "iPhone13,3": "iPhone 12 Pro",
            // Add more models here as needed
        ]
        
        if let modelName = modelMap[modelCode ?? ""] {
            return modelName
        } else {
            return modelCode ?? "Unknown iPhone"
        }
    }
    
    
}

extension UIViewController {
    
    func statusBarColorChange() {

      if #available(iOS 13.0, *) {

          let statusBar = UIView(frame: UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
          statusBar.backgroundColor = UIColor.init(named: "AccentColor")
              statusBar.tag = 100
          UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.addSubview(statusBar)

      } else {

              let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
              statusBar?.backgroundColor = UIColor.init(named: "AccentColor")

        }
    }
    
    func statusBarLightColorChange() {

        if #available(iOS 13.0, *) {

            let statusBar = UIView(frame: UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
            statusBar.backgroundColor = UIColor.white
                statusBar.tag = 100
            UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.addSubview(statusBar)

        } else {

                let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
                statusBar?.backgroundColor = UIColor.white

          }
     }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)

    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func configureNavigationBar(backgoundColor: UIColor, tintColor: UIColor, preferredLargeTitle: Bool) {
        if #available(iOS 13.0, *) {
            
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.backgroundColor = backgoundColor

            navigationController?.navigationBar.standardAppearance = navBarAppearance
            navigationController?.navigationBar.compactAppearance = navBarAppearance
            navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance

            navigationController?.navigationBar.prefersLargeTitles = preferredLargeTitle
            navigationController?.navigationBar.isTranslucent = true
            navigationController?.navigationBar.tintColor = tintColor
            navigationItem.title = title

        } else {
            // Fallback on earlier versions
            navigationController?.navigationBar.barTintColor = backgoundColor
            navigationController?.navigationBar.tintColor = tintColor
            navigationController?.navigationBar.isTranslucent = true
            navigationItem.title = title
        }
    }
    
}

extension UIView {
    
    func applyGradientVertical(isVertical: Bool, colorArray: [UIColor]) {
        layer.sublayers?.filter({ $0 is CAGradientLayer }).forEach({ $0.removeFromSuperlayer() })
         
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colorArray.map({ $0.cgColor })
        if isVertical {
            //top to bottom
            gradientLayer.locations = [0.0, 1.0]
        } else {
            //left to right
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        }
        
        backgroundColor = .clear
        gradientLayer.frame = bounds
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func roundNewCorners(with CACornerMask: CACornerMask, radius: CGFloat) {
              self.layer.cornerRadius = radius
              self.layer.maskedCorners = [CACornerMask]
        }
    
}

extension UIImage {
    func fixOrientation() -> UIImage {
        if self.imageOrientation == UIImage.Orientation.up {
            return self
        }
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        if let normalizedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            return normalizedImage
        } else {
            return self
        }
    }
}


extension Date {

 static func getCurrentDate() -> String {

        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "dd/MM/yyyy"

        return dateFormatter.string(from: Date())

    }
}

extension UIImage {
    /// Fix image orientaton to protrait up
    func fixedOrientation() -> UIImage? {
        guard imageOrientation != UIImage.Orientation.up else {
            // This is default orientation, don't need to do anything
            return self.copy() as? UIImage
        }

        guard let cgImage = self.cgImage else {
            // CGImage is not available
            return nil
        }

        guard let colorSpace = cgImage.colorSpace, let ctx = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else {
            return nil // Not able to create CGContext
        }

        var transform: CGAffineTransform = CGAffineTransform.identity

        switch imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: CGFloat.pi)
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: CGFloat.pi / 2.0)
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: CGFloat.pi / -2.0)
        case .up, .upMirrored:
            break
        @unknown default:
            fatalError("Missing...")
            break
        }

        // Flip image one more time if needed to, this is to prevent flipped image
        switch imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .up, .down, .left, .right:
            break
        @unknown default:
            fatalError("Missing...")
            break
        }

        ctx.concatenate(transform)

        switch imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
        default:
            ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            break
        }

        guard let newCGImage = ctx.makeImage() else { return nil }
        return UIImage.init(cgImage: newCGImage, scale: 1, orientation: .up)
    }
    
}

extension UITextField {
    
    func addUnderLine () {
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRect(x: 0.0, y: self.bounds.height + 3, width: self.bounds.width, height: 1.5)
        bottomLine.backgroundColor = UIColor.lightGray.cgColor
        
        self.borderStyle = UITextField.BorderStyle.none
        self.layer.addSublayer(bottomLine)
    }
    
}

struct Platform {
    static var isSimulator: Bool {
        #if targetEnvironment(simulator)
            // We're on the simulator
            return true
        #else
            // We're on a device
             return false
        #endif
    }
}

// Configure side menu presentation
//            menuVC.modalPresentationStyle = .overFullScreen
//            menuVC.view.backgroundColor = UIColor.black.withAlphaComponent(0.5) // Optional dimmed background
//
//            // Set initial frame for side menu
//            menuVC.view.frame = CGRect(x: UIScreen.main.bounds.width, y: 0, width: UIScreen.main.bounds.width * 0.75, height: UIScreen.main.bounds.height)
//
//            // Present side menu with animation
//            self.present(menuVC, animated: false) {
//                UIView.animate(withDuration: 0.3) {
//                    menuVC.view.frame.origin.x = UIScreen.main.bounds.width * 0.25
//                }
//            }



//case 4:
//    if let vc = storyboard.instantiateViewController(withIdentifier: "MenuBottomViewController") as? MenuBottomViewController {
//        vc.selectedTabIndex = index
//        viewController = vc


