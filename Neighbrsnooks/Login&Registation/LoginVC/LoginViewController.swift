//
//  LoginViewController.swift
//  NeighbrsNook Latest
//
//  Created by Rajat Rao on 19/02/24.
//

import UIKit
import Kingfisher
import FirebaseMessaging
import IQKeyboardManagerSwift
protocol UserIDReceivable: AnyObject {
    var userId: String? { get set }
    var sourceScreen: String? { get set }
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
    
    var fireBaseToken : UpdateTokenModel?
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
        print(dictParams)
        
        WebService.sharedInstance.callLoginWebService(withParams: dictParams) { data in
            self.loginData = data
            
            print("Full API Response: \(String(describing: data))")
            
            guard let loginData = self.loginData else {
                print("Login data is nil.")
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
                
                // ✅ Firebase token update call
                Messaging.messaging().token { token, error in
                    if let error = error {
                        print("❌ Error fetching FCM token: \(error.localizedDescription)")
                    } else if let token = token, let userId = userIdString {
                        print("🔥 Got FCM token after login: \(token)")
                        self.callUpdateFirebaseTokenPostWebService(userId: userId, firebaseToken: token) {
                            print("📡 Firebase token updated successfully")
                            completionClosure() // 🚀 call after firebase token update
                        }
                    } else {
                        // Agar token nahi mila, tab bhi continue
                        completionClosure()
                    }
                }
                
                print("✅ Login successful. Proceeding...")
                completionClosure()
            } else {
                if let message = loginData.message {
                    let userId = UserDefaults.standard.string(forKey: "userid")
                    print("⚠️ Redirecting based on message: \(message), UserID: \(userId ?? "nil")")
                    switch message {
                    case "Address Incomplete",
                         "DOB Incomplete",
                         "You can't login, Kindly wait Nighborhood assign soon by Admin",
                         "You can login, Neighbourhood could not be found then take him to address page":

                        self.navigateToViewController(
                            identifier: "NewRegistationSecondStepVC",
                            userId: userId,
                            sourceScreen: "FirstSteep"
                        )

                    default:
                        self.alertToast(Message: message)
                    }

                }
            }
        }
    }

    
    // MARK: - Call api firebaseToken // dev
    func callUpdateFirebaseTokenPostWebService(userId: String, firebaseToken: String, _ completionClosure: @escaping () -> ()) {
        let urlString = "https://dev.neighbrsnook.com/admin/api/update-token"
        guard let url = URL(string: urlString) else {
            print("❌ Invalid URL")
            return
        }
        
        let dictParams: [String: Any] = [
            "userid": userId,
            "firebase_token": firebaseToken
        ]
        
        print("📤 Request Params for UpdateToken API: \(dictParams)")
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer ", forHTTPHeaderField: "Authorization") // ✅ agar token chahiye toh yahaan add karo
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dictParams, options: [])
            request.httpBody = jsonData
        } catch {
            print("❌ Error encoding parameters: \(error.localizedDescription)")
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ Request error: \(error.localizedDescription)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("📡 Response Status Code: \(httpResponse.statusCode)")
            }
            
            guard let data = data else {
                print("❌ No response data received")
                return
            }
            
            // ✅ Raw JSON print karo
            if let jsonString = String(data: data, encoding: .utf8) {
                print("📥 Raw Response: \(jsonString)")
            }
            
            // ✅ Agar aapko UpdateTokenModel decode karna hai
            do {
                let decodedResponse = try JSONDecoder().decode(UpdateTokenModel.self, from: data)
                print("✅ Decoded Response: \(decodedResponse)")
            } catch {
                print("❌ JSON Decode Error: \(error.localizedDescription)")
            }
            
            DispatchQueue.main.async {
                completionClosure()
            }
        }
        
        task.resume()
    }


    
}

extension UIViewController {
    func navigateToViewController(identifier: String, userId: String? = nil, sourceScreen: String? = nil) {
        if let viewController = storyboard?.instantiateViewController(withIdentifier: identifier) {
            
            // ✅ Agar destination NewRegistationSecondStepVC hai
            if let step2VC = viewController as? NewRegistationSecondStepVC {
                step2VC.userId = userId
                step2VC.sourceScreen = sourceScreen
            }

            navigationController?.pushViewController(viewController, animated: true)
        } else {
            print("❌ Failed to navigate: \(identifier)")
        }
    }
}
