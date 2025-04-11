//
//  RegisterViewController.swift
//  NeighbrsNook Latest
//
//  Created by Rajat Rao on 19/02/24.
//

import UIKit
import Kingfisher
import SVProgressHUD
@available(iOS 16.0, *)

class RegisterViewController: BaseViewC {
    
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
    
    var lastSentOTP: String? = nil
    var SendOTPData : OtpModel?
    var registerData : RegisterModel?
    var verifyOTPData : MatchOTPModel?
    var isTimerStopped = false // Flag to check if the timer is already stopped
    var show = false
    var showConfirm = false
    var check = false
    var counter = 60
    var otp : String?
    var timer = Timer()
    var otpFromAPI: String = ""
    var isOTPVerified: Bool = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        NetworkMonitor.shared.startMonitoring()
        tfFirstName.autocapitalizationType = .words
        tfLastName.autocapitalizationType = .words
        tfMobile.keyboardType = .numberPad
//        otpViewSetUp()
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
        
      
     }
    
    
    
    @objc func didTapLoginLabel() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
            self.navigationController?.pushViewController(loginVC, animated: true)
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
            btnResend.isHidden = false
            lblTimer.isHidden = true
            timer.invalidate() // Timer stopped
        }
    }
    
    func otpCounterAndResendButton() {
        btnResend.isHidden = true
        lblTimer.isHidden = false
        counter = 60 // Reset timer
        timer.invalidate() // Stop any running timer
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
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
        if self.checkBox.image == UIImage(systemName: "square"){
            self.checkBox.image = UIImage(systemName: "checkmark.square.fill")
        }else{
            self.checkBox.image = UIImage(systemName: "square")
        }
        
        
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
            let alert = UIAlertController(title: "", message: "Please enter your number", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "close", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
        else{
            callOTPWebService{
                
                self.otpCounterAndResendButton()
                self.tfOtp1.becomeFirstResponder()
            }
        }
    }
    
    
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    
    
    @IBAction func createBtn(_ sender: UIButton){
        
//        if !isOTPVerified {
//               showAlert(title: "", message: "Please verify your OTP before proceeding.")
//               return
//           }
        
        // Validate First Name
        if tfFirstName.text?.isEmpty == true {
            showAlert(title: "", message: "Please enter first name")
            return
        }
        
        // Validate Last Name
        if tfLastName.text?.isEmpty == true {
            showAlert(title: "", message: "Please enter last name")
            return
        }
        
        // Validate Email
        if tfEmail.text?.isEmpty == true {
            showAlert(title: "", message: "Please enter email")
            return
        } else if !tfEmail.text!.isValidEmail() {
            showAlert(title: "", message: "Please enter valid email")
            return
        }
        
        // Validate Mobile Number
        if tfMobile.text?.isEmpty == true {
            showAlert(title: "", message: "Please enter mobile number")
            return
        } else if tfMobile.text!.count < 10 {
            showAlert(title: "", message: "Please enter valid mobile number")
            return
        }
        
        // Validate OTP
        if tfOtp1.text?.isEmpty == true {
            showAlert(title: "", message: "Please enter OTP")
            return
        }
        
        // Validate Password and Confirm Password with regex
        let passwordRegex = "^(?=.*[A-Z])(?=.*[!@#$&*])(?=.*[0-9])(?=.*[a-z]).{8,}$"
        
        if let password = tfPassword.text, let confirmPassword = tfConfirmPassword.text {
            let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
            
            // Check if password is empty
            if password.isEmpty {
                showAlert(title: "", message: "Please enter password")
                return
            }
            
            // Check if confirm password is empty
            if confirmPassword.isEmpty {
                showAlert(title: "", message: "Please confirm your password")
                return
            }
            
            // Validate password with regex
            if !passwordTest.evaluate(with: password) {
                // Show weak password error message in a popup
                showAlert(title: "Weak password", message: "Your password must be at least 8 characters long and include a number, an uppercase letter and a lowercase letter.")
                return
            }
            
            // Check if passwords match
            if password != confirmPassword {
                showAlert(title: "Password mismatch", message: "Passwords you entered didn't match.")
                return
            }
        }
        
        // Validate Terms & Conditions Checkbox
        if self.checkBox.image == UIImage(systemName: "square") {
            showAlert(title: "", message: "Please read and accept terms & conditions")
            return
        }
        
        // **Show Loader on Button**
           UIHelper.showLoader(on: sender, show: true)

           // All validations passed, proceed to call the web service
           callRegisterWebService { [self] in
               DispatchQueue.main.async {
                   // **Hide Loader After API Response**
                   UIHelper.showLoader(on: sender, show: false)

                   SVProgressHUD.show()
                   let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegisterSecondViewController") as! RegisterSecondViewController
                   vc.name = self.tfFirstName.text ?? ""
                   vc.secname = self.tfLastName.text ?? ""
                   let firstName = tfFirstName.text ?? ""
                   let lastName = tfLastName.text ?? ""
                   callDeviceInfoWebService()
                   
                   // Save to UserDefaults
                   UserDefaults.standard.set(firstName, forKey: "FirstName")
                   UserDefaults.standard.set(lastName, forKey: "LastName")
                   
                   print("Name saved: \(firstName) \(lastName)")
                   self.navigationController?.pushViewController(vc, animated: false)
               }
           }
       }
    
    
    func callRegisterWebService(_ completionClosure: @escaping () -> ()) {
        
        let dictParams: Dictionary<String, Any> = [
            "device_token": FunctionsConstants.kSharedUserDefaults.deviceToken(),
            "firstname":self.tfFirstName.text ?? "",
            "lastname":self.tfLastName.text ?? "",
            "emailid":self.tfEmail.text ?? "",
            "phoneno":self.tfMobile.text ?? "",
            "password":self.tfPassword.text ?? "",
            "confirm_password":self.tfConfirmPassword.text ?? "",
            "term":"1"
            
        ]
        WebService.sharedInstance.callRegisterWebService(withParams: dictParams) { data in
            self.registerData = data
            UserDefaults.standard.set(self.registerData?.userid, forKey: "userid")
            //              UserDefaults.standard.set(self.loginData?.data.apiToken, forKey: "accessToken")
            // UserDefaults.standard.set(self.loginData?.data.id, forKey: "id")
            
            if self.registerData?.status == "success"{
                completionClosure()
            }else{
                self.showAlert(Message: self.registerData?.message ?? "")
            }
        }
    }
    
    
    
    
    
    func callOTPWebService(_ completionClosure: @escaping () -> ()) {
        let dictParams: [String: Any] = [
            "device_token": FunctionsConstants.kSharedUserDefaults.deviceToken(),
            "reqestmobileno": self.tfMobile.text ?? ""
        ]
        
        WebService.sharedInstance.callOTPWebService(withParams: dictParams) { data in
            print("📢 Full API Response: \(data)") // ✅ Full API Response Debug
            
            self.SendOTPData = data

            // 🔍 Direct Dictionary Response Print Karo
            if let dictData = data as? [String: Any] {
                print("📢 Dictionary Response: \(dictData)")
            } else {
                print("❌ API Response is NOT a Dictionary")
            }

            // ✅ OTP Print Karna
            if self.SendOTPData?.status == "success" {
                if let otp = self.SendOTPData?.otp {
                    print("✅ OTP Sent to Mobile: \(otp)") // ✅ Yehi OTP Mobile pe gaya hai
                } else {
                    print("❌ OTP NOT FOUND in API Response") // ❌ OTP missing hai
                }
                completionClosure()
            } else {
                print("❌ API Error: \(self.SendOTPData?.message ?? "No error message")")
                self.showAlert(Message: self.SendOTPData?.message ?? "")
            }
        }

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
    
    // API call to post device information
    func callDeviceInfoWebService() {
        let userId = UserDefaults.standard.string(forKey: "userid") ?? ""
        
        // Get device information
        let deviceInfo = getDeviceInfo()
        
        // Set up parameters for API
        let dictParams: [String: Any] = [
            "device_model": deviceInfo.deviceModel,
            "device_imei": deviceInfo.deviceIMEI,  // This will contain UUID
            "device_platform": deviceInfo.devicePlatform,
            "device_id": deviceInfo.deviceID,
            "user_id": userId
        ]
        
        // Call the Web Service
        WebService.sharedInstance.callDeviceInfo(withParams: dictParams) { data in
            // Handle the response here
            print("Device info posted successfully")
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
                    self.isOTPVerified = true // ✅ OTP Verified, now allow registration
                } else {
                    self.isOTPVerified = false
                }
            }
        }
    }


    // ✅ API Call to Verify OTP
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
            print("📌 Received response: \(String(describing: response))") // ✅ Check karo response me kya aa raha hai
            print("📌 Type of response received: \(type(of: response))")

            // ✅ Check karo ki response `MatchOTPModel` hai ya nahi
            guard let responseModel = response as? MatchOTPModel else {
                print("❌ Response is not of type MatchOTPModel. Actual Type: \(type(of: response))")
                completion(false, "Invalid response from server.")
                return
            }

            // ✅ Model ka data check karo
            print("📌 Parsed Model: Status = \(String(describing: responseModel.status)), Description = \(String(describing: responseModel.description?.desc))")

            if responseModel.status == "success" {
                completion(true, responseModel.description?.desc ?? "OTP Verified Successfully.")
            } else {
                completion(false, responseModel.description?.desc ?? "Invalid OTP.")
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
                               if success {
                                   print("✅ OTP Verified: \(message)")
                                   self.showToast(message: message)
                               } else {
                                   print("❌ OTP Verification Failed: \(message)")
                                   self.clearOTPFields() // ✅ Galat OTP pe saare fields clear honge
                                   self.showToast(message: message)
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
   


    // ✅ Function to Clear OTP Fields on Error
    func clearOTPFields() {
        DispatchQueue.main.async {
            self.tfOtp1.text = ""
            self.tfOtp2.text = ""
            self.tfOtp3.text = ""
            self.tfOtp4.text = ""
            self.tfOtp5.text = ""
            self.tfOtp6.text = ""

            self.tfOtp1.becomeFirstResponder() // ✅ Pehla field active kare
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

    
    
    
    
}
