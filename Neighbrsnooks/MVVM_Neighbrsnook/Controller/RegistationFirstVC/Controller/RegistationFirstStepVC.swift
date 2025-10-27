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
import FirebaseAnalytics
import CoreLocation

class RegistationFirstStepVC: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var fullNameTF: UITextField!
    @IBOutlet weak var phoneNumberTF: UITextField!
    @IBOutlet weak var lblTimer: UILabel!
    @IBOutlet weak var firstOtpTF: CustomLabelFirstName!
    @IBOutlet weak var secondOtpTF: CustomLabelFirstName!
    @IBOutlet weak var thirdOtpTF: CustomLabelFirstName!
    @IBOutlet weak var fourthOtpTF: CustomLabelFirstName!
    @IBOutlet weak var fifthOtpTF: CustomLabelFirstName!
    @IBOutlet weak var sixthOtpTF: CustomLabelFirstName!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var btnCheck: UIButton!
    @IBOutlet weak var lblTerms: CustomLabelHeadingname!
    @IBOutlet weak var checkImage: UIImageView!
    @IBOutlet weak var btnGetOTP: UIButton!
    @IBOutlet weak var lblStrong: UILabel!
    @IBOutlet weak var otpView: UIView!
    @IBOutlet weak var otpViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var otpTopHeightConst: NSLayoutConstraint!
    @IBOutlet weak var otpBottomHeightConst: NSLayoutConstraint!
    @IBOutlet weak var imgEmail: UIImageView!
    
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
    let locationManager = CLLocationManager()
    var otpFields: [CustomLabelFirstName] = []
    var isVerifyingOTP = false
    var numberOfOTPdigit = 6
    var textFieldArray = [CustomLabelFirstName]()
    
    
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
    @IBAction func btnGetOtpAction(_ sender: UIButton) {
        let param: Parameters = [
            "phone_no": phoneNumberTF.text ?? ""
        ]
        
        Otp_VM().sendOtp(parameter: param) { response in
            DispatchQueue.main.async {
                if let result = response {
                    if result.status {
                        // Success flow
                        print("OTP sent: \(result.message ?? "")")
                        self.startOTPTimer()
                        self.otpView.isHidden = false
                        self.otpViewHeightConst.constant = 50
                        self.otpTopHeightConst.constant = 15
                        self.otpBottomHeightConst.constant = 15
                        self.firstOtpTF.becomeFirstResponder()
                        Decrypt_VM().goToDecrypt(encryptedData: result.data ?? "") { decryptData in
                            if let decrypt = decryptData {
                                print("Decrypt Message:", decrypt.data.message)
                                print("Status:", decrypt.data.status)
                            } else {
                                print("Decrypt failed")
                            }
                        }
                    } else {
                        // Error check yahan
                        let errorMsg = result.message ?? result.error ?? "Something went wrong"
                        AlertViewManager.shared.alertMessage(title: "Opps", message: errorMsg, controller: self)
                    }
                } else {
                    // No response case
                    AlertViewManager.shared.alertMessage(title: "Opps", message: "No response from server", controller: self)
                }
            }
        }
    }
    
    
    
    @IBAction func btnNextAction(_ sender: CustomButtonClick) {
        let fcmToken = UserDefaults.standard.string(forKey: "fcmToken") ?? ""
        guard validation() else { return }
        
        let request = Register_Request(
            name: fullNameTF.text ?? "",
            email: emailTF.text ?? "",
            phone_no: phoneNumberTF.text ?? "",
            password: passwordTF.text ?? "",
            firebase_token: fcmToken,
            terms: "1"
        )
        
        let param: [String: String] = [
            "name": request.name,
            "email": request.email,
            "phone_no": request.phone_no,
            "password": request.password,
            "firebase_token": request.firebase_token,
            "terms": request.terms
        ]
        print(param)
        
        Register_VM().goToRegister(parameter: param, request: request) { response in
            DispatchQueue.main.async {
                if let res = response {
                    if res.status {
                        print("✅ Register success:", res.message ?? "")
                        
                        // 🔑 Encrypted data aaya -> ab decrypt call
                        Decrypt_VM().goToDecrypt(encryptedData: res.data ?? "") { decryptResponse in
                            if let decryptRes = decryptResponse {
                                if let user = decryptRes.data.userData {
                                    print("🎉 Decrypted ID:", user.id)
                                    print("🔑 Token:", user.token)
                                    UserDefaults.standard.set(user.token, forKey: "authToken")   // Token save karo
                                    DispatchQueue.main.async {
                                        self.pushToNewRegistationSecondStepVC()
                                        self.uploadUserPic()
                                    }
                                    
                                } else {
                                    print("⚠️ No user data in decrypt response")
                                    print("Message:", decryptRes.data.message ?? "")
                                }
                            } else {
                                print("❌ Decrypt failed")
                            }
                        }
                        
                        // 🔍 Email Verification step
                        let emailParam: [String: String] = [
                            "email": request.email
                        ]
                        Email_Verify_VM().verifyEmail(parameter: emailParam) { emailVerifyResponse in
                            DispatchQueue.main.async {
                                if let emailRes = emailVerifyResponse {
                                    if emailRes.status.isSuccess {
                                        print("✅ Email verified successfully!")
                                        // Next step UI or navigation yahan karo
                                    } else {
                                        let errorMsg = (emailRes.error?.isEmpty ?? true) ? (emailRes.message ?? "Unknown error occurred") : emailRes.error!
                                        AlertViewManager.shared.alertMessage(
                                            title: "Email Error",
                                            message: errorMsg,
                                            controller: self
                                        )
                                    }
                                } else {
                                    AlertViewManager.shared.alertMessage(
                                        title: "Email Error",
                                        message: "No response from server",
                                        controller: self
                                    )
                                }
                                
                            }
                        }
                        
                    } else {
                        let errorMsg = res.message ?? res.error ?? "Registration failed"
                        AlertViewManager.shared.alertMessage(
                            title: "Error",
                            message: errorMsg,
                            controller: self
                        )
                    }
                } else {
                    AlertViewManager.shared.alertMessage(
                        title: "Error",
                        message: "No response from server",
                        controller: self
                    )
                }
            }
        }
    }
    
    
    private func startOTPTimer() {
        lblTimer.isHidden = false
        counter = 60
        lblTimer.text = "\(counter)s"
        btnGetOTP.isEnabled = false
        btnGetOTP.setTitle("", for: .normal)
        timer.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.counter -= 1
            if self.counter > 0 {
                self.lblTimer.text = "\(self.counter)"
            } else {
                self.timer.invalidate()
                self.lblTimer.isHidden = true
                self.btnGetOTP.isEnabled = true
                self.btnGetOTP.setTitle("Resend OTP", for: .normal) // Button title wapas lao
            }
        }
        RunLoop.main.add(timer, forMode: .common)
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
    func textField(_ textField: UITextField,shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let currentField = textField as? CustomLabelFirstName {
            let isDeleting = string.isEmpty
            if isDeleting {
                if currentField.text?.isEmpty ?? true {
                    currentField.previousTextField?.becomeFirstResponder()
                } else {
                    currentField.text = ""
                }
                return false
            } else {
                currentField.text = string
                if let next = currentField.nextTextFiled {
                    next.becomeFirstResponder()
                } else {
                    currentField.resignFirstResponder()
                    checkOTPCompletion()
                }
                return false
            }
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == emailTF {
            imgEmail.image = UIImage(named: "email") // ✅ update the icon
        }
    }
    
    private func fillOTPFields(with otp: String) {
        otpFields.forEach { $0.text = "" } // Clear all first
        for (i, char) in otp.enumerated() where i < otpFields.count {
            otpFields[i].text = String(char)
        }
        otpFields.last?.resignFirstResponder()
        checkOTPCompletion()
    }
    
    
    
    
    private func verifyOTP(_ otp: String) {
        let param: Parameters = [
            "phone_no": phoneNumberTF.text ?? "",
            "otp": otp,
        ]
        Otp_Verify_VM().verifyOtp(parameter: param) { response in
            DispatchQueue.main.async {
                self.isVerifyingOTP = false
                if let result = response, result.status {
                    print("✅ OTP Verified: \(result.message)")
                    // Optional: call decrypt here
                    Decrypt_VM().goToDecrypt(encryptedData: result.data) { decryptResponse in
                        DispatchQueue.main.async { // Add this
                            if let decrypt = decryptResponse {
                                if decrypt.data.status {
                                    self.checkImage.isHidden = false
                                    self.checkImage.image = UIImage(named: "check")
                                } else {
                                    self.checkImage.isHidden = false
                                    self.checkImage.image = UIImage(named: "CrossOtp")
                                }
                                print("🔓 Decrypt Message:", decrypt.data.message)
                                print("🔓 Status:", decrypt.data.status)
                            }
                        }
                    }
                    
                } else {
                    print("❌ OTP Verification Failed")
                    self.showAlert(title: "Otp", message: response?.message ?? "Something went wrong")
                }
            }
        }
    }
    private func checkOTPCompletion() {
        let enteredOTP = otpFields.compactMap { $0.text }.joined()
        
        if enteredOTP.count == otpFields.count && !isVerifyingOTP {
            isVerifyingOTP = true
            verifyOTP(enteredOTP)
        }
    }
    
    
    
    
}

// MARK: - extension for Controller

extension RegistationFirstStepVC {
    
    // MARK: function for setup UI
    func setupUI() {
        fullNameTF.autocapitalizationType = .words
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
        emailTF.delegate = self
    }
    
    // MARK: function for setup delegates for otp fields
    func setDelegate() {
        otpFields = [firstOtpTF, secondOtpTF, thirdOtpTF, fourthOtpTF, fifthOtpTF, sixthOtpTF]
        
        for (index, field) in otpFields.enumerated() {
            field.delegate = self
            field.keyboardType = .numberPad
            field.textContentType = .oneTimeCode
            
            if index > 0 {
                field.previousTextField = otpFields[index - 1]
            }
            if index < otpFields.count - 1 {
                field.nextTextFiled = otpFields[index + 1]
            }
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
    func validation() -> Bool {
        guard let fullName = fullNameTF.text, !fullName.isEmpty else {
            alertToast(Message: "Please enter full name"); return false
        }
        
        if containsBadWords(fullName) {
            alertToast(Message: "Contains inappropriate words"); return false
        }
        
        guard let phone = phoneNumberTF.text, !phone.isEmpty else {
            alertToast(Message: "Please enter phone"); return false
        }
        
        if otpFields.contains(where: { ($0.text ?? "").isEmpty }) {
            alertToast(Message: otpView.isHidden ? "Please verify your phone number with OTP" : "Please enter OTP"); return false
        }
        
        guard let email = emailTF.text, !email.isEmpty else {
            imgEmail.image = UIImage(named: "CrossOtp")
            alertToast(Message: "Please enter email"); return false
        }
        if containsBadWords(email) {
            alertToast(Message: "Contains inappropriate words"); return false
        }
        
        guard email.isValidEmail() else {
            imgEmail.image = UIImage(named: "CrossOtp")
            alertToast(Message: "Please enter a valid email address"); return false
        }
        
        guard let password = passwordTF.text, !password.isEmpty else {
            alertToast(Message: "Please enter password"); return false
        }
        
        guard password.count >= 5 else {
            alertToast(Message: "Password must be at least 5 characters long."); return false
        }
        
        if containsBadWords(password) {
            alertToast(Message: "Contains inappropriate words"); return false
        }
        
        if isTerm != "1" {
            alertToast(Message: "Please read and accept Terms & Conditions and Privacy Policy."); return false
        }
        
        return true
    }
    
    
    
    
    
    func pushToNewRegistationSecondStepVC() {
        print("➡️ Pushing to NewRegistationSecondStepVC...")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let nextVC = storyboard.instantiateViewController(withIdentifier: "NewRegistationSecondStepVC") as? NewRegistationSecondStepVC {
            nextVC.sourceScreen = "FirstSteep"
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
        let screenHeight = UIScreen.main.bounds.height
        if screenHeight <= 667 {
            scrollView.isScrollEnabled = true
        } else {
            scrollView.isScrollEnabled = scrollView.contentSize.height > screenHeight
        }
    }
    
    
    //MARK: - User pic upload api
    func uploadUserPic() {
        // 1️⃣ Get the first letter of fullNameTF
        guard let name = fullNameTF.text, !name.isEmpty else { return }
        let firstLetter = String(name.prefix(1))
        
        // 2️⃣ Get background color based on first letter
        let bgColor = UIColor.colorForAlphabet(firstLetter)
        
        // 3️⃣ Generate UIImage with initial
        guard let userpicImage = generateInitialsImage(
            initials: firstLetter,
            backgroundColor: bgColor,
            size: CGSize(width: 100, height: 100)
        ) else { return }
        
        // 4️⃣ Prepare documents dictionary (API expects "userpic")
        let documents = ["userpic": userpicImage]
        
        // 5️⃣ Call API
        UserPicUpdate.shared.UserPicUploadApi(parameters: [:], documents: documents) { response in
            if let res = response {
                if res.status {
                    print("✅ Userpic updated successfully:", res.message)
                } else {
                    print("❌ Failed to update userpic:", res.message)
                }
            } else {
                print("❌ No response from server")
            }
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
