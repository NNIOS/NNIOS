//
//  LoginViewController.swift
//  NeighbrsNook Latest
//
//  Created by Rajat Rao on 19/02/24.
//

import UIKit
import Kingfisher


protocol UserIDReceivable {
    var userId: String? { get set }
}


@available(iOS 16.0, *)
class LoginViewController: BaseViewController {
    
    @IBOutlet weak var tfMobile: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var btnEye: UIButton!
    @IBOutlet weak var EventPostPrcntgLbl: UILabel!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var btnPassword: UIButton!
    @IBOutlet weak var btnRegister: UIButton!
    
    
    var show = false
    var loginData : LoginModel?
    // irshad code
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
//        updateColors()
          EventPostPrcntgLbl.font = UIFont(name: "Montserrat-Regular", size: 16)
        
         self.additionalSafeAreaInsets.top = -50
         // Do any additional setup after loading the view.
    }
    
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        updateColors()
//    }
    
//    private func updateColors() {
//        if traitCollection.userInterfaceStyle == .dark {
//            // Dark mode colors
//            loginView.backgroundColor = .black
////            tfMobile.backgroundColor = .black
////            tfPassword.backgroundColor = .black
//            emailView.layer.borderColor = #colorLiteral(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1)
//            passwordView.layer.borderColor = #colorLiteral(red: 0.1607843137, green: 0.1647058824, blue: 0.1843137255, alpha: 1)
//             emailView.backgroundColor = .black
//            passwordView.backgroundColor = .black
//             emailView.layer.borderWidth = 1.0 // Enable border in dark mode
//            passwordView.layer.borderWidth = 1.0
//            EventPostPrcntgLbl.textColor =  #colorLiteral(red: 0.7058823529, green: 0.7254901961, blue: 0.7843137255, alpha: 1)
//            btnPassword.setTitleColor(#colorLiteral(red: 0.7058823529, green: 0.7254901961, blue: 0.7843137255, alpha: 1), for: .normal)
//            btnRegister.setTitleColor(#colorLiteral(red: 0.7058823529, green: 0.7254901961, blue: 0.7843137255, alpha: 1), for: .normal)
//         } else {
//            // Light mode mein storyboard ke original colors preserve karna
//          //  questionView.textColor = UIColor.secondaryLabel
//            emailView.isUserInteractionEnabled = true
//            passwordView.isUserInteractionEnabled = true
//            tfMobile.backgroundColor = .white
//            tfPassword.backgroundColor = .white
//             emailView.layer.borderWidth = 0 // Remove border in light mode
//            passwordView.layer.borderWidth = 0
//             loginView.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.968627451, blue: 0.9411764706, alpha: 1)
//            
//        }
//      //  lblTime.textColor = UIColor.secondaryLabel // Dynamic system color
//    }
//    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
//        super.traitCollectionDidChange(previousTraitCollection)
//        
//        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
//            updateColors()
//        }
//    }
    
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
    // old registation   RegisterViewController new  RegistationFirstStepVC
    
    @IBAction func btnRegister(_ : UIButton){
        
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegistationFirstStepVC") as? RegistationFirstStepVC else {return}
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func btnForget(_ : UIButton){
        
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ForgotViewController") as? ForgotViewController else {return}
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func LoginBtn(_ sender: UIButton){
        
        // Mobile and Password Check
        if tfMobile.text == "" {
//            showCustomAlert(message: "Please enter your mobile number")
            alertToast(Message: "Please enter your mobile number")

//            let alert = UIAlertController(title: "", message: "Please enter your mobile number", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
            
        } else if tfPassword.text == "" {
            alertToast(Message: "Please enter password")

//            let alert = UIAlertController(title: "", message: "Please enter password", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
            
        } else {
            // Call the login web service
            callLoginWebService { [weak self] in
                guard let self = self else { return }
                
                // Ensure loginData is not nil
                guard let loginData = self.loginData else {
                    print("Login data is nil.")
                    return
                }
                
                // Check if message exists in the loginData
                if let message = loginData.message {
                    print("Received Message: \(message)") // Debugging log
                    
                    // Trim and convert message to lowercase for case-insensitive matching
                    let trimmedMessage = message.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                    
                    switch trimmedMessage {
                    case "login successfully.":
                        print("Navigating to NeigbrnookViewController")
                        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "NeigbrnookViewController") as? NeigbrnookViewController {
                            self.navigationController?.pushViewController(vc, animated: false)
                        }
                    case "address incomplete":
                        print("Navigating to NewRegistationSecondStepVC")
                        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "NewRegistationSecondStepVC") as? NewRegistationSecondStepVC {
                            if let userId = UserDefaults.standard.string(forKey: "userid") {
                                // Assuming destination controller has a property `userId`
                                (vc as? NewRegistationSecondStepVC)?.userId = userId
                            }
                            self.navigationController?.pushViewController(vc, animated: false)
                        }
                    case "dob incomplete":
                        print("Navigating to RegisterFirstViewController")
                        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegistationAdressProofVC") as? RegistationAdressProofVC {
                            if let userId = UserDefaults.standard.string(forKey: "userid") {
                                // Assuming destination controller has a property `userId`
                                (vc as? RegisterFirstViewController)?.userId = userId
                            }
                            self.navigationController?.pushViewController(vc, animated: false)
                        }
                        
                    
                    default:
                        print("Showing alert for message: \(message)")
//                        self.showCustomAlert(message: message)
                        alertToast(Message: message)
                        
                    }
                } else {
                    print("No message received in response.")
                }
            }
            
        }
    }
    
    func showCustomAlert(message: String) {
        let alert = UIAlertController(title: "", message: nil, preferredStyle: .alert)
        
        let attributedMessage = NSAttributedString(
            string: message,
            attributes: [
                .font: UIFont(name: "Montserrat-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16),
                .foregroundColor: UIColor.black
            ])
        
        alert.setValue(attributedMessage, forKey: "attributedMessage")
        
        let closeAction = UIAlertAction(title: "Close", style: .default, handler: nil)
        closeAction.setValue(UIColor.systemBlue, forKey: "titleTextColor") // Optional: Change button color
        alert.addAction(closeAction)
        
        self.present(alert, animated: true, completion: nil)
    }

    
    
    func callLoginWebService(_ completionClosure: @escaping () -> Void) {
        let dictParams: [String: Any] = [
            "mobtoken": FunctionsConstants.kSharedUserDefaults.deviceToken(),
            "login": tfMobile.text ?? "",
            "pass": tfPassword.text ?? ""
        ]
        
        WebService.sharedInstance.callLoginWebService(withParams: dictParams) { data in
            self.loginData = data
            
            print("Full API Response: \(String(describing: data))")
            
            guard let loginData = self.loginData else {
                print("Login data is nil.")
//                self.showAlert(Message: "Unable to process response.")
                self.alertToast(Message: "Unable to process response.")
                return
            }
            
            // ✅ Step 1: Get user ID from logindata OR root-level
            let userIdString: String? = {
                if let id = loginData.logindata?.id {
                    return "\(id)"
                } else if let id = loginData.id {
                    return id
                } else {
                    return nil
                }
            }()
            
            if let userId = userIdString {
                UserDefaults.standard.set(userId, forKey: "userid")
                UserDefaults.standard.synchronize()
                print("✅ User ID saved: \(userId)")
            } else {
                print("❌ User ID not found.")
            }
            
            // ✅ Step 2: Handle success or failure
            if loginData.status == "success", let logindata = loginData.logindata {
                UserDefaults.standard.set(logindata.username, forKey: "username")
                UserDefaults.standard.set(logindata.neighbrshood, forKey: "neighbrshood")
                UserDefaults.standard.set(logindata.userphoto, forKey: "userphoto")
                UserDefaults.standard.set(true, forKey: "isRegistered")
                UserDefaults.standard.set("done", forKey: "registrationStep") // ✅ Add this
                UserDefaults.standard.synchronize()
                
                print("✅ Login successful. Proceeding...")
                completionClosure()
            } else {
                if let message = loginData.message {
                    let userId = UserDefaults.standard.string(forKey: "userid")
                    print("⚠️ Redirecting based on message: \(message), UserID: \(userId ?? "nil")")
                    
                    switch message {
                    case "Address Incomplete":
                        self.navigateToViewController(identifier: "NewRegistationSecondStepVC", type: NewRegistationSecondStepVC.self, userId: userId)
                    case "DOB Incomplete":
                        self.navigateToViewController(identifier: "NewRegistationSecondStepVC", type: NewRegistationSecondStepVC.self, userId: userId)
                    case "You can't login, Kindly wait Nighborhood assign soon by Admin":
                           self.navigateToViewController(identifier: "NewRegistationSecondStepVC", type: NewRegistationSecondStepVC.self, userId: userId)
                    case "You can login, Neighbourhood could not be found then take him to address page":
                           self.navigateToViewController(identifier: "NewRegistationSecondStepVC", type: NewRegistationSecondStepVC.self, userId: userId)
                          
                    default:
//                        self.showCustomAlert(message: message)
                        self.alertToast(Message: message)                    }
                }
            }
        }
    }

    
    
}


extension UIViewController {
    func navigateToViewController<T: UIViewController>(identifier: String, type: T.Type, userId: String? = nil) {
        if let viewController = storyboard?.instantiateViewController(withIdentifier: identifier) as? T {
            print("Navigating to \(identifier) successfully.")
            
            // 👇 Pass userId if destination view controller has that property
            if let userId = userId {
                if var vc = viewController as? UserIDReceivable {
                    vc.userId = userId
                }
            }
            
            navigationController?.pushViewController(viewController, animated: true)
        } else {
            print("Failed to find or cast view controller with identifier: \(identifier).")
            print("Ensure storyboard ID and custom class mapping are correct.")
        }
    }
}

