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
    func resetPassowrdAPI(_ completionClosure: @escaping () -> ()) {
        let dictParams: [String: Any]  = [
            "phoneno":phoneno ?? "",
            "password":passwordTF.text ?? "",
            "confirm_password":confirmPasswordTF.text ?? "",
            
        ]
        WebService.sharedInstance.callForGotPasswordWebService(withParams: dictParams) { data in
            self.objReset = data
            if self.objReset?.message == "New password changed successfully" {
                
                if let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "") as? LoginViewController {
                    let navController = UINavigationController(rootViewController: loginVC)
                    self.setRootViewController(navController)
                }
            } else {
                self.showAlert(message: self.objReset?.message ?? "")
            }
            completionClosure()
        }
    }
    
    // MARK : function for Validate Password
    func validatePasswordsAndReset() {
        guard let password = passwordTF.text, !password.isEmpty,
              let confirmPassword = confirmPasswordTF.text, !confirmPassword.isEmpty else {
            showAlert(message: "Please fill in both password fields.")
            return
        }
        
        guard password == confirmPassword else {
            showAlert(message: "Passwords don't match.")
            return
        }
        
        resetPassowrdAPI {
        }
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
 
