//
//  EditNameVC.swift
//  Neighbrsnooks
//
//  Created by  on 28/05/25.
//

import UIKit
import SVProgressHUD

@available(iOS 16.0, *)
class EditNameVC: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var lblEditName: UILabel!
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var btnView: UIView!
    
    // MARK: - Variables
    var fName:String?
    var lName:String?
    var userId: String?
    var fullName: String?
    var registerData : RegisterModel?
    var awaitStatusModel : AwaitStatusModel?
    var onUpdateSuccess: ((Bool) -> Void)?

    var activityIndicator = UIActivityIndicatorView(style: .large)
    var verfiedMsg:String?
    var sourceViewController: String?
    // MARK: - LifeCycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        lastNameTF.text = lName
        setupActivityIndicator()
        firstNameTF.text = fullName
        lastNameTF.setPadding(left: 10)
        firstNameTF.setPadding(left: 10)
        lastNameTF.autocapitalizationType = .words
        firstNameTF.autocapitalizationType = .words
        userId = UserDefaults.standard.string(forKey: "userid")
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        self.lblEditName.font = UIFont(name: "Montserrat-Regular", size: 17)
        self.firstNameTF.font = UIFont(name: "Montserrat-Regular", size: 15)
        self.lastNameTF.font = UIFont(name: "Montserrat-Regular", size: 15)
    }
    
    // MARK: - Button's Action
    @IBAction func btnUpdateAction(_ sender: CustomButton) {
        if sender.tag == 0 {
            print("Cancel Button is tapped")
            self.dismiss(animated: true)
            return
        }

        // Input validation
        guard !areFieldsEmpty(firstNameField: firstNameTF) else {
            showAlert(message: "Please enter your full name", yesNo: "OK")
            return
        }

        let enteredName = firstNameTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let originalName = fullName?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        // Check for inappropriate content
        if containsBadWords(enteredName) {
            let message = """
            Inappropriate content!
            This name goes against our community guidelines.
            Please keep things respectful.
            """
            showAlert(message: message, yesNo: "OK")
            apiCallNameUpdate() // Update name even if inappropriate
            return
        }

        // Name same as original
        if enteredName.caseInsensitiveCompare(originalName) == .orderedSame {
            showToast(message: "Please enter name as per your gov ID")
            return
        }

        // English-only check
        if !isEnglishOnly(enteredName) {
            showAlert(message: "Please enter name in English only.", yesNo: "OK")
            return
        }

        // ✅ Start loader
        self.activityIndicator.startAnimating()
        sender.isUserInteractionEnabled = false
        self.dismissKeyboard()

        // HomeViewController specific behavior
        // HomeViewController specific behavior
        if sourceViewController == "HomeViewController", verfiedMsg == "User not verified" {
            // Call both APIs sequentially
            apiCallNameUpdate {
                self.apiCallAwaitClearName {
                    DispatchQueue.main.async {
                        self.onUpdateSuccess?(true)   // Notify success yaha call karo
                        self.activityIndicator.stopAnimating()
                        sender.isUserInteractionEnabled = true
                        self.dismiss(animated: true)
                    }
                }
            }
        } else {
            // Only name update
            apiCallNameUpdate {
                DispatchQueue.main.async {
                    self.onUpdateSuccess?(true)   // Success yaha bhi
                    self.activityIndicator.stopAnimating()
                    sender.isUserInteractionEnabled = true
                    self.dismiss(animated: true)
                }
            }
        }
    }

    // ✅ Wrapper function with completion
    func apiCallNameUpdate(completion: (() -> Void)? = nil) {
        let params: Parameters = ["name": firstNameTF.text ?? ""]

        ProfileUpdateV_M.shared.ProfileUpdate(parameters: params) { [weak self] result, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("❌ Profile Update API Error: \(error)")
                    completion?()
                    return
                }

                guard let encryptedString = result?.data else {
                    print("❌ Encrypted string missing in API response")
                    completion?()
                    return
                }

                decryptProfileUpdateData(encryptedString: encryptedString) { decrypted in
                    DispatchQueue.main.async {
                        guard let decrypted = decrypted else {
                            print("❌ Decrypt API failed")
                            completion?()
                            return
                        }

                        print("✅ User ID: \(decrypted.data.data.userID)")
                        print("✅ Message: \(decrypted.data.message)")
                        print("✅ Verified: \(decrypted.data.data.verified)")

                        // Optional callback
                        completion?()
                    }
                }
            }
        }
    }

    // ✅ Wrapper function for AwaitClearName with completion
    func apiCallAwaitClearName(completion: (() -> Void)? = nil) {
        let params: Parameters = [:] // Only token goes in headers

        AwaitClearNameV_M.shared.AwaitClearName(parameters: params) { [weak self] result, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("❌ AwaitClearName API Error: \(error)")
                    self?.showAlert(message: error, yesNo: "OK")
                    completion?()
                    return
                }

                guard let result = result else {
                    self?.showAlert(message: "Invalid response from server", yesNo: "OK")
                    completion?()
                    return
                }

                print("✅ AwaitClearName API Success: \(result)")

                if result.status == true {
                    self?.showToast(message: result.message ?? "Name cleared successfully")
                } else {
                    self?.showAlert(message: result.message ?? "Something went wrong", yesNo: "OK")
                }

                completion?()
            }
        }
    }






}

// MARK: - Extension for Controller
@available(iOS 16.0, *)
extension EditNameVC {

    
    // MARK: function textfield validation
    func areFieldsEmpty(firstNameField: UITextField/*, lastNameField: UITextField*/) -> Bool {
        let firstName = firstNameField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
//        let lastName = lastNameField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        return firstName.isEmpty/* || lastName.isEmpty*/
    }
    
    func setupActivityIndicator() {
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            view.addSubview(activityIndicator)
        }
        
        func stopLoader(_ button: UIButton) {
            activityIndicator.stopAnimating()
            button.isEnabled = true // Button enable karo jab process complete ho
        }
    
    func showToast(message: String) { // show Toast Messages
            let toastLabel = UILabel(frame: CGRect(x: 0, y: view.frame.size.height - 100, width: view.frame.size.width, height: 40))
            let font = UIFont(name: "Montserrat-Regular", size: 15) ?? .systemFont(ofSize: 15)
            let messageSize = (message as NSString).size(withAttributes: [.font: font])
            let desiredWidth = messageSize.width + 30
            toastLabel.frame.origin.x = (view.frame.size.width - desiredWidth) / 2
            toastLabel.frame.size.width = desiredWidth
            toastLabel.backgroundColor = #colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 0.75)
            toastLabel.textColor = .white
            toastLabel.textAlignment = .center
            toastLabel.font = font
            toastLabel.text = message
            toastLabel.alpha = 1.0
            toastLabel.layer.cornerRadius = toastLabel.frame.height / 2
            toastLabel.clipsToBounds = true
            view.addSubview(toastLabel)
            UIView.animate(withDuration: 0.2, delay: 1.8, options: .curveEaseOut) {
                toastLabel.alpha = 0.0
            } completion: { _ in  toastLabel.removeFromSuperview() }
        }
}

// MARK: - Extension for UITextField
extension UITextField {
    func setPadding(left: CGFloat,) {
        setLeftPadding(left)
    }

    private func setLeftPadding(_ padding: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}
// MARK: - Ends here
