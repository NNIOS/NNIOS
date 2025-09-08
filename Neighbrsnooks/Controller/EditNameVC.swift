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
    var onUpdateSuccess: ((_ range: String) -> Void)?
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
//    @IBAction func btnUpdateAction(_ sender: CustomButton) {
//        if sender.tag == 0 {
//            print("Cancel Button is tapped")
//            self.dismiss(animated: true)
//        } else if sender.tag == 1 {
//            if areFieldsEmpty(firstNameField: firstNameTF, lastNameField: lastNameTF) {
//                showAlert(message: "Please fill in both first name and last name.", yesNo: "OK")
//            } else {
//                self.callRegisterWebService {
//                    // After successful register, call await status API
//                    self.callAwaitStatusapiWebService { success in
//                        if success {
//                            print("✅ Await Status API Call Done")
//                            // Aap yahan aage navigation ya alert show kar sakte hain
//                        } else {
//                            print("❌ Await Status API failed")
//                        }
//                    }
//                }
//            }
//        }
//    }
    
//    @IBAction func btnUpdateAction(_ sender: CustomButton) {
//        if sender.tag == 0 {
//            print("Cancel Button is tapped")
//            self.dismiss(animated: true)
//        } else if sender.tag == 1 {
//            if areFieldsEmpty(firstNameField: firstNameTF/*, lastNameField: lastNameTF*/) {
//                showAlert(message: "Please enter your full name", yesNo: "OK")
//            } else if firstNameTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == fullName?.trimmingCharacters(in: .whitespacesAndNewlines) {
//                showToast(message: "Please Enter name as per your gov ID")
//            } else if verfiedMsg == "User Verification is not completed!" {
//                
//                // ✅ Only call Register API here
//                self.activityIndicator.startAnimating()
//                sender.isUserInteractionEnabled = true
//                self.dismissKeyboard()
//                self.callRegisterWebService {
//                    self.stopLoader(sender)
//                    self.dismiss(animated: true) {
//                        sender.isUserInteractionEnabled = false
//                        self.onUpdateSuccess?(self.awaitStatusModel?.status ?? "")
//                    }
//                    print("✅ Register API Call Done (without Await Status)")
//                }
//                
//            } else {
//                let firstName = firstNameTF.text ?? ""
//    //            let lastName = lastNameTF.text ?? ""
//
//                // ✅ Check for English-only names
//                if !isEnglishOnly(firstName)/* || !isEnglishOnly(lastName)*/ {
//                    showAlert(message: "Please enter name in English only.", yesNo: "OK")
//                    return
//                }
//
//                // ✅ Proceed with API
//                self.activityIndicator.startAnimating()
//                sender.isUserInteractionEnabled = true
//                self.dismissKeyboard()
//                self.callRegisterWebService {
//                    self.callAwaitStatusapiWebService { success in
//                        if success {
//                            self.stopLoader(sender)
//                            self.dismiss(animated: true) {
//                                sender.isUserInteractionEnabled = false
//                                self.onUpdateSuccess?(self.awaitStatusModel?.message ?? "")
//                            }
//                            print("✅ Await Status API Call Done")
//                        } else {
//                            print("❌ Await Status API failed")
//                        }
//                    }
//                }
//            }
//        }
//    }
    
    @IBAction func btnUpdateAction(_ sender: CustomButton) {
            if sender.tag == 0 {
                print("Cancel Button is tapped")
                self.dismiss(animated: true)
            } else if sender.tag == 1 {
                if areFieldsEmpty(firstNameField: firstNameTF/*, lastNameField: lastNameTF*/) {
                    showAlert(message: "Please enter your full name", yesNo: "OK")
                } else if containsBadWords(firstNameTF.text ?? "") {
                    let message = """
                    Inappropriate content!
                    This name goes against our community guidelines.
                    Please keep things respectful.
                    """
                    showAlert(message: message, yesNo: "OK")
                    return
                }
                else if firstNameTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == fullName?.trimmingCharacters(in: .whitespacesAndNewlines) {
                    showToast(message: "Please Enter name as per your gov ID")
                } else if verfiedMsg == "User Verification is not completed!" {
                    self.activityIndicator.startAnimating()
                    sender.isUserInteractionEnabled = true
                    self.dismissKeyboard()
                    self.callRegisterWebService {
                        self.stopLoader(sender)
                        self.dismiss(animated: true) {
                            sender.isUserInteractionEnabled = false
                            self.onUpdateSuccess?(self.awaitStatusModel?.status ?? "")
                        }
                        print("✅ Register API Call Done (without Await Status)")
                    }
                    
                } else {
                    let firstName = firstNameTF.text ?? ""
        //            let lastName = lastNameTF.text ?? ""

                    // ✅ Check for English-only names
                    if !isEnglishOnly(firstName)/* || !isEnglishOnly(lastName)*/ {
                        showAlert(message: "Please enter name in English only.", yesNo: "OK")
                        return
                    }

                    // ✅ Proceed with API
                    self.activityIndicator.startAnimating()
                    sender.isUserInteractionEnabled = true
                    self.dismissKeyboard()
                    self.callRegisterWebService {
                        self.callAwaitStatusapiWebService { success in
                            if success {
                                self.stopLoader(sender)
                                self.dismiss(animated: true) {
                                    sender.isUserInteractionEnabled = false
                                    self.onUpdateSuccess?(self.awaitStatusModel?.message ?? "")
                                }
                                print("✅ Await Status API Call Done")
                            } else {
                                print("❌ Await Status API failed")
                            }
                        }
                    }
                }
            }
        }



    
    //MARK: - AwaitStatus api
    
    func callAwaitStatusapiWebService(_ completionClosure: @escaping (Bool) -> Void) {
        let id = UserDefaults.standard.string(forKey: "userid") ?? ""

        let dictParams: [String: Any] = [
            "userid": id
        ]

        WebService.sharedInstance.callAwaitStatusWebService(withParams: dictParams) { data in
            self.awaitStatusModel = data

            DispatchQueue.main.async {
                completionClosure(true)
            }
        }
    }
    
    
}

// MARK: - Extension for Controller
@available(iOS 16.0, *)
extension EditNameVC {
    
    // MARK: function for Register Web Service
    func callRegisterWebService( completionClosure: @escaping () -> ()) {
        let dictParams: [String: Any] = [
            "userid": userId ?? "",
            "name": self.firstNameTF.text ?? "",
//            "lastname": self.lastNameTF.text ?? "",
        ]
        print("Param is : \(dictParams)")
        WebService.sharedInstance.callRegisterWebService(withParams: dictParams) { data in
            self.registerData = data
            if self.registerData?.status == "success" {
                self.dismiss(animated: true) {
                    self.onUpdateSuccess?(self.awaitStatusModel?.message ?? "")
                }
                completionClosure()
            } else {
                self.showAlert(Message: self.registerData?.message ?? "")
            }
        }
    }
    
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
