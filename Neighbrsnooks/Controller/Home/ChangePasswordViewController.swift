//
//  ChangePasswordViewController.swift
//  NeighbrsNook Latest Latest
//
//  Created by Mac on 27/05/24.
//

import UIKit

@available(iOS 16.0, *)
class ChangePasswordViewController: BaseViewController {
    
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var tfNewPassword: UITextField!
    @IBOutlet weak var tfConfirmPassword: UITextField!
    @IBOutlet weak var tfOldPassword: UITextField!
    @IBOutlet weak var btnOldEye: UIButton!
    @IBOutlet weak var btnNewEye: UIButton!
    @IBOutlet weak var btnConfirmEye: UIButton!
    @IBOutlet weak var weaklblNewPassword: UILabel!
    @IBOutlet weak var weaklblConfirmPassword: UILabel!

    var show = false
    var showNew = false
    var showConfirm = false
    var ChangePasswordData : ChangePasswordModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weaklblNewPassword.text = ""
        weaklblConfirmPassword.text = ""
        self.lblHeading.font = UIFont(name: "Montserrat-Regular", size: 18)
        tfNewPassword.addTarget(self, action: #selector(passwordDidChangeForNewPass(_:)), for: .editingChanged)
        tfConfirmPassword.addTarget(self, action: #selector(passwordDidChangeForConfirm(_:)), for: .editingChanged)
    }
    
    @IBAction func BackButtionAction(_ : UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnOldEye(_ sender: UIButton) {
        if show {
            show = false
            btnOldEye.setImage(UIImage(systemName: "eye.fill"), for: .normal)
            tfOldPassword.isSecureTextEntry = !tfOldPassword.isSecureTextEntry
        } else {
            show = true
            btnOldEye.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
            tfOldPassword.isSecureTextEntry = !tfOldPassword.isSecureTextEntry
        }
    }
    
    @IBAction func btnNewEye(_ sender: UIButton) {
        if showNew {
            showNew = false
            btnNewEye.setImage(UIImage(systemName: "eye.fill"), for: .normal)
            tfNewPassword.isSecureTextEntry = !tfNewPassword.isSecureTextEntry
        } else {
            showNew = true
            btnNewEye.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
            tfNewPassword.isSecureTextEntry = !tfNewPassword.isSecureTextEntry
        }
    }
    
    @IBAction func btnConfirmEye(_ sender: UIButton) {
        showConfirm.toggle()
        tfConfirmPassword.isSecureTextEntry.toggle()
        let imageName = showConfirm ? "eye.slash.fill" : "eye.fill"
        btnConfirmEye.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    @IBAction func SaveBtn(_ sender: UIButton) {
        guard let old = tfOldPassword.text, !old.isEmpty else { return alertToast(Message: "Please enter old password") }
        guard let new = tfNewPassword.text, !new.isEmpty, new.count >= 5 else { return alertToast(Message: "Password must be at least 5 characters long.") }
        guard let confirm = tfConfirmPassword.text, !confirm.isEmpty else { return alertToast(Message: "Please confirm password") }
        guard new == confirm else { return alertToast(Message: "The passwords don't match") }
        callChangePasswordWebService {
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "NeigbrnookViewController") as? NeigbrnookViewController {
                self.navigationController?.pushViewController(vc, animated: false)
            }
        }
    }
    
    @objc func passwordDidChangeForNewPass(_ textField: UITextField) {
        guard let password = textField.text else { return }
        if password.isEmpty {
            weaklblNewPassword.text = ""; return
        }
        weaklblNewPassword.text = checkPasswordStrengthForNewPassord(password)
    }
    
    @objc func passwordDidChangeForConfirm(_ textField: UITextField) {
        guard let password = textField.text else { return }
        if password.isEmpty {
            weaklblConfirmPassword.text = ""; return
        }
        weaklblConfirmPassword.text = checkPasswordStrengthForConfirmPassord(password)
    }
    
    func checkPasswordStrengthForNewPassord(_ password: String) -> String {
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
            weaklblNewPassword.textColor = .red
            return "Weak"
        case 3...4:
            weaklblNewPassword.textColor = .orange
            return "Medium"
        case 5:
            weaklblNewPassword.textColor = #colorLiteral(red: 0, green: 0.5603090525, blue: 0, alpha: 1)
            return "Strong"
        default:
            weaklblNewPassword.textColor = .gray
            return ""
        }
    }
    
    func checkPasswordStrengthForConfirmPassord(_ password: String) -> String {
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
            weaklblConfirmPassword.textColor = .red
            return "Weak"
        case 3...4:
            weaklblConfirmPassword.textColor = .orange
            return "Medium"
        case 5:
            weaklblConfirmPassword.textColor = #colorLiteral(red: 0, green: 0.5603090525, blue: 0, alpha: 1)
            return "Strong"
        default:
            weaklblConfirmPassword.textColor = .gray
            return ""
        }
    }
    
    func callChangePasswordWebService(_ completionClosure: @escaping () -> ()) {
        let id = UserDefaults.standard.string(forKey: "userid")
        let dictParams: Dictionary<String, Any> = [
            "userid":id ?? "",
            "actualpassword":self.tfOldPassword.text ?? "",
            "newpassword":self.tfNewPassword.text ?? "",
            "confirm_password":self.tfConfirmPassword.text ?? ""
        ]
        print("Param is : \(dictParams)")
//        WebService.sharedInstance.callChangePasswordWebService(withParams: dictParams) { data in
//            self.ChangePasswordData = data
//            if self.ChangePasswordData?.status == "success" {
//                completionClosure()
//            }else{
//                self.alertToast(Message: self.ChangePasswordData?.message ?? "")
//            }
//        }
    }
}
