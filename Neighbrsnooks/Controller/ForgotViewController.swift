//
//  ForgotViewController.swift
//  NeighbrsNook Latest
//
//  Created by Rajat Rao on 19/02/24.
//

import UIKit
@available(iOS 16.0, *)
class ForgotViewController: UIViewController {
    
    @IBOutlet weak var tfOtp1: UITextField!
    @IBOutlet weak var tfOtp2: UITextField!
    @IBOutlet weak var tfOtp3: UITextField!
    @IBOutlet weak var tfOtp4: UITextField!
    @IBOutlet weak var tfOtp5: UITextField!
    @IBOutlet weak var tfOtp6: UITextField!
    @IBOutlet weak var tfMobile: UITextField!
    @IBOutlet weak var btnGetOTP: UIButton!
    @IBOutlet weak var lblTimer: UILabel!

    
    var forgetOTPData : ForgetOTPModel?
    var verifyOTPData : VerifyOTPModel?
    
    // var verifyOTPData : VerifyOTPModel?
    var otp : String?
    var otpTimer: Timer?
    var remainingSeconds = 30
    var isOTPSent = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkMonitor.shared.startMonitoring()
        otpViewSetUp()
        self.navigationItem.hidesBackButton = true
        // Do any additional setup after loading the view.
        btnGetOTP.titleLabel?.textAlignment = .center
        btnGetOTP.titleLabel?.adjustsFontSizeToFitWidth = false
        btnGetOTP.titleLabel?.lineBreakMode = .byClipping

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
            let alert = UIAlertController(title: "Alert", message: "Please Enter Your Number", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
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
                            self.showAutoDismissAlert(message: message)
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
        
        if tfOtp1.text == "" {
            let alert = UIAlertController(title: "", message: "Please Enter Your otp", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "close", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        } else if tfOtp2.text == ""{
            let alert = UIAlertController(title: "", message: "Please Enter otp", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "close", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else if tfOtp3.text == ""{
            let alert = UIAlertController(title: "", message: "Please Enter otp", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "close", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else if tfOtp4.text == ""{
            let alert = UIAlertController(title: "", message: "Please Enter otp", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "close", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if tfOtp5.text == ""{
            let alert = UIAlertController(title: "", message: "Please Enter otp", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "close", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if tfOtp6.text == ""{
            let alert = UIAlertController(title: "", message: "Please Enter otp", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "close", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        else{
            callVerifyOTPWebService{
                
            }
        }
    }
    
    func callForgetOTPWebService(_ completionClosure: @escaping () -> ()) {
        let dictParams: [String: Any]  = [
            "reqestmobileno":self.tfMobile.text ?? "",
            "flag":"forget"
        ]
        WebService.sharedInstance.callForgetOTPWebService(withParams: dictParams) { data in
            self.forgetOTPData = data
            
            //              UserDefaults.standard.set(self.loginData?.data.apiToken, forKey: "accessToken")
            // UserDefaults.standard.set(self.loginData?.data.id, forKey: "id")
            
            completionClosure()
        }
    }
    
    func callVerifyOTPWebService(_ completionClosure: @escaping () -> ()) {
        let dictParams: [String: Any]  = [
            "reqestmobileno":self.tfMobile.text ?? "",
            "otpvarify": self.otp ?? ""
        ]
        WebService.sharedInstance.callVerifyOTPWebService(withParams: dictParams) { data in
            self.verifyOTPData = data
            if self.verifyOTPData?.description.desc == "Code Matched successfully." {
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ResetPasswordVC") as? ResetPasswordVC else {return}
                vc.phoneno = self.tfMobile.text ?? ""
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                self.showAlert(message: "Code does not match.")
            }
            completionClosure()
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
                self.lblTimer.text = "\(self.remainingSeconds)"
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
