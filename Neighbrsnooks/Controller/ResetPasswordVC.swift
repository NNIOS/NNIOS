//
//  ResetPasswordVC.swift
//  Neighbrsnooks
//
//
//

import UIKit
@available(iOS 16.0, *)
class ResetPasswordVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var confirmPasswordView: UIView!
    @IBOutlet weak var lblStrongPass: UILabel!
    
    // MARK: - Variables
    var phoneno: String?
    var objReset: ResetPasswordModel?
    
    // MARK: - Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        self.passwordView.layer.cornerRadius = 10
        self.confirmPasswordView.layer.cornerRadius = 10
        passwordTF.addTarget(self, action: #selector(passwordDidChange(_:)), for: .editingChanged)
        print(phoneno)
    }
    
    // MARK: - Button's Action
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func togglePasswordAction(_ sender: UIButton) {
        toggleSecurity(sender: sender, passwordTextField: passwordTF, confirmPasswordTextField: confirmPasswordTF)
    }
    
    @IBAction func btnResetAction(_ sender: UIButton) {
        validatePasswordsAndReset()
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
    
}

// MARK: - Extension for ResetPasswordVC
@available(iOS 16.0, *)
extension ResetPasswordVC {
    
    // MARK : function for Reset Passowrd API
    func resetPassowrdAPI() {
        
        let urlString = "https://corepanel.neighbrsnook.com/api/master?flag=forgotpassword"
        guard let url = URL(string: urlString) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        // ✅ PHP backend requires form-url-encoded
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        // ✅ Body params
        let params: [String: Any] = [
            "phoneno": phoneno ?? "",
            "password": passwordTF.text ?? "",
            "confirm_password": confirmPasswordTF.text ?? ""
        ]

        // ✅ Convert into x-www-form-urlencoded
        let formBody = params
            .map { "\($0.key)=\($0.value)" }
            .joined(separator: "&")
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""

        request.httpBody = formBody.data(using: .utf8)

        print("📤 FINAL BODY:", formBody)

        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data else {
                DispatchQueue.main.async {
                    self.showAlert(message: "No response from server")
                }
                return
            }
            
            do {
                let result = try JSONDecoder().decode(ResetPasswordModel.self, from: data)
                print("✅ Server Response:", result)

                DispatchQueue.main.async {
                    if result.message == "New password changed successfully" {
                        
                        // ✅ Pop back
                        if let vcs = self.navigationController?.viewControllers {
                            let targetVC = vcs[vcs.count - 3]
                            self.navigationController?.popToViewController(targetVC, animated: true)
                        }
                        
                    } else {
                        self.showAlert(message: result.message ?? "")
                    }
                }
                
            } catch {
                print("❌ JSON decode error:", error)
            }
            
        }.resume()
    }


    
    
//    func resetPassowrdAPI(_ completionClosure: @escaping () -> ()) {
//        let dictParams: [String: Any]  = [
//            "phoneno": phoneno ?? "",
//            "password": passwordTF.text ?? "",
//            "confirm_password": confirmPasswordTF.text ?? ""
//        ]
//        
//        print("📤 API Call Params: \(dictParams)")
//        WebService.sharedInstance.callForGotPasswordWebService(withParams: dictParams) { (data: objReset?) in
//            
//            if let data = data {
//                print("✅ API Response received")
//                print("🔍 Full ProfileModel: \(data)")
//                self.objReset = data
//            } else {
//                print("❌ API response is nil. Either network failed or model didn't map correctly.")
//            }
//            
//            completionClosure()
//        }
//    }
//    
    
    
    
    // MARK : function for Validate Password
    func validatePasswordsAndReset() {
        guard let password = passwordTF.text, !password.isEmpty else {
            alertToast(Message: "Password enter password")
            return
        }
        if password.count < 5 {
                alertToast(Message: "Password must be at least 5 characters long")
                return
            }
        
        guard  let confirmPassword = confirmPasswordTF.text, !confirmPassword.isEmpty else {
            alertToast(Message: "Please confirm password")
            return
        }
        
        guard password == confirmPassword else {
            alertToast(Message: "Passwords don't match")
            return
        }
        resetPassowrdAPI()
    }
    
    // MARK : function for Hide Show secure text entry in textfield
    func toggleSecurity(sender: UIButton, passwordTextField: UITextField, confirmPasswordTextField: UITextField?) {
        sender.isSelected.toggle()
        let isSecure = sender.isSelected
        let eyeImageName = isSecure ? "eye.slash.fill" : "eye.fill"
        sender.setImage(UIImage(systemName: eyeImageName), for: .normal)
        
        if sender.tag == 0 {
            passwordTextField.isSecureTextEntry = isSecure
        } else if sender.tag == 1, let confirmPasswordTextField = confirmPasswordTextField {
            confirmPasswordTextField.isSecureTextEntry = isSecure
        }
    }
    
    func setRootViewController(_ viewController: UIViewController, animated: Bool = true) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return
        }
        
        if animated {
            UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromRight, animations: {
                window.rootViewController = viewController
            }, completion: nil)
        } else {
            window.rootViewController = viewController
        }
        window.makeKeyAndVisible()
    }
    
}
