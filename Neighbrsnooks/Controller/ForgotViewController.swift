//
//  ForgotViewController.swift
//  NeighbrsNook Latest
//
//  Created by Rajat Rao on 19/02/24.
//

import UIKit
import Alamofire
@available(iOS 16.0, *)
class ForgotViewController: BaseViewController {
    
    @IBOutlet weak var tfOtp1: CustomLabelFirstName!
    @IBOutlet weak var tfOtp2: CustomLabelFirstName!
    @IBOutlet weak var tfOtp3: CustomLabelFirstName!
    @IBOutlet weak var tfOtp4: CustomLabelFirstName!
    @IBOutlet weak var tfOtp5: CustomLabelFirstName!
    @IBOutlet weak var tfOtp6: CustomLabelFirstName!
    @IBOutlet weak var tfMobile: UITextField!
    @IBOutlet weak var btnGetOTP: UIButton!
    @IBOutlet weak var lblTimer: UILabel!

    
    var forgetOTPData : ForgetOTPModel?
    var verifyOTPData : MatchOTPModel?
    var otpFields: [CustomLabelFirstName] = []
    // var verifyOTPData : VerifyOTPModel?
    var otp : String?
    var otpTimer: Timer?
    var remainingSeconds = 30
    var isOTPSent = false
    var loadingAlert: UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkMonitor.shared.startMonitoring()
        otpViewSetUp()
        self.navigationItem.hidesBackButton = true
        // Do any additional setup after loading the view.
        btnGetOTP.titleLabel?.textAlignment = .center
        btnGetOTP.titleLabel?.adjustsFontSizeToFitWidth = false
        btnGetOTP.titleLabel?.lineBreakMode = .byClipping
        tfMobile.keyboardType = .numberPad


    }
    
    private func otpViewSetUp(){
        tfOtp1.delegate = self
        tfOtp2.delegate = self
        tfOtp3.delegate = self
        tfOtp4.delegate = self
        tfOtp5.delegate = self
        tfOtp6.delegate = self
    }
    
    
    
    
    @IBAction func BackButtionAction(_ : UIButton){
        
        if let navController = navigationController {
                _ = navController.popViewController(animated: true)
            } else {
                dismiss(animated: true, completion: nil) // Dismiss if presented modally
            }
        
    }
    
    @IBAction func SendOTPBtn(_ sender: UIButton){
        if tfMobile.text == "" {
            self.alertToast(Message: "Please enter your number")
        } else {
            if !isOTPSent {
                // Disable the text field and button on first OTP request
                tfMobile.isEnabled = false
                tfMobile.textColor = .lightGray
                btnGetOTP.isEnabled = false
                btnGetOTP.setTitle("Resend OTP", for: .normal) // Change button title
                
                // Start the timer
                startOTPTimer()
                
                // Call the web service to send OTP
                callForgetOTPWebService {
                    DispatchQueue.main.async {
                        // Show the OTP input field
                        self.tfOtp1.becomeFirstResponder()
                        self.isOTPSent = true // Set flag after OTP is sent
                        // Display the success message from the backend
                        if let message = self.forgetOTPData?.message {
//                            self.showAutoDismissAlert(message: message)
                        }
                    }
                }
            } else {
                // If OTP is already sent, allow resending
                resendOTP()
            }
        }
    }
    
    
    func resendOTP() {
        // You can call the same web service or any other functionality for resending OTP
        callForgetOTPWebService {
            DispatchQueue.main.async {
                // Show the OTP input field
                self.tfOtp1.becomeFirstResponder()
                // Display the success message from the backend
                if let message = self.forgetOTPData?.message {
                    self.showAutoDismissAlert(message: message)
                }
            }
        }
    }
    
    
    deinit {
        // Stop monitoring when the view controller is deallocated
        NetworkMonitor.shared.stopMonitoring()
        otpTimer?.invalidate()
    }
    
    @IBAction func NewVerifyOTPBtn(_ sender: UIButton){
        otpFields = [tfOtp1, tfOtp2, tfOtp3, tfOtp4, tfOtp5, tfOtp6]
        for field in otpFields {
            if field.text?.isEmpty ?? true {
                self.alertToast(Message: "Please Enter OTP")
            }
        }
        
        callVerifyOTPWebService {
            // Completion block
        }
    }
    
    func callForgetOTPWebService(_ completionClosure: @escaping () -> ()) {
        
        let dictParams: [String: Any] = [
            "phone_no": self.tfMobile.text ?? "",
            "api": App_KEYConfig.APP_KEY
        ]
        
        print("✅ Forget OTP Params:", dictParams)
        
        self.loadingAlert = self.showLoadingAlert(on: self)
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        Alamofire.Session.default.request(
            "https://laravelpanel.neighbrsnook.com/api/send-otp_forgot",
            method: .post,
            parameters: dictParams,
            encoding: JSONEncoding.default,
            headers: headers
        ).responseData { response in
            
            DispatchQueue.main.async {
                self.loadingAlert?.dismiss(animated: true, completion: nil)
            }
            
            switch response.result {
                
            case .success(let data):
                
                print("🌐 RAW RESPONSE:", String(data: data, encoding: .utf8) ?? "nil")
                
                do {
                    let result = try JSONDecoder().decode(ForgetOTPModel.self, from: data)
                    print("✅ Forget OTP Response:", result)
                    
                    self.forgetOTPData = result
                    
                    DispatchQueue.main.async {
                        if result.status == true {
                            self.showAutoDismissAlert(message: result.message ?? "OTP sent")
                        } else {
                            self.alertToast(Message: result.message ?? "Something went wrong.")
                        }
                    }
                    
                    completionClosure()
                    
                } catch {
                    print("❌ Decode error:", error)
                    self.alertToast(Message: "Invalid server response.")
                    completionClosure()
                }
                
            case .failure(let error):
                print("❌ Request error:", error.localizedDescription)
                self.alertToast(Message: "Network error.")
                completionClosure()
            }
        }
    }


    
    func callVerifyOTPWebService(_ completionClosure: @escaping () -> ()) {
        
        let dictParams: [String: Any] = [
            "phone_no": self.tfMobile.text ?? "",
            "otp": self.otp ?? "",
            "api": App_KEYConfig.APP_KEY
        ]

        print("Params:", dictParams)

        self.loadingAlert = self.showLoadingAlert(on: self)

        let headers: HTTPHeaders = [
            "Authorization": "Bearer ",
            "Content-Type": "application/json"
        ]

        Alamofire.Session.default.request(
            "https://laravelpanel.neighbrsnook.com/api/otp_verify_forgot",
            method: .post,
            parameters: dictParams,
            encoding: JSONEncoding.default,
            headers: headers
        ).responseData { response in
            
            DispatchQueue.main.async {
                self.loadingAlert?.dismiss(animated: true)
            }

            switch response.result {
                
            case .success(let data):
                do {
                    let result = try JSONDecoder().decode(MatchOTPModel.self, from: data)
                    print("✅ Verify OTP Response:", result)

                    DispatchQueue.main.async {
                        
                        if result.status == true {
                            
                            // ✅ Show Success Message for 2 seconds
                            self.show2SecondAlert(result.message ?? "OTP verified successfully.")

                            // ✅ Navigate after 2 seconds
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ResetPasswordVC") as? ResetPasswordVC {
                                    vc.phoneno = self.tfMobile.text ?? ""
                                    self.navigationController?.pushViewController(vc, animated: true)
                                }
                            }

                        } else {
                            self.alertToast(Message: result.message ?? "Invalid OTP")
                        }

                        completionClosure()
                    }

                } catch {
                    print("❌ Decode error:", error.localizedDescription)
                    DispatchQueue.main.async {
                        self.alertToast(Message: "Invalid server response.")
                    }
                }
                
            case .failure(let error):
                print("❌ Request failed:", error.localizedDescription)
                DispatchQueue.main.async {
                    self.alertToast(Message: "Network error.")
                }
            }
        }
    }


    
    
    func startOTPTimer() {
        remainingSeconds = 30
        otpTimer?.invalidate()

        // Pehle label me 30s show karo
        lblTimer.text = "\(remainingSeconds)"
        lblTimer.isHidden = false // Show the label
        btnGetOTP.isHidden = true // Hide the button while timer is running

        // Start the timer
        otpTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            self.remainingSeconds -= 1

            DispatchQueue.main.async {
                self.lblTimer.text = String(format: "00:%02d sec", self.remainingSeconds)
            }

            if self.remainingSeconds <= 0 {
                timer.invalidate()

                DispatchQueue.main.async {
                    self.lblTimer.isHidden = true // Hide timer label
                    self.btnGetOTP.isHidden = false // Show Get OTP button again
                    self.btnGetOTP.isEnabled = true
                    self.tfMobile.isEnabled = true
                }
            }
        }
    }

    func show2SecondAlert(_ message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        self.present(alert, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            alert.dismiss(animated: true)
        }
    }


 
 }

@available(iOS 16.0, *)
extension ForgotViewController : UITextFieldDelegate{
 
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if [tfOtp1, tfOtp2, tfOtp3, tfOtp4, tfOtp5, tfOtp6].contains(textField) {
            if string.count > 0 {
                textField.text = string
                if textField == tfOtp1 { tfOtp2.becomeFirstResponder() }
                else if textField == tfOtp2 { tfOtp3.becomeFirstResponder() }
                else if textField == tfOtp3 { tfOtp4.becomeFirstResponder() }
                else if textField == tfOtp4 { tfOtp5.becomeFirstResponder() }
                else if textField == tfOtp5 { tfOtp6.becomeFirstResponder() }
                else if textField == tfOtp6 {
                    textField.resignFirstResponder()
                    let enteredOTP = "\(tfOtp1.text ?? "")\(tfOtp2.text ?? "")\(tfOtp3.text ?? "")\(tfOtp4.text ?? "")\(tfOtp5.text ?? "")\(tfOtp6.text ?? "")"
                    self.otp = enteredOTP
                    
                }
                return false
            } else if string.isEmpty {
                textField.text = ""
                if textField == tfOtp6 { tfOtp5.becomeFirstResponder() }
                else if textField == tfOtp5 { tfOtp4.becomeFirstResponder() }
                else if textField == tfOtp4 { tfOtp3.becomeFirstResponder() }
                else if textField == tfOtp3 { tfOtp2.becomeFirstResponder() }
                else if textField == tfOtp2 { tfOtp1.becomeFirstResponder() }
                return false
            }
        }
        return true
    }
}
