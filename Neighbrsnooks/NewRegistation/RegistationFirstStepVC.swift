//
//  RegistationFirstStepVC.swift
//  Neighbrsnooks
//
//  Created by Irshad Malik on 02/08/25.
//

import UIKit
import Kingfisher
import SVProgressHUD
import FirebaseMessaging
import Alamofire
import CoreLocation

class RegistationFirstStepVC: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var fullNameTF: CustomLabelFirstName!
    @IBOutlet weak var phoneNumberTF: CustomLabelFirstName!
    @IBOutlet weak var lblTimer: UILabel!
    @IBOutlet weak var firstOtpTF: CustomLabelFirstName!
    @IBOutlet weak var secondOtpTF: CustomLabelFirstName!
    @IBOutlet weak var thirdOtpTF: CustomLabelFirstName!
    @IBOutlet weak var fourthOtpTF: CustomLabelFirstName!
    @IBOutlet weak var fifthOtpTF: CustomLabelFirstName!
    @IBOutlet weak var sixthOtpTF: CustomLabelFirstName!
    @IBOutlet weak var emailTF: CustomLabelFirstName!
    @IBOutlet weak var passwordTF: CustomLabelFirstName!
    @IBOutlet weak var btnCheck: UIButton!
    @IBOutlet weak var lblTerms: CustomLabelHeadingname!
    @IBOutlet weak var checkImage: UIImageView!
    @IBOutlet weak var btnGetOTP: UIButton!
    @IBOutlet weak var lblStrong: CustomLabel!
    @IBOutlet weak var otpView: UIView!
    @IBOutlet weak var otpViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var otpTopHeightConst: NSLayoutConstraint!
    @IBOutlet weak var otpBottomHeightConst: NSLayoutConstraint!
    
    // MARK: - Variables
    
    var id: String?
    var counter = 60
    var isTerm: String?
    var timer = Timer()
    var isFirstTimeOtp = true
    var SendOTPData: OtpModel?
    var currentLatitude: Double?
    var currentLongitude: Double?
    var isOTPVerified: Bool = false
    var registerData : RegisterModel?
    var loadingAlert: UIAlertController?
    var objVerifyEmail: VerifyEmailModel?
    let locationManager = CLLocationManager()
    var otpFields: [CustomLabelFirstName] = []
    var isVerifyingOTP = false

    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setDelegate()
        setupNotificationPermission()
        for field in otpFields {
            field.textContentType = .oneTimeCode
            field.keyboardType = .numberPad
            field.isSecureTextEntry = false
        }

        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateScrollViewScrollability()
    }
    
    // MARK: - Button's Action
    @IBAction func btnGetOtpAction(_ sender: UIButton) { // self.callOTPWebService {}
        
        if phoneNumberTF.text == "" {
            showAlert(title: "", message: "Please enter your number");
        } else {
            callOTPWebService {
                let successAlert = UIAlertController(title: "", message: "OTP has been sent", preferredStyle: .alert)
                self.present(successAlert, animated: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    successAlert.dismiss(animated: true, completion: {
                        self.firstOtpTF.becomeFirstResponder()
                    })
                }
                self.otpCounterAndResendButton()
                if self.isFirstTimeOtp {
                    self.btnGetOTP.setTitle("Resend OTP", for: .normal)
                    self.isFirstTimeOtp = false
                }
            }
        }
    }
    
    @IBAction func btnNextAction(_ sender: CustomButtonClick) {
        validation()
    }
    
    @IBAction func btnAlradyAccountAction(_ sender: CustomButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnHideShowPassAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            passwordTF.isSecureTextEntry = true
            sender.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        } else {
            passwordTF.isSecureTextEntry = false
            sender.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        }
    }
    
    @IBAction func checkTermsConditionAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            isTerm = "1"
            print("term is: \(isTerm ?? "")")
            btnCheck.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
        } else {
            isTerm = "0"
            print("term is: \(isTerm ?? "")")
            btnCheck.setImage(UIImage(systemName: "square"), for: .normal)
        }
    }
}

// MARK: - extension for UITextFieldDelegate

extension RegistationFirstStepVC : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let isDeleting = string.isEmpty

        // ✅ Handle AutoFill or Paste
        if string.count > 1 {
            DispatchQueue.main.async {
                self.fillOTPFields(with: string)
            }
            return false
        }

        // ✅ Normal typing logic
        if let index = otpFields.firstIndex(of: textField as! CustomLabelFirstName) {
            if isDeleting {
                textField.text = ""
                if index > 0 {
                    otpFields[index - 1].becomeFirstResponder()
                }
            } else {
                textField.text = string
                if index < otpFields.count - 1 {
                    otpFields[index + 1].becomeFirstResponder()
                } else {
                    textField.resignFirstResponder()
                }
            }
        }

        // ✅ Check OTP completion
        DispatchQueue.main.async {
            self.checkOTPCompletion()
        }

        return false
    }

    private func fillOTPFields(with otp: String) {
        otpFields.forEach { $0.text = "" } // Clear all first
        for (i, char) in otp.enumerated() where i < otpFields.count {
            otpFields[i].text = String(char)
        }
        otpFields.last?.resignFirstResponder()
        checkOTPCompletion()
    }

    private func checkOTPCompletion() {
        let enteredOTP = otpFields.compactMap { $0.text }.joined()
        if enteredOTP.count == otpFields.count && !isVerifyingOTP {
            isVerifyingOTP = true
            verifyOTP(enteredOTP)
        }
    }


    private func verifyOTP(_ otp: String) {
        self.callVerifyOTPWebService(userOTP: otp) { success, message in
            DispatchQueue.main.async {
                self.isVerifyingOTP = false // ✅ Reset flag after response
                self.checkImage.isHidden = false
                self.checkImage.image = UIImage(named: success ? "check" : "CrossOtp")
                self.showAutoDismissAlert(message: success ? "Code Matched successfully." : "Code does not match.")
            }
        }
    }


    
    
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        guard let currentText = textField.text else { return false }
//        let isDeleting = string.isEmpty
//        
//        if !isDeleting && currentText.count >= 1 {
//            return false
//        }
//        if let typedField = textField as? CustomLabelFirstName,
//           let index = otpFields.firstIndex(of: typedField) {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
//                if isDeleting {
//                    if index > 0 {
//                        self.otpFields[index - 1].becomeFirstResponder()
//                    }
//                } else {
//                    if index < self.otpFields.count - 1 {
//                        self.otpFields[index + 1].becomeFirstResponder()
//                    } else {
//                        self.otpFields[index].resignFirstResponder()
//                        let enteredOTP = self.otpFields.compactMap { $0.text }.joined()
//                        if enteredOTP.count == 6 {
//                            self.callVerifyOTPWebService(userOTP: enteredOTP) { success, message in
//                                DispatchQueue.main.async {
//                                    if success {
//                                        print("✅ OTP matched")
//                                        self.checkImage.isHidden = false
//                                        self.checkImage.image = UIImage(named: "check")
//                                        self.showAutoDismissAlert(message: "Code Matched successfully.")
//                                    } else {
//                                        print("✅ OTP did not match")
//                                        self.checkImage.isHidden = false
//                                        self.checkImage.image = UIImage(named: "CrossOtp")
//                                        self.showAutoDismissAlert(message: "Code does not match.")
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//        }
//        return true
//    }
}

// MARK: - extension for Controller

extension RegistationFirstStepVC {
    
    // MARK: function for setup UI
    func setupUI() {
            lblTimer.isHidden = true
            checkImage.isHidden = true
            btnCheck.setImage(UIImage(systemName: "square"), for: .normal)
            lblTerms.text = "I agree to your Terms & Conditions  and Privacy Policy"
            handlelLblTerms()
            lblStrong.isHidden = true
            passwordTF.addTarget(self, action: #selector(passwordDidChange(_:)), for: .editingChanged)
            phoneNumberTF.addTarget(self, action: #selector(handleCountForPhone(_:)), for: .editingChanged)
            otpView.isHidden = true
            NetworkMonitor.shared.startMonitoring()
            otpViewHeightConst.constant = 0
            self.otpTopHeightConst.constant = 5
            self.otpBottomHeightConst.constant = 5
            scrollView.isScrollEnabled = false
        }
        
        // MARK: function for setup delegates for otp fields
    func setDelegate() {
        otpFields = [firstOtpTF, secondOtpTF, thirdOtpTF, fourthOtpTF, fifthOtpTF, sixthOtpTF]

        otpFields.forEach {
            $0.delegate = self
            $0.keyboardType = .numberPad
            $0.textContentType = .oneTimeCode // ✅ Sabhi fields par enable
        }
    }

    
    
    // MARK: function for setup Notification Permission
        func setupNotificationPermission() {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
                if granted {
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                } else {
                    print("❌ Notification permission denied")
                }
            }
        }
    
    // MARK -  function for handle validation for all fields
    func validation() {
        guard let fullName = fullNameTF.text, !fullName.isEmpty else {
            showAlert(title: "", message: "Please enter full name"); return
        }
        if containsBadWords(fullName) {
            showAlert(title: "", message: "Contains inappropriate words"); return
        }
        
        guard let phone = phoneNumberTF.text, !phone.isEmpty else {
            showAlert(title: "", message: "Please enter phone"); return
        }
        
        otpFields = [firstOtpTF, secondOtpTF, thirdOtpTF, fourthOtpTF, fifthOtpTF, sixthOtpTF]
        if otpFields.contains(where: { ($0.text ?? "").isEmpty }) {
            showAlert(title: "", message: "OTP fields can not be empty"); return
        }
        
        guard let email = emailTF.text, !email.isEmpty else {
            showAlert(title: "", message: "Please enter email"); return
        }
        if containsBadWords(email) {
            showAlert(title: "", message: "Contains inappropriate words"); return
        }
        guard email.isValidEmail() else {
            showAlert(title: "", message: "Please enter a valid email address"); return
        }
        
        guard let password = passwordTF.text, !password.isEmpty else {
            showAlert(title: "", message: "Please enter password"); return
        }
        if containsBadWords(password) {
            showAlert(title: "", message: "Contains inappropriate words"); return
        }
        
        //        let passwordRegex = "^(?=.*[A-Z])(?=.*[!@#$&*])(?=.*[0-9])(?=.*[a-z]).{8,}$"
        //        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        //        if !passwordTest.evaluate(with: password) {
        //            showAlert(title: "", message: "Password must be at least 8 characters long and include uppercase, lowercase, number, and special character."); return
        //        }
        
        if isTerm != "1" {
            showAlert(title: "", message: "Please read and accept Terms & Conditions and Privacy Policy."); return
        }
        handleBtnNextAction()
    }
    
    
    // MARK -  function for perform Regiser Api after validation
    func handleBtnNextAction() {
        Messaging.messaging().token { token, error in
            if let error = error {
                print("❌ Error fetching FCM token: \(error)")
            } else if let token = token {
                print("FCM Token fetched: \(token)")
                
                self.callRegisterWebService(firebaseToken: token, completionClosure: {
                    DispatchQueue.main.async {
                        self.setupLocationManager()
                    }
                })

            }
        }
    }


    func pushToNewRegistationSecondStepVC() {
        print("➡️ Pushing to NewRegistationSecondStepVC...")

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let nextVC = storyboard.instantiateViewController(withIdentifier: "NewRegistationSecondStepVC") as? NewRegistationSecondStepVC {
            if let nav = self.navigationController {
                nav.pushViewController(nextVC, animated: true)
            } else {
                print("❌ navigationController is nil. Modal present kar raha hu.")
                self.present(nextVC, animated: true, completion: nil)
            }
        } else {
            print("❌ nextVC not found. Check storyboard ID.")
        }
    }

    
    
    // MARK -  function for set lable for password field after passowrd strength
    @objc func passwordDidChange(_ textField: UITextField) {
        guard let password = textField.text else { return }
        lblStrong.isHidden = false
        if password.isEmpty {
            lblStrong.text = ""
            return
        }
        lblStrong.text = checkPasswordStrength(password)
    }
    
    // MARK -  function for handle count for phone number
    @objc func handleCountForPhone(_ textField: UITextField) {
        guard let phone = textField.text else { return }
        if phone.count > 10 {
            textField.text = String(phone.prefix(10))
            self.showAutoDismissAlert(message: "Phone number cannot be \n more than 10 digits")
        }
    }
    
    // MARK -  function for check password  strength
    func checkPasswordStrength(_ password: String) -> String {
        let length = password.count
        let hasUpperCase = NSPredicate(format: "SELF MATCHES %@", ".*[A-Z]+.*").evaluate(with: password)
        let hasLowerCase = NSPredicate(format: "SELF MATCHES %@", ".*[a-z]+.*").evaluate(with: password)
        let hasNumber = NSPredicate(format: "SELF MATCHES %@", ".*[0-9]+.*").evaluate(with: password)
        let hasSpecial = NSPredicate(format: "SELF MATCHES %@", ".*[!&^%$#@()/]+.*").evaluate(with: password)
        
        var strength = 0
        if length >= 6 { strength += 1 }
        if hasUpperCase { strength += 1 }
        if hasLowerCase { strength += 1 }
        if hasNumber { strength += 1 }
        if hasSpecial { strength += 1 }
        switch strength {
        case 0...2:
            lblStrong.textColor = #colorLiteral(red: 0.8549019608, green: 0, blue: 0, alpha: 1)
            return "Weak"
        case 3...4:
            lblStrong.textColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            return "Medium"
        case 5:
            lblStrong.textColor = #colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1)
            return "Strong"
        default:
            lblStrong.textColor = .gray
            return ""
        }
    }
    
    // MARK -  function for start timer
    @objc func timerAction() {
        counter -= 1
        lblTimer.text = String(format: "00:%02d sec", counter)
        self.phoneNumberTF.isUserInteractionEnabled = false
        
        if counter == 0 {
            timer.invalidate()
            DispatchQueue.main.async {
                self.btnGetOTP.isHidden = false
                self.phoneNumberTF.isUserInteractionEnabled = true
                self.lblTimer.isHidden = true
            }
        }
    }
    
    // MARK -  function for handle timer
    func otpCounterAndResendButton() {
        otpFields.forEach { $0.text = "" }
        checkImage.isHidden = true
        btnGetOTP.isHidden = true
        lblTimer.isHidden = false
        counter = 60
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    // MARK:  Send OTP Api method
    func callOTPWebService(_ completionClosure: @escaping () -> ()) {
            let dictParams: [String: Any] = [
                "device_token": FunctionsConstants.kSharedUserDefaults.deviceToken(),
                "reqestmobileno": self.phoneNumberTF.text ?? ""
            ]
            print("Param isn : \(dictParams)")
            WebService.sharedInstance.callOTPWebService(withParams: dictParams) { data in
                self.loadingAlert = self.showLoadingAlert(on: self)
                print("Send OTP Model: \(data)")
                self.SendOTPData = data
                self.loadingAlert?.dismiss(animated: true, completion: {
                    if self.SendOTPData?.status == "success" {
                        self.showAutoDismissAlert(message: self.SendOTPData?.message ?? "OTP Sent Successfully")
                        self.otpView.isHidden = false
                        self.otpViewHeightConst.constant = 50
                        self.otpTopHeightConst.constant = 15
                        self.otpBottomHeightConst.constant = 15
                        completionClosure()
                        
                        // ✅ Auto-fill OTP from API if available
                        if let otp = self.SendOTPData?.otp, otp.count == 6 {
                            let otpChars = Array(otp)
                            self.otpFields = [self.firstOtpTF, self.secondOtpTF, self.thirdOtpTF, self.fourthOtpTF, self.fifthOtpTF, self.sixthOtpTF]
                            
                            for (i, tf) in self.otpFields.enumerated() {
                                tf.text = String(otpChars[i])
                            }
                            let enteredOTP = self.otpFields.compactMap { $0.text }.joined()
                            self.callVerifyOTPWebService(userOTP: enteredOTP) { success, message in
                                DispatchQueue.main.async {
                                    if success {
                                        print("✅ OTP matched (Auto-filled)")
                                        self.checkImage.isHidden = false
                                        self.checkImage.image = UIImage(named: "check")
                                        self.showAutoDismissAlert(message: "Code Matched successfully.")
                                    } else {
                                        self.checkImage.isHidden = false
                                        self.checkImage.image = UIImage(named: "CrossOtp")
                                        self.showAutoDismissAlert(message: "Code does not match.")
                                    }
                                }
                            }
                        }
                    } else if self.SendOTPData?.status == "failed" {
                        self.showAutoDismissAlert(message: self.SendOTPData?.message ?? "Something went wrong")
                    }
                })
            }
        }
    
    // MARK:  Verify OTP Api method
    func callVerifyOTPWebService(userOTP: String, completion: @escaping (Bool, String) -> Void) {
            guard let mobileNumber = phoneNumberTF.text, !mobileNumber.isEmpty else {
                completion(false, "Mobile number is missing.")
                return
            }
            let dictParams: [String: Any] = ["otpvarify": userOTP, "reqestmobileno": mobileNumber]
            print("Verify OTP Param is : \(dictParams)")
            self.loadingAlert = self.showLoadingAlert(on: self)
            WebService.sharedInstance.callVerifyOTPWebService(withParams: dictParams) { response in
                let responseModel = response
                print("Parsed Model: \(String(describing: response))")
                self.loadingAlert?.dismiss(animated: true, completion: {
                    if responseModel.status == "success",
                       let message = responseModel.description.desc,
                       message != "Code does not match." {
                        self.isOTPVerified = true
                        self.emailTF.becomeFirstResponder()
                        completion(true, responseModel.description.desc ?? "OTP Verified.")
                        //                    completion(true, message)
                    } else {
                        self.isOTPVerified = false
                        completion(false, responseModel.description.desc ?? "Invalid OTP.")
                        
                    }
                })
            }
        }
    
    // MARK:  Verify Email Api method
    func callVerifyEmailAPI(_ completionClosure: @escaping () -> ()) {
        let dictParams: [String: Any] = ["email": emailTF.text ?? ""]
        print("Param is : \(dictParams)")
        WebService.sharedInstance.callVerifyEmailServices(withParams: dictParams) { data in
            print("Verify Email Model: \(data)")
            self.objVerifyEmail = data
            if self.objVerifyEmail?.status == true {
                self.showAutoDismissAlert(message: self.objVerifyEmail?.message ?? "")
                completionClosure()
            } else {
                self.showAutoDismissAlert(message: self.objVerifyEmail?.message ?? "")
            }
        }
    }
    
    // MARK:  Register Web Service Api method
    
//    func callRegisterWebService(firebaseToken: String,_ completionClosure: @escaping () -> ()) {
//        let dictParams: [String: Any] = [
//            "name": self.fullNameTF.text ?? "",
//            "emailid": self.emailTF.text ?? "",
//            "phoneno": self.phoneNumberTF.text ?? "",
//            "password": self.passwordTF.text ?? "",
//            "term": isTerm ?? "",
//            "firebase_token": firebaseToken
//        ]
//        print("param is :\(dictParams)")
//        self.loadingAlert = self.showLoadingAlert(on: self)
//        WebService.sharedInstance.callRegisterWebServiceFirst(withParams: dictParams) { responseData in
//            self.registerData = responseData
//            self.registerData = responseData
//            if let userID = self.registerData?.userid {
//                UserDefaults.standard.set(userID, forKey: "userid")
//                print("✅ Saved userID: \(userID)")
//                // ✅ Location API ko yahan call karo
//                self.callUserLocationWebService()
//            }
//            print("Api data response is model is : \(String(describing: self.registerData))")
//            self.loadingAlert?.dismiss(animated: true, completion: {
//                if self.registerData?.status == "success" {
//                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "NewRegistationSecondStepVC") as! NewRegistationSecondStepVC
//                    self.showToast(message: self.registerData?.message ?? "Something went wrong")
//                    UserDefaults.standard.set(self.fullNameTF.text ?? "", forKey: "userFirstName")
//                    print("User created successfully. Please proceed with registration.")
//                    self.navigationController?.pushViewController(vc, animated: false)
//                    completionClosure()
//                } else {
//                    self.showAlert(message: self.registerData?.message ?? "")
//                }
//            })
//            
//        }
//    }
    
    
    func callRegisterWebService(firebaseToken: String, completionClosure: @escaping () -> ()) {
        let fullName = self.fullNameTF.text ?? ""
        let firstLetter = String(fullName.trimmingCharacters(in: .whitespaces).prefix(1)).uppercased()
        let bgColor = UIColor.colorForAlphabet(firstLetter)
        var imageArray = [UIImage]()
        
        if let initialImg = generateInitialsImage(initials: firstLetter, backgroundColor: bgColor) {
            imageArray = [initialImg]
        } else {
            print("❌ Initials image create nahi hui")
            // Want: can handle error or return
            return
        }

        let dictParams: [String: Any] = [
            "name": fullName,
            "emailid": self.emailTF.text ?? "",
            "phoneno": self.phoneNumberTF.text ?? "",
            "password": self.passwordTF.text ?? "",
            "term": isTerm ?? "",
            "firebase_token": firebaseToken
        ]

        print("param is :\(dictParams)")
        self.loadingAlert = self.showLoadingAlert(on: self)

        callsendImageAPI(param: dictParams, arrImage: imageArray, imageKey: "userpic", URlName: kBASEURL + WebServiceName.kRegisterNew) {
            completionClosure()
        }
    }

    func generateInitialsImage(initials: String, backgroundColor: UIColor, size: CGSize = CGSize(width: 100, height: 100)) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: size)
        let img = renderer.image { ctx in
            // Fill background
            backgroundColor.setFill()
            ctx.fill(CGRect(origin: .zero, size: size))
            // Draw initial
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: size.width/2, weight: .bold),
                .foregroundColor: UIColor.white
            ]
            let textSize = initials.size(withAttributes: attrs)
            let rect = CGRect(x: (size.width - textSize.width)/2, y: (size.height - textSize.height)/2, width: textSize.width, height: textSize.height)
            initials.draw(in: rect, withAttributes: attrs)
        }
        return img
    }

    
    
    func callsendImageAPI(param: [String: Any], arrImage: [UIImage], imageKey: String, URlName: String, withblock: @escaping () -> Void) {
        let headers: HTTPHeaders = ["Content-type": "multipart/form-data"]
        
        AF.upload(multipartFormData: { (multipartFormData) in
            // Append all parameters
            for (key, value) in param {
                if let value = value as? String {
                    multipartFormData.append(Data(value.utf8), withName: key)
                }
            }
            // Append images
            for img in arrImage {
                if let imgData = img.jpegData(compressionQuality: 0.1) {
                    let fileName = "\(NSDate().timeIntervalSince1970.rounded()).jpeg"
                    multipartFormData.append(imgData, withName: imageKey, fileName: fileName, mimeType: "image/jpeg")
                }
            }
        }, to: URlName, method: .post, headers: headers).response { response in
            
            if let error = response.error {
                print("❌ Error in upload: \(error.localizedDescription)")
                return
            }
            
            guard let jsonData = response.data else {
                print("❌ No data received from server.")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                self.registerData = try decoder.decode(RegisterModel.self, from: jsonData)

                print("✅ Parsed Response: \(String(describing: self.registerData))")
                
                DispatchQueue.main.async {
                    // ✅ Dismiss loading alert before navigation
                    self.dismiss(animated: true) {
                        if self.registerData?.status == "success" {
                            
                            // ✅ Save userID
                            if let userID = self.registerData?.userid {
                                UserDefaults.standard.set(userID, forKey: "userid")
                                print("✅ Saved userID: \(userID)")
                                
                                // ✅ Call Location API
                                self.callUserLocationWebService()
                            }
                            
                            // ✅ Navigate to next VC
                            if let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "NewRegistationSecondStepVC") as? NewRegistationSecondStepVC {
                                self.showToast(message: self.registerData?.message ?? "Registration successful")
                                self.navigationController?.pushViewController(nextVC, animated: true)
                            }
                            
                        } else {
                            self.showAlert(message: self.registerData?.message ?? "Something went wrong")
                        }
                    }
                    
                    withblock() // ✅ Call completion
                }

                withblock() // ✅ Call completion
            } catch {
                print("❌ Error parsing response: \(error.localizedDescription)")
            }
        }
    }

    
    
    
    
    func showToast(message: String) {
            let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 150, y: self.view.frame.size.height-100, width: 300, height: 40))
            toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            toastLabel.textColor = UIColor.white
            toastLabel.textAlignment = .center
            toastLabel.font = UIFont.systemFont(ofSize: 14)
            toastLabel.text = message
            toastLabel.alpha = 1.0
            toastLabel.layer.cornerRadius = 10
            toastLabel.clipsToBounds = true
            self.view.addSubview(toastLabel)
            
            UIView.animate(withDuration: 2.0, delay: 2.0, options: .curveEaseOut, animations: {
                toastLabel.alpha = 0.0
            }) { (isCompleted) in
                toastLabel.removeFromSuperview()
            }
        }
    
    
    // MARK:  USER LOCATION Api method
    func callUserLocationWebService() {
        let id = UserDefaults.standard.string(forKey: "userid")
        let url = "https://neighbrsnook.com/admin/api/user-location"
        let params: [String: Any] = [
            "userid": id ?? "",
            "latitude": currentLatitude ?? 0.0,
            "longitude": currentLongitude ?? 0.0,
            "area_name":  "",
            "addlineone": "",
            "addlinetwo":  "",
            "country_name": "India",
            "state_name":   "",
            "city_name":   "",
            "pincode":  ""
        ]
        print(params)
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: ["Content-Type": "application/json"]).responseJSON { response in
            switch response.result {
            case .success(let data):
                print("✅ Response: \(data)")
            case .failure(let error):
                print("❌ API Error: \(error.localizedDescription)")
            }
        }
    }
    
    func requestNotificationPermissionIfNeeded() {
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                switch settings.authorizationStatus {
                case .notDetermined:
                    // Permission not asked yet, request it
                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                        if granted {
                            print("✅ Notification permission granted")
                            DispatchQueue.main.async {
                                UIApplication.shared.registerForRemoteNotifications()
                            }
                        } else {
                            print("❌ Notification permission denied: \(error?.localizedDescription ?? "No error")")
                        }
                    }
                case .denied:
                    print("❌ User has denied notification permission before.")
                case .authorized, .provisional, .ephemeral:
                    print("✅ Notification already authorized.")
                @unknown default:
                    break
                }
            }
        }
    
    func handlelLblTerms() {
        let fullText = "I agree to your Terms & Conditions \n and Privacy Policy"
        let termsRange = (fullText as NSString).range(of: "Terms & Conditions")
        let privacyRange = (fullText as NSString).range(of: "Privacy Policy")
        let attributedText = NSMutableAttributedString(string: fullText)
        let regularFont = UIFont(name: "Montserrat-Regular", size: 14)
        let boldFont = UIFont(name: "Montserrat-SemiBold", size: 15)
        let linkColor = #colorLiteral(red: 0.3607843137, green: 0.3607843137, blue: 0.3607843137, alpha: 1)
        attributedText.addAttribute(.font, value: regularFont!, range: NSRange(location: 0, length: fullText.count))
        attributedText.addAttribute(.font, value: boldFont!, range: termsRange)
        attributedText.addAttribute(.foregroundColor, value: linkColor, range: termsRange)
        attributedText.addAttribute(.font, value: boldFont!, range: privacyRange)
        attributedText.addAttribute(.foregroundColor, value: linkColor, range: privacyRange)
        lblTerms.attributedText = attributedText
        lblTerms.isUserInteractionEnabled = true
        lblTerms.numberOfLines = 0
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTermsTap(_:)))
        lblTerms.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTermsTap(_ gesture: UITapGestureRecognizer) {
        guard let text = lblTerms.attributedText?.string else { return }
        let termsRange = (text as NSString).range(of: "Terms & Conditions")
        let privacyRange = (text as NSString).range(of: "Privacy Policy")
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: lblTerms.bounds.size)
        textContainer.lineFragmentPadding = 0
        textContainer.maximumNumberOfLines = lblTerms.numberOfLines
        textContainer.lineBreakMode = lblTerms.lineBreakMode
        let textStorage = NSTextStorage(attributedString: lblTerms.attributedText!)
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        let location = gesture.location(in: lblTerms)
        let index = layoutManager.characterIndex(for: location, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        if NSLocationInRange(index, termsRange) {
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "Terms_ConditionsViewController") as? Terms_ConditionsViewController else {return}
            self.navigationController?.pushViewController(vc, animated: true)
        } else if NSLocationInRange(index, privacyRange) {
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "PrivacyPolicyViewController") as? PrivacyPolicyViewController else {return}
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func updateScrollViewScrollability() {
        scrollView.isScrollEnabled = scrollView.contentSize.height > UIScreen.main.bounds.height
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        let status = locationManager.authorizationStatus
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            print("❗️Location permission denied or restricted.")
            //            showLocationPermissionAlert()
        @unknown default:
            break
        }
    }
}

// MARK: - extension for CLLocationManagerDelegate
extension RegistationFirstStepVC : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            print("❌ Permission denied. Please enable location in settings.")
            //            showLocationPermissionAlert()
        case .notDetermined:
            break
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            currentLatitude = location.coordinate.latitude
            currentLongitude = location.coordinate.longitude
            print("📍 Current Location: \(currentLatitude!), \(currentLongitude!)")
            callUserLocationWebService()
            locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("❌ Location Error: \(error.localizedDescription)")
    }
    
    func showLocationPermissionAlert() {
        let alertController = UIAlertController (
            title: "Location Permission Needed",
            message: "Please enable location access in Settings to continue.",
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
            if let appSettings = URL(string: UIApplication.openSettingsURLString) { UIApplication.shared.open(appSettings) }
        }))
        if let topVC = (UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene)?
            .windows.first(where: { $0.isKeyWindow })?.rootViewController { topVC.present(alertController, animated: true) }
    }
}
// MARK: - Ends here
