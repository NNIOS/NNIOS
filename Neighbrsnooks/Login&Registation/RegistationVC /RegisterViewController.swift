//
//  RegisterViewController.swift
//  NeighbrsNook Latest
//
//  Created by Rajat Rao on 19/02/24.
//

import UIKit
import Kingfisher
import SVProgressHUD
import FirebaseMessaging
import Alamofire
import FirebaseAnalytics
import CoreLocation
@available(iOS 16.0, *)

class RegisterViewController: BaseViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfConfirmPassword: UITextField!
    @IBOutlet weak var tfMobile: UITextField!
    @IBOutlet weak var btnEye: UIButton!
    @IBOutlet weak var btnConfirmEye: UIButton!
    @IBOutlet weak var tfFirstName: UITextField!
    @IBOutlet weak var tfLastName: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfOtp1: UITextField!
    @IBOutlet weak var tfOtp2: UITextField!
    @IBOutlet weak var tfOtp3: UITextField!
    @IBOutlet weak var tfOtp4: UITextField!
    @IBOutlet weak var tfOtp5: UITextField!
    @IBOutlet weak var tfOtp6: UITextField!
    @IBOutlet weak var btnCheck: UIButton!
    @IBOutlet var checkBox: UIImageView!
    @IBOutlet weak var lblIalredyhaveAnAccount: UILabel!
    @IBOutlet weak var btnResend: UIButton!
    @IBOutlet weak var lblTimer: UILabel!
    @IBOutlet weak var btnPrivacy: UIButton!
    @IBOutlet weak var btnTrems: UIButton!
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet var checkOTP: UIImageView!
    @IBOutlet weak var lblStrongPass: UILabel!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    
    
    var lastSentOTP: String? = nil
    var SendOTPData : OtpModel?
    var registerData : RegisterModel?
    var verifyOTPData : MatchOTPModel?
    var verifyEmail : EmailVerifyModel?
    var isTimerStopped = false
    var show = false
    var showConfirm = false
    var check = false
    var counter = 60
    var otp : String?
    var timer = Timer()
    var otpFromAPI: String = ""
    var isOTPVerified: Bool = false
    var isFirstTimeOtp = true
    let locationManager = CLLocationManager()
    var currentLatitude: Double?
    var currentLongitude: Double?
    var isTermsAccepted = false
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnNext.setTitle("Next", for: .normal)
        btnNext.layer.cornerRadius = 10
        self.navigationItem.hidesBackButton = true
        NetworkMonitor.shared.startMonitoring()
        tfFirstName.autocapitalizationType = .words
        tfLastName.autocapitalizationType = .words
        tfMobile.keyboardType = .numberPad
        tfMobile.delegate = self
        self.checkBox.image = UIImage(systemName: "square")
        self.lblHeading.font = UIFont(name: "Montserrat-SemiBold", size: 22)
        btnPrivacy.titleLabel?.font = UIFont(name: "Montserrat-SemiBold", size: 14) //
        btnTrems.titleLabel?.font = UIFont(name: "Montserrat-SemiBold", size: 14) //
        lblTimer.isHidden = true
        checkOTP.isHidden = true
        self.navigationItem.hidesBackButton = true
        setupTextFields()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapLoginLabel))
        lblIalredyhaveAnAccount.isUserInteractionEnabled = true
        lblIalredyhaveAnAccount.addGestureRecognizer(tapGesture)
        // First label after first view
        stackView.insertArrangedSubview(createInfoLabel(), at: 1)
        stackView.setCustomSpacing(0, after: stackView.arrangedSubviews[0])
        // Second label after second view
        stackView.insertArrangedSubview(createInfoLabel(), at: 3) // adjust index if needed
        stackView.setCustomSpacing(0, after: stackView.arrangedSubviews[2])
        tfPassword.addTarget(self, action: #selector(passwordDidChange), for: .editingChanged)
//        fsetupLocationManager()  location permission of
//        requestNotificationPermissionIfNeeded()
        
        
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
    
    
    func createInfoLabel() -> UIView {
        let label = UILabel()
        label.text = "(as per your govt ID)"
        label.font = UIFont(name: "Montserrat-Regular", size: 12)  // 👉 custom font
        label.textColor = .lightGray
        label.textColor = UIColor(red: 92/255, green: 92/255, blue: 92/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        let container = UIView()
        container.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            label.topAnchor.constraint(equalTo: container.topAnchor),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        return container
    }
    @objc func didTapLoginLabel() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
            self.navigationController?.pushViewController(loginVC, animated: true)
        }
    }
    
    
    // MARK: - passwordDidChange pass week medm and strong
    @objc func passwordDidChange(_ textField: UITextField) {
        guard let password = textField.text else { return }
        
        if password.isEmpty {
            lblStrongPass.text = ""
            return
        }
        
        lblStrongPass.text = checkPasswordStrength(password)
    }
    
    
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
            lblStrongPass.textColor = .red
            return "Weak"
        case 3...4:
            lblStrongPass.textColor = .orange
            return "Medium"
        case 5:
            lblStrongPass.textColor = .systemGreen
            return "Strong"
        default:
            lblStrongPass.textColor = .gray
            return ""
        }
    }
    
    
    // MARK: - Setup TextFields
    func setupTextFields() {
        let textFields = [tfOtp1, tfOtp2, tfOtp3, tfOtp4, tfOtp5, tfOtp6]
        for tf in textFields {
            tf?.delegate = self
            tf?.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        }
    }
    
    // MARK: - TextField Change Tracking
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text, text.count == 1 {
            switch textField {
            case tfOtp1: tfOtp2.becomeFirstResponder()
            case tfOtp2: tfOtp3.becomeFirstResponder()
            case tfOtp3: tfOtp4.becomeFirstResponder()
            case tfOtp4: tfOtp5.becomeFirstResponder()
            case tfOtp5: tfOtp6.becomeFirstResponder()
            case tfOtp6:
                textField.resignFirstResponder()
                verifyOTP() // ✅ Last OTP enter hone ke baad verify karega
            default: break
            }
        } else if let text = textField.text, text.isEmpty {
            switch textField {
            case tfOtp6: tfOtp5.becomeFirstResponder()
            case tfOtp5: tfOtp4.becomeFirstResponder()
            case tfOtp4: tfOtp3.becomeFirstResponder()
            case tfOtp3: tfOtp2.becomeFirstResponder()
            case tfOtp2: tfOtp1.becomeFirstResponder()
            case tfOtp1: break
            default: break
            }
        }
    }
    
    
    
    
    
    deinit {
        // Stop monitoring when the view controller is deallocated
        NetworkMonitor.shared.stopMonitoring()
    }
    // check otp
    
    // MARK: - Timer Handling
    @objc func timerAction() {
        counter -= 1
        lblTimer.text = "00:\(String(format: "%02d", counter))"
        
        if counter == 0 {
            timer.invalidate()
            DispatchQueue.main.async {
                self.btnResend.isHidden = false
                self.lblTimer.isHidden = true
            }
        }
    }
    
    func otpCounterAndResendButton() {
        btnResend.isHidden = true
        lblTimer.isHidden = false
        counter = 60 // Reset timer
        timer.invalidate() // Stop any running timer
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    
    //    ---------- MARK: - Notification Permission
    
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
    
    
    
    
    
    @IBAction func BackButtionAction(_ : UIButton){
        
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    
    
    @IBAction func btnEye(_ sender: UIButton) {
        
        if show
        {
            show = false
            btnEye.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
            tfPassword.isSecureTextEntry = !tfPassword.isSecureTextEntry
        }
        else
        {
            show = true
            btnEye.setImage(UIImage(systemName: "eye.fill"), for: .normal)
            tfPassword.isSecureTextEntry = !tfPassword.isSecureTextEntry
        }
    }
    
    @IBAction func btnConfirmEye(_ sender: UIButton) {
        
        if showConfirm
        {
            showConfirm = false
            btnConfirmEye.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
            tfConfirmPassword.isSecureTextEntry = !tfConfirmPassword.isSecureTextEntry
        }
        else
        {
            showConfirm = true
            btnConfirmEye.setImage(UIImage(systemName: "eye.fill"), for: .normal)
            tfConfirmPassword.isSecureTextEntry = !tfConfirmPassword.isSecureTextEntry
        }
    }
    
    
    @IBAction func onTapCheckbox(_ sender: UITapGestureRecognizer) {
        isTermsAccepted.toggle()
           let imageName = isTermsAccepted ? "checkmark.square.fill" : "square"
           checkBox.image = UIImage(systemName: imageName)
 
    }
    
    
    
    @IBAction func btnTerms$Condition(_ sender: UIButton) {
        
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "PrivacyPolicyViewController") as? PrivacyPolicyViewController else {return}
        
        self.navigationController?.pushViewController(vc, animated: true)
        
        
        
    }
    
    @IBAction func PaCBtn(_ sender: UIButton){
        
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "Terms_ConditionsViewController") as? Terms_ConditionsViewController else {return}
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
    @IBAction func btnSignin(_ : UIButton){
        
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else {return}
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    //     send OTP Button
    @IBAction func SendOTPBtn(_ sender: UIButton){
        
        if tfMobile.text == "" {
            let alert = UIAlertController(title: "", message: "Please enter your number", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "close", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            clearOtpFields()

            callOTPWebService {
                let successAlert = UIAlertController(title: "", message: "OTP has been sent", preferredStyle: .alert)
                self.present(successAlert, animated: true)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    successAlert.dismiss(animated: true, completion: {
                        self.tfOtp1.becomeFirstResponder()
                    })
                }
                
                // ✅ Start timer
                self.otpCounterAndResendButton()
                
                // ✅ Change button title to "Resend OTP" after first time
                if self.isFirstTimeOtp {
                    self.btnResend.setTitle("Resend OTP", for: .normal)
                    self.isFirstTimeOtp = false
                }
            }
        }
    }
    func clearOtpFields() {
        tfOtp1.text = ""
        tfOtp2.text = ""
        tfOtp3.text = ""
        tfOtp4.text = ""
        tfOtp5.text = ""
        tfOtp6.text = ""
        checkOTP.isHidden = true
    }

    
    
    func showVerificationAlert() {
        let messageText = "You have limited access till verification is complete. We thank you for your patience."
        
        let alert = UIAlertController(title: "", message: messageText, preferredStyle: .alert) // use "" instead of nil
        
        let messageAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Montserrat-Regular", size: 15) ?? UIFont.systemFont(ofSize: 15),
            .foregroundColor: UIColor.darkGray
        ]
        
        let attributedMessage = NSAttributedString(string: messageText, attributes: messageAttributes)
        alert.setValue(attributedMessage, forKey: "attributedMessage")
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
//    @IBAction func createBtn(_ sender: UIButton) {
//        // ✅ Bad word check — First Name
//        guard let firstName = tfFirstName.text, !firstName.isEmpty else {
//            showAlert(title: "", message: "Please enter first name")
//            return
//        }
//        if containsBadWords(firstName) {
//            showAlert(title: "", message: "Contains inappropriate words.")
//            return
//        }
//
//        // ✅ Bad word check — Last Name
//        guard let lastName = tfLastName.text, !lastName.isEmpty else {
//            showAlert(title: "", message: "Please enter last name")
//            return
//        }
//        if containsBadWords(lastName) {
//            showAlert(title: "", message: "Contains inappropriate words.")
//            return
//        }
//
//        // ✅ English-only name validation
//        if !isEnglishOnly(firstName) || !isEnglishOnly(lastName) {
//            showAlert(title: "", message: "Please enter name in English only.")
//            return
//        }
//
//        // ✅ Bad word check — Email
//        guard let email = tfEmail.text, !email.isEmpty else {
//            showAlert(title: "", message: "Please enter email")
//            return
//        }
//        if containsBadWords(email) {
//            showAlert(title: "", message: "Contains inappropriate words.")
//            return
//        }
//
//        // ✅ Email format
//        guard email.isValidEmail() else {
//            showAlert(title: "", message: "Please enter a valid email address")
//            return
//        }
//
//        // ✅ Show loader while verifying email
//        UIHelper.showLoader(on: sender, show: true)
//
//        // ✅ Call verify email API
//        callVerifyEmailAPI { [weak self] isEmailValid in
//            guard let self = self else { return }
//            DispatchQueue.main.async {
//                UIHelper.showLoader(on: sender, show: false)
//                if isEmailValid {
//                    // ✅ Continue remaining validations
//                    guard let mobile = self.tfMobile.text, !mobile.isEmpty else {
//                        self.showAlert(title: "", message: "Please enter mobile number")
//                        return
//                    }
//                    if mobile.count < 10 {
//                        self.showAlert(title: "", message: "Please enter valid mobile number")
//                        return
//                    }
//
//                    if self.tfOtp1.text?.isEmpty == true {
//                        self.showAlert(title: "", message: "Please enter OTP")
//                        return
//                    }
//
//                    if self.isOTPVerified == false {
//                        self.showAlert(title: "", message: "Incorrect OTP.")
//                        return
//                    }
//
//                    let passwordRegex = "^(?=.*[A-Z])(?=.*[!@#$&*])(?=.*[0-9])(?=.*[a-z]).{8,}$"
//                    let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
//
//                    guard let password = self.tfPassword.text, !password.isEmpty else {
//                        self.showAlert(title: "", message: "Please enter password")
//                        return
//                    }
//
//                    guard let confirmPassword = self.tfConfirmPassword.text, !confirmPassword.isEmpty else {
//                        self.showAlert(title: "", message: "Please confirm your password")
//                        return
//                    }
//
//                    
//
//                    if !self.isTermsAccepted {
//                        self.showAlert(title: "", message: "Please read and accept Terms & Conditions and Privacy Policy.")
//                        return
//                    }
//
//                    UIHelper.showLoader(on: sender, show: true)
//                    Messaging.messaging().token { token, error in
//                        UIHelper.showLoader(on: sender, show: false)
//                        if let error = error {
//                            print("❌ Error fetching FCM token: \(error)")
//                        } else if let token = token {
//                            print("📱 FCM Token fetched: \(token)")
//                            self.callRegisterWebService(firebaseToken: token) {
//                                DispatchQueue.main.async {
//                                    SVProgressHUD.show()
//                                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegisterSecondViewController") as! RegisterSecondViewController
//                                    UserDefaults.standard.set(firstName, forKey: "userFirstName")
//                                    UserDefaults.standard.set(lastName, forKey: "userLastName")
//                                    self.navigationController?.pushViewController(vc, animated: false)
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }

    
    @IBAction func createBtn(_ sender: UIButton) {
        // ✅ Bad word check — First Name
        guard let firstName = tfFirstName.text, !firstName.isEmpty else {
            showAlert(title: "", message: "Please enter first name")
            return
        }
        if containsBadWords(firstName) {
            showAlert(title: "", message: "Contains inappropriate words.")
            return
        }

        // ✅ Bad word check — Last Name
        guard let lastName = tfLastName.text, !lastName.isEmpty else {
            showAlert(title: "", message: "Please enter last name")
            return
        }
        if containsBadWords(lastName) {
            showAlert(title: "", message: "Contains inappropriate words.")
            return
        }

        // ✅ English-only name validation
        if !isEnglishOnly(firstName) || !isEnglishOnly(lastName) {
            showAlert(title: "", message: "Please enter name in English only.")
            return
        }

        // ✅ Bad word check — Email
        guard let email = tfEmail.text, !email.isEmpty else {
            showAlert(title: "", message: "Please enter email")
            return
        }
        if containsBadWords(email) {
            showAlert(title: "", message: "Contains inappropriate words.")
            return
        }

        // ✅ Email format
        guard email.isValidEmail() else {
            showAlert(title: "", message: "Please enter a valid email address")
            return
        }

        // ❌ Commented API Call: Email verification
        /*
        UIHelper.showLoader(on: sender, show: true)
        callVerifyEmailAPI { [weak self] isEmailValid in
            // .... skipped
        }
        */

        // ✅ Continue validations without email API
        guard let mobile = tfMobile.text, !mobile.isEmpty else {
            showAlert(title: "", message: "Please enter mobile number")
            return
        }
        if mobile.count < 10 {
            showAlert(title: "", message: "Please enter valid mobile number")
            return
        }

        if tfOtp1.text?.isEmpty == true {
            showAlert(title: "", message: "Please enter OTP")
            return
        }

        if isOTPVerified == false {
            showAlert(title: "", message: "Incorrect OTP.")
            return
        }

        let passwordRegex = "^(?=.*[A-Z])(?=.*[!@#$&*])(?=.*[0-9])(?=.*[a-z]).{8,}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)

        guard let password = tfPassword.text, !password.isEmpty else {
            showAlert(title: "", message: "Please enter password")
            return
        }

        guard let confirmPassword = tfConfirmPassword.text, !confirmPassword.isEmpty else {
            showAlert(title: "", message: "Please confirm your password")
            return
        }

        if !isTermsAccepted {
            showAlert(title: "", message: "Please read and accept Terms & Conditions and Privacy Policy.")
            return
        }

        // ✅ Register
        UIHelper.showLoader(on: sender, show: true)
        Messaging.messaging().token { token, error in
            UIHelper.showLoader(on: sender, show: false)
            if let error = error {
                print("❌ Error fetching FCM token: \(error)")
            } else if let token = token {
                print("📱 FCM Token fetched: \(token)")
                
                // OLD CODE
           /*     self.callRegisterWebService(firebaseToken: token) {
                    DispatchQueue.main.async {
                        SVProgressHUD.show()
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegisterSecondViewController") as! RegisterSecondViewController
                        UserDefaults.standard.set(firstName, forKey: "userFirstName")
                        UserDefaults.standard.set(lastName, forKey: "userLastName")
                        
                        self.navigationController?.pushViewController(vc, animated: false)
                    }
               }
            */
                
                self.callRegisterWebService(firebaseToken: token) {
                    DispatchQueue.main.async {
                        SVProgressHUD.show()
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegisterSecondViewController") as! RegisterSecondViewController
                        UserDefaults.standard.set(firstName, forKey: "userFirstName")
                        UserDefaults.standard.set(lastName, forKey: "userLastName")
                        
                        //MARK: - **Yahan Firebase Analytics event log karen**
                        
                        Analytics.logEvent("registration_firstStep_complete_iOS", parameters: [
                            "first_name": firstName,
                            "last_name": lastName,
                            "method": "firstStep_app_registration_iOS",
                            "platform": "iOS"
                        ])

                        self.navigationController?.pushViewController(vc, animated: false)
                    }
                }

                
                
            }
        }
    }

 
    
    func callRegisterWebService(firebaseToken: String, completionClosure: @escaping () -> ()) {
        let dictParams: [String: Any] = [
            "device_token": FunctionsConstants.kSharedUserDefaults.deviceToken(),
            "firebase_token": firebaseToken,
            "firstname": self.tfFirstName.text ?? "",
            "lastname": self.tfLastName.text ?? "",
            "emailid": self.tfEmail.text ?? "",
            "phoneno": self.tfMobile.text ?? "",
            "password": self.tfPassword.text ?? "",
            "confirm_password": self.tfConfirmPassword.text ?? "",
            "term": "1"
        ]
        
        WebService.sharedInstance.callRegisterWebService(withParams: dictParams) { data in
            self.registerData = data
            if let userID = self.registerData?.userid {
                UserDefaults.standard.set(userID, forKey: "userid")
                print("✅ Saved userID: \(userID)")
                self.callUserLocationWebService()
            }
            
            if self.registerData?.status == "success" {
                UserDefaults.standard.set("step1", forKey: "registrationStep") // After login, address page
                completionClosure()
            } else {
                self.showAlert(Message: self.registerData?.message ?? "")
            }
            
        }
    }
    
    
    
    
    // MARK: - Call api VerifyEmail
    
    func callVerifyEmailAPI(completion: @escaping (Bool) -> Void) {
        guard let email = self.tfEmail.text, !email.isEmpty else {
            self.showAlert(message: "Please enter a valid email address")
            completion(false)
            return
        }
        
        guard email.isValidEmail() else {
            self.showAlert(message: "Please enter a valid email address irshad ")
            completion(false)
            return
        }
        //dev.
        let url = URL(string: "https://dev.neighbrsnook.com/admin/api/verify-email")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let parameters = ["email": email]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            print("Failed to encode parameters: \(error)")
            completion(false)
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    self.showAlert(message: "Network error occurred. Please try again.")
                    completion(false)
                    return
                }
                
                guard let data = data else {
                    print("No data received")
                    self.showAlert(message: "No response from server. Please try again.")
                    completion(false)
                    return
                }
                
                do {
                    let decodedResponse = try JSONDecoder().decode(EmailVerifyModel.self, from: data)
                    print("Status: \(decodedResponse.status)")
                    print("Message: \(decodedResponse.message)")
                    
                    if decodedResponse.status == false {
                        self.showAlert(message: "Please enter a valid email address") // Always show fixed message
                        completion(false)
                        return
                    } else {
                        completion(true)
                    }
                    
                    
                } catch {
                    print("Decoding error: \(error)")
                    if let responseString = String(data: data, encoding: .utf8) {
                        print("Raw response: \(responseString)")
                    }
                    self.showAlert(message: "Invalid response from server. Please try again.")
                    completion(false)
                    return
                }
            }
        }
        task.resume()
    }
    
    
    func callOTPWebService(_ completionClosure: @escaping () -> ()) {
        let dictParams: [String: Any] = [
            "device_token": FunctionsConstants.kSharedUserDefaults.deviceToken(),
            "reqestmobileno": self.tfMobile.text ?? ""
        ]
        
        WebService.sharedInstance.callOTPWebService(withParams: dictParams) { data in
            print("📢 Full API Response: \(data)") // ✅ Full API Response Debug
            
            self.SendOTPData = data
            
            if let dictData = data as? [String: Any] {
                print("📢 Dictionary Response: \(dictData)")
            } else {
                print("❌ API Response is NOT a Dictionary")
            }
            
            if self.SendOTPData?.status == "success" {
                if let otp = self.SendOTPData?.otp {
                    print("✅ OTP Sent to Mobile: \(otp)")
                } else {
                    print("❌ OTP NOT FOUND in API Response")
                }
                
                // ✅ Show success alert for 2 seconds
                self.showAutoDismissAlert(message: self.SendOTPData?.message ?? "OTP Sent Successfully")
                completionClosure()
                
            } else {
                // ❌ Show error alert for 2 seconds
                self.showAutoDismissAlert(message: self.SendOTPData?.message ?? "Something went wrong")
            }
        }
    }
    
    
    
    
    
    
    
    
    // MARK: - API Call to Verify OTP
    func verifyOTP() {
        guard let otp1 = tfOtp1.text, let otp2 = tfOtp2.text, let otp3 = tfOtp3.text,
              let otp4 = tfOtp4.text, let otp5 = tfOtp5.text, let otp6 = tfOtp6.text else {
            showAlert(title: "❌ Error", message: "Please enter the complete OTP.")
            return
        }
        
        let enteredOTP = "\(otp1)\(otp2)\(otp3)\(otp4)\(otp5)\(otp6)"
        print("Entered OTP: \(enteredOTP)")
        
        callVerifyOTPWebService(userOTP: enteredOTP) { isVerified, message in
            DispatchQueue.main.async {
                let title = isVerified ? "✅ Success" : "❌ Error"
                self.showAlert(title: title, message: message)
                
                if isVerified {
                    self.isOTPVerified = true
                    
                } else {
                    self.isOTPVerified = false
                    
                }
                
            }
        }
    }
    
    
    // MARK: - gat current location
    
//    func setupLocationManager() {
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        
//        let status = CLLocationManager.authorizationStatus()
//        switch status {
//        case .notDetermined:
//            locationManager.requestWhenInUseAuthorization()
//        case .authorizedWhenInUse, .authorizedAlways:
//            locationManager.startUpdatingLocation()
//        case .denied, .restricted:
//            print("❗️Location permission denied or restricted.")
//            //            showLocationPermissionAlert()
//        @unknown default:
//            break
//        }
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        switch status {
//        case .authorizedWhenInUse, .authorizedAlways:
//            locationManager.startUpdatingLocation()
//        case .denied, .restricted:
//            print("❌ Permission denied. Please enable location in settings.")
//            //            showLocationPermissionAlert()
//        case .notDetermined:
//            break
//        @unknown default:
//            break
//        }
//    }
//    
//    
//    
//    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let location = locations.first {
//            currentLatitude = location.coordinate.latitude
//            currentLongitude = location.coordinate.longitude
//            print("📍 Current Location: \(currentLatitude!), \(currentLongitude!)")
//            
//            // Call API once location is updated
//            callUserLocationWebService()
//            
//            // Optional: Stop updating to save battery
//            locationManager.stopUpdatingLocation()
//        }
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print("❌ Location Error: \(error.localizedDescription)")
//    }
//    
//    
    
    // MARK: -  CALL API FOR USER LOCATION   UserLocation current dev.
    
    func callUserLocationWebService() {
        let id = UserDefaults.standard.string(forKey: "userid")
        print("✅ User ID after login: \(id ?? "Not Found")")
        
        let url = "https://dev.neighbrsnook.com/admin/api/user-location" // dev.
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
    
    
    func showLocationPermissionAlert() {
        let alertController = UIAlertController(
            title: "Location Permission Needed",
            message: "Please enable location access in Settings to continue.",
            preferredStyle: .alert
        )
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettings)
            }
        }))
        
        if let topVC = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController {
            topVC.present(alertController, animated: true)
        }
    }
    
    
    //MARK: - ✅ API Call to Verify OTP
    
    func callVerifyOTPWebService(userOTP: String, completion: @escaping (Bool, String) -> Void) {
        guard let mobileNumber = tfMobile.text, !mobileNumber.isEmpty else {
            completion(false, "Mobile number is missing.")
            return
        }
        
        let dictParams: [String: Any] = [
            "otpvarify": userOTP,
            "reqestmobileno": mobileNumber
        ]
        
        print("📌 Sending OTP Verification with Params: \(dictParams)")
        
        WebService.sharedInstance.callVerifyOTPWebService(withParams: dictParams) { response in
            print("📌 Received response: \(String(describing: response))")
            print("📌 Type of response received: \(type(of: response))")
            
            guard let responseModel = response as? VerifyOTPModel else {
                print("❌ Response is not of type VerifyOTPModel. Actual Type: \(type(of: response))")
                completion(false, "Invalid response from server.")
                return
            }
            
            print("📌 Parsed Model: Status = \(String(describing: responseModel.status)), Description = \(String(describing: responseModel.description.desc))")
            
            if responseModel.status == "success" {
                if responseModel.description.desc == "Code does not match." {
                    self.isOTPVerified = false
                } else {
                    self.isOTPVerified = true
                }
                print("Isvarified is : \(self.isOTPVerified)")
                completion(true, responseModel.description.desc ?? "OTP Verified Successfully.")
            } else {
                completion(false, responseModel.description.desc ?? "Invalid OTP.")
            }
        }
    }
    
    
    
    
}
@available(iOS 16.0, *)
extension RegisterViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Mobile number field ke liye limit lagana (max 10 digits)
        if textField == tfMobile {
            let currentText = textField.text ?? ""
            let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
            return newText.count <= 10
        }
        // OTP fields me sirf ek character allow karna
        if [tfOtp1, tfOtp2, tfOtp3, tfOtp4, tfOtp5, tfOtp6].contains(textField) {
            if string.count > 0 { // ✅ Naya character enter ho raha hai
                textField.text = string // ✅ Entered digit set karo
                
                // ✅ Next OTP field me cursor move karo
                if textField == tfOtp1 { tfOtp2.becomeFirstResponder() }
                else if textField == tfOtp2 { tfOtp3.becomeFirstResponder() }
                else if textField == tfOtp3 { tfOtp4.becomeFirstResponder() }
                else if textField == tfOtp4 { tfOtp5.becomeFirstResponder() }
                else if textField == tfOtp5 { tfOtp6.becomeFirstResponder() }
                else if textField == tfOtp6 {
                    textField.resignFirstResponder() // ✅ Last field pe keyboard dismiss
                    // ✅ API Call for OTP Verification
                    let enteredOTP = "\(tfOtp1.text ?? "")\(tfOtp2.text ?? "")\(tfOtp3.text ?? "")\(tfOtp4.text ?? "")\(tfOtp5.text ?? "")\(tfOtp6.text ?? "")"
                    callVerifyOTPWebService(userOTP: enteredOTP) { success, message in
                        DispatchQueue.main.async {
                            self.checkOTP.isHidden = false
                            
                            // Manually check for 'code does not match'
                            let isCorrectOTP = !message.lowercased().contains("code does not match")
                            
                            if isCorrectOTP {
                                print("✅ OTP Verified: \(message)")
                                self.showToast(message: "OTP Verified Successfully")
                                self.checkOTP.image = UIImage(named: "check") // ✅ Show check image
                            } else {
                                print("❌ OTP Incorrect: \(message)")
                                self.showToast(message: "Incorrect OTP")
                                self.checkOTP.image = UIImage(named: "CrossOtp") // ❌ Show cross image
                            }
                        }
                    }
                }
                return false // ✅ Default behavior disable
            } else if string.isEmpty { // ✅ Agar user backspace dabaye
                textField.text = "" // ✅ Current field clear kare
                
                // ✅ Previous OTP field pe cursor move kare
                if textField == tfOtp6 { tfOtp5.becomeFirstResponder() }
                else if textField == tfOtp5 { tfOtp4.becomeFirstResponder() }
                else if textField == tfOtp4 { tfOtp3.becomeFirstResponder() }
                else if textField == tfOtp3 { tfOtp2.becomeFirstResponder() }
                else if textField == tfOtp2 { tfOtp1.becomeFirstResponder() }
                
                return false // ✅ Default behavior disable
            }
        }
        return true
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
    
    
}

 

extension UIViewController {
    func showAutoDismissAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let messageFont = UIFont(name: "Montserrat-Regular", size: 15) ?? UIFont.systemFont(ofSize: 14)
        let messageAttrString = NSAttributedString(
            string: message,
            attributes: [
                .font: messageFont,
                .foregroundColor: #colorLiteral(red: 0.3607843137, green: 0.3607843137, blue: 0.3607843137, alpha: 1)
            ]
        )
        alert.setValue(messageAttrString, forKey: "attributedMessage")
        self.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
}
