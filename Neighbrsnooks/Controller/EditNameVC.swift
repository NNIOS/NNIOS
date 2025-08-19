//
//  EditNameVC.swift
//  Neighbrsnooks
//
//  Created by Abdul Aleem on 28/05/25.
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
    var registerData : RegisterModel?
    var awaitStatusModel : AwaitStatusModel?
    var onUpdateSuccess: ((_ range: String) -> Void)?
    var activityIndicator = UIActivityIndicatorView(style: .large)
    // MARK: - LifeCycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActivityIndicator()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        self.lblEditName.font = UIFont(name: "Montserrat-Regular", size: 19)
        self.firstNameTF.font = UIFont(name: "Montserrat-Regular", size: 15)
        self.lastNameTF.font = UIFont(name: "Montserrat-Regular", size: 15)
        firstNameTF.setPadding(left: 10)
        lastNameTF.setPadding(left: 10)
        firstNameTF.text = fName
        lastNameTF.text = lName
        userId = UserDefaults.standard.string(forKey: "userid")
        firstNameTF.autocapitalizationType = .words
        lastNameTF.autocapitalizationType = .words
        print("User id is : \(userId ?? "")")
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
    
    @IBAction func btnUpdateAction(_ sender: CustomButton) {
        if sender.tag == 0 {
            print("Cancel Button is tapped")
            self.dismiss(animated: true)
        } else if sender.tag == 1 {
            if areFieldsEmpty(firstNameField: firstNameTF/*, lastNameField: lastNameTF*/) {
//                showAlert(message: "Please fill in both first name and last name.", yesNo: "OK")
                showAlert(message: "Please enter your full name", yesNo: "OK")
            } else {
                let firstName = firstNameTF.text ?? ""
//                let lastName = lastNameTF.text ?? ""

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
