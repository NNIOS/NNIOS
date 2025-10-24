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
    var referNeighbourhoodID: String?
    var referNeighbourhoodName: String?
    // irshad code
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
       
      

          EventPostPrcntgLbl.font = UIFont(name: "Montserrat-Regular", size: 16)
        
         self.additionalSafeAreaInsets.top = -50
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
    
    @IBAction func LoginBtn(_ sender: UIButton) {
        if tfMobile.text?.isEmpty ?? true {
            alertToast(Message: "Please enter your mobile number")
            return
        } else if tfPassword.text?.isEmpty ?? true {
            alertToast(Message: "Please enter password")
            return
        }
        
        callLoginWebService { [weak self] in
            guard let self = self else { return }
            
            guard let loginData = self.loginData else {
                print("Login data is nil.")
                return
            }
            
            guard let message = loginData.message?.trimmingCharacters(in: .whitespacesAndNewlines) else {
                print("No message received in response.")
                return
            }
            
            print("Received Message: \(message)")
            
            // ✅ Save message for next auto login
            UserDefaults.standard.set(message.lowercased(), forKey: "loginMessage")
            UserDefaults.standard.synchronize()
            
            switch message.lowercased() {
                
            case "login successfully.":
                print("Navigating to NeigbrnookViewController")
                if let vc = self.storyboard?.instantiateViewController(withIdentifier: "NeigbrnookViewController") as? NeigbrnookViewController {
                    self.navigationController?.pushViewController(vc, animated: false)
                }
                
            case "address incomplete":
                print("Navigating to NewRegistationSecondStepVC (Address Incomplete)")
                if let vc = self.storyboard?.instantiateViewController(withIdentifier: "NewRegistationSecondStepVC") as? NewRegistationSecondStepVC {
                    
                    if let userId = UserDefaults.standard.string(forKey: "userid") {
                        vc.userId = userId
                        vc.referNeighbourhoodID = self.referNeighbourhoodID
                        vc.referNeighbourhoodName = self.referNeighbourhoodName
                        vc.sourceScreen = "FirstSteep"
                    }

                    // ✅ Safe optional check to avoid ambiguity
                    if let referralStatus = self.loginData?.referral_status, referralStatus == 1 {
                        vc.selectedLocation = self.loginData?.refer_neighbourhood_name ?? ""
                        vc.city = self.loginData?.refer_city_name ?? ""
                        vc.state = self.loginData?.refer_state_name ?? ""
                        vc.zipcode = self.loginData?.refer_pincode ?? "" // ✅ Convert Int? to String
                        vc.referralStatus = self.loginData?.referral_status
                    }


                    self.navigationController?.pushViewController(vc, animated: false)
                }
                
            case "you can login, neighbourhood could not be found then take him to address page":
                print("Navigating to NewRegistationSecondStepVC (Neighbourhood not found)")
                if let vc = self.storyboard?.instantiateViewController(withIdentifier: "NewRegistationSecondStepVC") as? NewRegistationSecondStepVC {
                    if let userId = UserDefaults.standard.string(forKey: "userid") {
                        vc.userId = userId
                        vc.referNeighbourhoodID = self.referNeighbourhoodID
                        vc.referNeighbourhoodName = self.referNeighbourhoodName
                        vc.sourceScreen = "FirstSteep"
                    }
                    if let referralStatus = self.loginData?.referral_status, referralStatus == 1 {
                        vc.selectedLocation = self.loginData?.refer_neighbourhood_name ?? ""
                        vc.city = self.loginData?.refer_city_name ?? ""
                        vc.state = self.loginData?.refer_state_name ?? ""
                        vc.zipcode = self.loginData?.refer_pincode ?? ""
                        vc.referralStatus = self.loginData?.referral_status
                    }
                    self.navigationController?.pushViewController(vc, animated: false)
                }
                
            case "dob incomplete":
                print("Navigating to RegistationAdressProofVC (DOB Incomplete)")
                if let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegistationAdressProofVC") as? RegistationAdressProofVC {
                    if let userId = UserDefaults.standard.string(forKey: "userid") {
                        vc.userId = userId
                        vc.referNeighbourhoodID = self.referNeighbourhoodID
                        vc.referNeighbourhoodName = self.referNeighbourhoodName
                    }
                    self.navigationController?.pushViewController(vc, animated: false)
                }
                
            default:
                print("Showing alert for message: \(message)")
                alertToast(Message: message)
            }
        }
    }



    func callLoginWebService(_ completionClosure: @escaping () -> Void) {
        UserDefaults.standard.set(self.tfMobile.text ?? "", forKey: "savedPhoneNumber")
        let dictParams: [String: Any] = [
            "mobtoken": FunctionsConstants.kSharedUserDefaults.deviceToken(),
            "login": tfMobile.text ?? "",
            "pass": tfPassword.text ?? ""
        ]
        print("📩 Login API Params: \(dictParams)")
        
        WebService.sharedInstance.callLoginWebService(withParams: dictParams) { data in
            self.loginData = data
            
            print("📦 Full API Response: \(String(describing: data))")
            
            guard let loginData = self.loginData else {
                print("❌ Login data is nil.")
                self.alertToast(Message: "Unable to process response.")
                return
            }
            
            // ✅ Extract userId (check both places)
            var userIdString: String?
            if let id = loginData.logindata?.id {
                userIdString = "\(id)"
            } else if let id = loginData.id {
                userIdString = id
            }
            
            if let userId = userIdString {
                UserDefaults.standard.set(userId, forKey: "userid")
                print("✅ User ID saved: \(userId)")
            }

            // ✅ Save neighbourhood data (if available)
            if let referID = loginData.refer_neighbourhood_id {
                UserDefaults.standard.set(referID, forKey: "referNeighbourhoodID")
                print("✅ referNeighbourhoodID saved: \(referID)")
            }

            if let referName = loginData.refer_neighbourhood_name {
                UserDefaults.standard.set(referName, forKey: "referNeighbourhoodName")
                print("✅ referNeighbourhoodName saved: \(referName)")
            }

            // ✅ Save referralStatus properly (Int)
            if let refStatus = loginData.referral_status {
                UserDefaults.standard.set(refStatus, forKey: "referralStatus")
                print("✅ referralStatus saved: \(refStatus)")
            } else {
                print("⚠️ referralStatus is nil in API response.")
            }

            UserDefaults.standard.synchronize() // optional, ensures immediate write
            print("🧠 Saved Data in UserDefaults:")
            print("UserID: \(UserDefaults.standard.string(forKey: "userid") ?? "nil")")
            print("referNeighbourhoodID: \(UserDefaults.standard.string(forKey: "referNeighbourhoodID") ?? "nil")")
            print("referNeighbourhoodName: \(UserDefaults.standard.string(forKey: "referNeighbourhoodName") ?? "nil")")
            print("referralStatus: \(UserDefaults.standard.integer(forKey: "referralStatus"))")

            // ✅ Firebase token update
            if loginData.status == "success", let _ = loginData.logindata {
                Messaging.messaging().token { token, error in
                    if let error = error {
                        print("❌ Error fetching FCM token: \(error.localizedDescription)")
                        completionClosure()
                    } else if let token = token, let userId = userIdString {
                        print("🔥 Got FCM token after login: \(token)")
                        self.callUpdateFirebaseTokenPostWebService(userId: userId, firebaseToken: token) {
                            print("📡 Firebase token updated successfully")
                            completionClosure()
                        }
                    } else {
                        completionClosure()
                    }
                }
            } else {
                completionClosure()
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
